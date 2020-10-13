require "smarter_csv"

class Member < ApplicationRecord
  attribute :message, :text
  belongs_to :post
  attr_accessor :applicant
  validates :vfw_id, uniqueness: true, presence:true
  before_save :fix_name
  default_scope {order(:full_name) }


  PayStatus = ["Life Member","Installment Life", "Continuous", "UnPaid", "New Member", "Non-Pay Transfer", "Continuous Transfer", "Reinstate", "Deceased", "Missing", "Applicant"]

  def new_applicant(applicant)
    stuff = ""
    applicant.each do |k,v|
      stuff += "#{k}:#{v.to_s}\n"
    end
    self.pay_status = "Applicant"
    self.vfw_id = 1 - Current.post.members.count
    self.served = stuff
    if self.valid?
      return self.save
    else
      return false
    end
  end

  def active?
    !['Missing','Deceased', 'Applicant'].include?(self.pay_status)
  end

  def self.search(params)
    members = Current.post.members.active
    # puts "WHAT PARAMS #{params}"
    unless params[:name].blank?
      if params[:name].include?(":where,")
        # Backdoor hidden where clause
        q =  params[:name].split(":where,")
        # p "DDDDDD #{q}"
        members = members.active.send(:where,q[1])
      else
        words = params[:name].split unless words.class == Array
        words.map!{|v| "%#{v}%"}
        name_query = members.where(Member.arel_table[:full_name].matches_any(words))
        city_query = members.where(Member.arel_table[:city].matches_any(words))
        name_ids = name_query.pluck(:id)
        city_ids = city_query.pluck(:id)
        # pin_ids = Player.where(pin_query).pluck(:id)
        all_ids = (name_ids + city_ids ).uniq
        members = members.where(id:all_ids )
        # puts "SEARCJ #{members.count}"
      end
    end
    members.order(:full_name)
  end


  def self.active
    # Current.post.members.where('members.pay_status != ? AND  members.pay_status != ? AND  members.pay_status != ?','Missing','Deceased', 'Applicant')
    # Current.post.members.where('members.pay_status != ? AND  members.pay_status != ? AND  members.pay_status != ?','Missing','Deceased', 'Applicant')
    Current.post.members.where.not(pay_status:['Missing','Deceased', 'Applicant'])
  end

  def self.memstats
    stats = {}
    PayStatus.each do |s|
      stats[s] = Current.post.members.where(pay_status:s).count
    end
    all = Current.post.members.all
    active = all.active
    paying = active.where(pay_status:'UnPaid').where.not(paid_thru:nil)
    puts paying
    stats['Active'] = active.count
    stats['All'] = all.count
    stats['ExpiredPaid'] = paying.where('members.paid_thru > ?',Date.today.to_s).count
    stats["Expired30"] = paying.where('members.paid_thru > ?',(Date.today + 30.days).to_s).count
    stats["Expired60"] = paying.where('members.paid_thru > ?',(Date.today + 60.days).to_s).count
    stats["Expired90"] = paying.where('members.paid_thru > ?',(Date.today + 90.days).to_s).count

    good = stats['Life Member'] + stats['Installment Life']+ stats['Continuous'] + stats['New Member'] + stats['Non-Pay Transfer'] + stats['Continuous Transfer'] + stats['Reinstate']
    stats['Paid'] = stats['ExpiredPaid'] + good
    stats['Paid30'] = stats['Expired30'] + good
    stats['Paid60'] = stats['Expired60'] + good
    stats['Paid90'] = stats['Expired90'] + good
    stats['Expired'] = stats['Active'] - stats['Paid']
    stats
  end

  def self.contact_addresses(status=nil)
    active = Current.post.members.where.not(pay_status:['Missing','Deceased', 'Applicant']).order(:full_name)
    if status.present?
      active = active.where(pay_status:status)
    end
    email = ""
    address =  "first_name,mi,last_name,address,city,state,zip,status,paid_thru,age,undeliverable\n"
    active.each do |m|
      if m.email.present?
        email += "#{m.name_first_last} <#{m.email}>,"
      end
      address += "#{m.first_name},#{m.mi},#{m.last_name},#{m.address},#{m.city},#{m.state},#{m.zip},#{m.pay_status},#{m.paid_thru},#{m.age},#{m.undeliverable}\n"
    end
    email = email[0..-2]
    return email, address
  end

  def self.limit(status,thru_date=nil)
    thru_date = Date.today if thru_date.nil?
    members = Current.post.members.order(:full_name)
    if PayStatus.include?(status)
      results = members.where(pay_status:status)
    else
      all = Current.post.members.all
      active = Current.post.members.active.order(:full_name)
      vfw_paid = active.where(pay_status:["Life Member","Installment Life","Continuous", "New Member", "Reinstate"])
      paying = active.where(pay_status:'UnPaid').where.not(paid_thru:nil)
      expired_paid = paying.where('members.paid_thru > ?',thru_date.to_s)
      paid = vfw_paid.pluck(:id) + expired_paid.pluck(:id)
      expired = active.pluck(:id) - paid
      case status
      when 'All'
        results = all
      when "Active"
        results = active
      when "ExpiredPaid"
        results = paying.where('members.paid_thru > ?',thru_date.to_s)
      when "Paid"
        results = Current.post.members.where(id: paid)
      when "Expired"
        results = Current.post.members.where(id:expired)
      end

    end
    return results.order(:full_name)
  end

  def to_label
    "#{full_name}"
  end

  def name
    "#{self.last_name}, #{self.first_name} #{self.mi}"
  end
  
  def name_first_last
    "#{self.first_name} #{self.last_name}"
  end

  def email_valid?
  end

  def let_alone?(str)
    char1 = str[0..0]
    rest = str[1..-1]
    # let name starting with upercase, then lowercase, than any other uppercase alone (LaPoint)
    upper_alone = char1.match(/[A-Z]/).present? && rest.match(/[a-z]/).present? && rest.match(/[A-Z]/).present?
    # let name starting with lowercase and having any uppercase alone (daHammer)
    lower_alone = char1.match(/[a-z]/).present? && rest.match(/[A-Z]/).present? 
    return upper_alone || lower_alone
  end

  
  def fix_name
    # remove any leading/trailing spaces
    first = self.first_name.strip
    last = self.last_name.strip
    # get rid of all caps
    first = first.titlecase if first == first.upcase
    last = last.titlecase if last == last.upcase
    #set to titlecase unless mixed cases in let_alone?
    self.first_name = let_alone?(first) ? first : first.titlecase
    self.last_name = let_alone?(last) ? last : last.titlecase
    self.full_name = self.name
    self.mi = self.mi.capitalize if self.mi.present? && /[A-Z]/.match(self.mi).nil?
  end

  def self.import(file)
   vfw_ids = []
   # aa = SmarterCSV.process('/users/salex/downloads/stevelist.csv',strip_chars_from_headers: /[^A-Za-z0-1_,]/, 
   #   key_mapping: {middle_initial: :mi, pay_type: :type_pay,pay_description: :pay_status,card_number: :vfw_id,year: :pay_year, post: nil})
   
   aa = SmarterCSV.process(file.path,strip_chars_from_headers: /[^A-Za-z0-9_,]/, 
     key_mapping: {middle_initial: :mi, current_type: :pay_status,
      card_number: :vfw_id,year: :pay_year, post: nil,autopay: nil,memstat_type: :status, paid_until: :paid_thru})
   aa.each do |row|
     vfw_ids << row[:vfw_id].to_i
     member = Current.post.members.find_or_initialize_by(:vfw_id => row[:vfw_id])
     address = row[:address1]
     address += "; #{row[:address2].strip}" if row[:address2]
     address += "; #{row[:address3].strip}" if row[:address3]
     unless row[:paid_thru].blank?
       row[:paid_thru] = Chronic.parse(row[:paid_thru]).to_date
     end
     row[:address] = address
     row.delete(:address1)
     row.delete(:address2)
     row.delete(:address3)
     row.delete(:suffix)
     row[:email] =  row[:email].strip if row[:email].present?
     ok = member.update(row)
     unless ok
      p member.errors
    end
   end
   
   active = Current.post.members.pluck(:vfw_id)
   missing = active - vfw_ids
   missing.each do |m|
     member = where(:vfw_id => m).first
     if member
       member.last_status = "#{member.pay_status} #{Date.today}" unless member.pay_status == 'Missing'
       member.pay_status = "Missing"
       member.save!
     end
   end
  end


  # def self.ilike_contains_query(column,keys)
  #   keys = keys.split unless keys.class == Array
  #   values = keys.map{|v| "%#{v}%"}
  #   ilike = [keys.map {|i| "#{column} ILiKE ? "}.join(" OR "), *values ]
  # end

end
