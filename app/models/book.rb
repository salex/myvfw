class Book < ApplicationRecord
  belongs_to :client
  has_many :accounts, dependent: :destroy
  has_many :entries, dependent: :destroy
  # acts_as_tenant(:client)
  serialize :settings, JSON
  # attribute :tree_ids
  attribute :acct_transfers
  attribute :acct_placeholders
  attribute :checking_ids

  after_initialize :set_attributes
  
  #helpers to set or get attributes/settings
  def acct_tree_ids
    unless self.settings.blank?
      self.acct_transfers.keys 
    end
  end

  def acct_sel_opt
    unless self.settings.blank?
      self.acct_transfers.map{|k,v| [v,k]}.prepend(['',0])
    end
  end

  def acct_sel_opt_rev
    unless self.settings.blank?
      self.acct_sel_opt.select{|i| i  unless self.acct_placeholders.include?(i[1])}.
        map{|i|[ i[0].
        split(':').reverse.join(':'),i[1]]}.
        sort_by { |word| word[0].downcase }
    end
  end

  def set_attributes
    unless self.settings.blank?
      self.acct_transfers = settings['transfers']
      self.acct_placeholders = settings['acct_placeholders']
      self.checking_ids = settings['checking_ids']
    end
  end

  def build_tree
    new_tree = []
    troot = self.root_acct
    troot.walk_tree(0,new_tree)
    new_tree.each do |a| 
      if a.level_changed?
        a.save
      end
    end
    new_tree
  end

  def destroy_book
    self.entries.destroy_all
    # self.bank_statements.destroy_all
    self.accounts.destroy_all
    self.destroy
  end


  def root_acct
    self.accounts.find_by(code:'ROOT')
  end

  def checking_acct
    self.accounts.find_by(code:'CHECKING')
  end

  def assets_acct
    self.accounts.find_by(code:'ASSET')
  end

  def liabilities_acct
    self.accounts.find_by(code:'LIABILITY')
  end

  def equity_acct
    self.accounts.find_by(code:'EQUITY')
  end

  def income_acct
    self.accounts.find_by(code:'INCOME')
  end

  def expenses_acct
    self.accounts.find_by(code:'EXPENSE')
  end

  def savings_acct
    self.accounts.find_by(code:'SAVING')
  end

  def current_assets
    self.accounts.find_by(code:'CURRENT')
  end


  def get_settings
    return {} if self.settings['skip'].present? || self.settings['tree'].present?
    reset = (Rails.application.config.x.acct_updated > self.updated_at.to_s || self.settings.blank?)
    if reset
      rebuild_settings
    end
    return self.settings
  end

  def rebuild_settings
    checking = checking_acct
    new_settings = {}
    accts = build_tree
    id_trans = accts.pluck(:id,:transfer)
    if checking.present?
      new_settings['checking_ids'] = checking.leafs
    end
    new_settings['transfers'] = id_trans.to_h
    new_settings['acct_placeholders'] = accts.select{|a| a.placeholder}.pluck(:id)
    self.settings = new_settings
    self.touch
    self.save!
  end

  # def new_rebuild_sessions
  #   accts = build_tree
  #   transfers =  accts.pluck(:id,:transfer).to_h
  #   placeholders = accts.select{|a| a.placeholder}.pluck(:id)
  #   tree_ids = transfer.keys
  #   acct_sel_opt = transfers.map{|k,v| [v,k]}.prepend(['',0])
  #   acct_sel_opt_rev = acct_sel_opt.select{|i| i  unless placeholders.include?(i[1])}.
  #     map{|i|[ i[0].split(':').reverse.join(':'),i[1]]}.
  #     sort_by { |word| word[0].downcase }
  # end

  def last_numbers(ago=6)
    from = Date.today.beginning_of_month - ago.months
    nums = self.entries.where(Entry.arel_table[:post_date].gteq(from)).pluck(:numb).uniq.sort.reverse
    obj = {numb: 0} # for numb only
    nums.each do |n|
      if n.blank? 
        next # not blank or nil
      end
      key = n.gsub(/\d+/,'')
      val = n.gsub(/\D+/,'')
      next if key+val != n # only deal with key/numb not numb/key
      is_blk  = val == '' # key only
      num_only = val == n
      if !is_blk
        val = val.to_i
        is_num = true
      else
        is_num = false
      end
      if num_only
        obj[:numb] = val if ((val > obj[:numb]) && (val < 9000))
        next
      end
      key = key.to_sym 
      unless obj.has_key?(key)
        obj[key] = val 
        next
      end
      if is_num
        obj[key] = val if val > obj[key]
        next
      else
        obj[key] = val 
      end
    end
    obj
  end

  def auto_search(params)
    desc = params[:input]
    if params[:contains].present? && params[:contains] == 'true'
      entry_ids = self.entries.where(Entry.arel_table[:description].matches("%#{desc}%"))
      .order(Entry.arel_table[:id]).reverse_order.pluck(:description,:id)
    else
      entry_ids = self.entries.where(Entry.arel_table[:description].matches("#{desc}%"))
      .order(Entry.arel_table[:id]).reverse_order.pluck(:description,:id)
    end
    filter = entry_ids.uniq{|itm| itm.first}.to_h
  end

  # TODO  this is no longer used, must be old version before auto search
  # def description_lookup(ago=6)
  #   from = Date.today.beginning_of_month - ago.months
  #   entry_ids = self.entries.where(Entry.arel_table[:post_date].gteq(from)).order(:id).reverse_order
  #     .pluck(:description,:id)
  #   lookup = {}
  #   entry_ids.each do |e|
  #     lookup[e[0].downcase] = [e[0],e[1]] unless lookup.has_key?(e[0].downcase)
  #   end
  #   arr = []
  #   lookup.each{|k,v| arr << [k,v[1],v[0]]}
  #   arr.sort.map{|i| [i[2],i[1]]}
  #   # arr.pluck(2,1)
  # end

  def contains_any_word_query(words,all=nil)
    words = words.split unless words.class == Array
    words.map!{|v| "%#{v}%"}
    query = self.entries.where(Entry.arel_table[:description].matches_any(words)).includes(:splits).order(:post_date).reverse_order
    return query if all.present?
    p = query.pluck(:description,:id)
    uids = p.uniq{ |s| s.first }.to_h.values
    query.where(id:uids).order(:post_date).reverse_order
  end

  def contains_all_words_query(words,all=nil)
    words = words.split unless words.class == Array
    words.map!{|v| "%#{v}%"}
    query = self.entries.where(Entry.arel_table[:description].matches_all(words)).includes(:splits).order(:post_date).reverse_order
    return query if all.present?
    p = query.pluck(:description,:id)
    uids = p.uniq{ |s| s.first }.to_h.values
    query.where(id:uids).order(:post_date).reverse_order
  end

  def contains_match_query(match,all=nil)
    query = self.entries.where(Entry.arel_table[:description].matches("%#{match}%")).includes(:splits).order(:post_date).reverse_order
    return query if all.present? && all == "1"
    p = query.pluck(:description,:id)
    uids = p.uniq{ |s| s.first }.to_h.values
    query.where(id:uids).order(:post_date).reverse_order
  end

  def contains_number_query(match,all=nil)
    # query = self.entries.where('entries.numb like ?',"#{match}%").order(:post_date).reverse_order
    query = self.entries.where(Entry.arel_table[:numb].matches("#{match}%")).order(:numb).reverse_order
    # puts "query.count #{match}  #{query.count}"
    return query if all.present?
    p = query.pluck(:description,:id)
    uids = p.uniq{ |s| s.first }.to_h.values
    query.where(id:uids).order(:post_date).reverse_order
  end

  def contains_amount_query(match,all=nil)
    bacct_ids = self.acct_tree_id - self.settings['dis_opt']
    eids = Split.where(account_id:bacct_ids).where(amount:match.to_i).pluck(:entry_id).uniq
    # query = self.entries.where('entries.numb like ?',"#{match}%").order(:post_date).reverse_order
    query = self.entries.where(id:eids).order(:post_date).reverse_order
    # puts "query.count #{match}  #{query.count}"
    return query if all.present?
    p = query.pluck(:description,:id)
    uids = p.uniq{ |s| s.first }.to_h.values
    query.where(id:uids).order(:post_date).reverse_order
  end


end
