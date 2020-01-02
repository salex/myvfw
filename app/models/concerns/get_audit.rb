class GetAudit 
  attr_accessor :boq,:eoq,:bolq,:eolq,:keyname,:audit,:post,:error
  def initialize(date=nil)
    @post = Current.post
    pnumb = post.numb.to_s + '-'
    if date.present?
      date = Date.parse(date) unless date.class == Date
    else
      date = Date.today
    end
    @eoq = date.beginning_of_quarter - 1.day
    @boq = eoq.beginning_of_quarter
    @eolq = boq - 1.day
    @bolq = eolq.beginning_of_quarter

    @keyname = pnumb+ eoq.to_s + "-audit"
    puts "KKKKK #{@keyname}"
    audits = post.trustee_audits.order(:key)
    # they have no audits so create from default yaml
    puts "IDIDIDIDI #{audits.pluck(:id,:key)}"
    if audits.blank?
      # puts "GOT A DEFAULT AUDIT"
      default_audit
      return self
    end

    last_audit = audits.last

    puts "LLLLLast #{last_audit.key}"

    # return last audit if key matched
    if last_audit.key == @keyname
      @audit = last_audit
      puts "GOT THE CURRENT AUDIT #{last_audit.key}"

      return self
    end

    # return error if keyname < last key
    if @keyname < last_audit.key
      # puts "GOT A ERROR ON OLDER DATE"

      @error = 'You cannot create and audit with date older than lastest audit'
      return self
    end

    keynamelq = pnumb+ eolq.to_s + "-audit"
    # puts "GOT NEW KEYNAME #{keynamelq} going to try to find it"

    prev_audit = audits.find_by(key:keynamelq)
    # puts "DID WE FIND IT> #{prev_audit.inspect}"
    if prev_audit.present?
      # create new audit and clear reset new stuff
      config = prev_audit.hash_data

      config.accounts.each do |a|
        a.beginning = a.ending
        a.debit = ''
        a.credit = ''
        a.ending = ''
      end
      # clear totals (shoud just reset, at least after first change)
      config.totals.beginning = ''
      config.totals.debit = ''
      config.totals.credit = ''
      config.totals.ending = ''
      # clear checking
      config.checking.balance = ''
      config.checking.outstanding = ''
      config.checking.actual = ''
      config.checking.other = ''
      config.checking.cash = ''
      config.checking.subtotal = ''
      config.checking.cd = ''
      config.checking.total = ''
      # puts "GOinG TO CREATE  #{keyname} FROM #{keynamelq} after reset"
      @audit = post.trustee_audits.create(key:keyname,date:@eolq,hash_data:config)
      return self
    else
      @error = 'Something is not right'
      return self
    end
  end

  def default_audit
    filepath = Rails.root.join("db/audits","vfwbase.yaml")
    config = YAML.load_file(filepath).to_o
    @audit = post.trustee_audits.create(key:keyname,date:@eoq,hash_data:config)
  end

  def fix_key_date
    ta = TrusteeAudit.all
    ta.each do |a|
      idx = a.key.index('-')+1
      dt = a.key[idx..(idx+9)]
      eoq = Date.parse(dt).end_of_quarter
      a.date = eoq
      # a.report.delete_field('date')
      # a.report.date_submitted = a.date.to_s
      a.text_data = ""
      a.report.keyname = a.key
      a.report.id = a.id
      a.save
    end
  end

end
