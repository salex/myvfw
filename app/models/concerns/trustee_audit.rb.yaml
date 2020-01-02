class TrusteeAudit
  attr_accessor :config
  def initialize(date=nil)
    post = Current.post.numb.to_s + '-'
    if date.present?
      date = Date.parse(date) unless date.class == Date
    else
      date = Date.today
    end
    eoq = date.beginning_of_quarter - 1.day
    boq = eoq.beginning_of_quarter
    eolq = boq - 1.day
    bolq = eolq.beginning_of_quarter

    filename = post+ eoq.to_s + "-audit.yaml"
    filepath = Rails.root.join("db/audits",filename)
    # get audit for end of last quarter
    if File.exist?(filepath)
      @config = YAML.load_file(filepath)
      @config = @config.to_o
      return @config
    end
    # get audit for end of previous last quarter 
    filenamelq = post+ eolq.to_s + "-audit.yaml"
    filepathlq = Rails.root.join("db/audits",filenamelq)
    if File.exist?(filepathlq)
      @config = YAML.load_file(filepathlq)
      @config = @config.to_o
      reset_quarter(date)
      return @config
    end
    filepath = Rails.root.join("db/audits","vfwbase.yaml")
    @config = YAML.load_file(filepath)
    @config = @config.to_o
    reset_quarter(date)
    return @config
  end

  def accounts
    config.accounts
  end

  def reset_quarter(date)
    # move  account ending to beginning and clear debit and credit
    puts @config.inspect
    @config.accounts.each do |a|
      a.beginning = a.ending
      a.debit = ''
      a.credit = ''
      a.ending = ''
    end
    # clear totals (shoud just reset, at least after first change)
    @config.totals.beginning = ''
    @config.totals.beginning = ''
    @config.totals.beginning = ''
    @config.totals.beginning = ''
    # clear checking
    @config.checking.balance = ''
    @config.checking.outstanding = ''
    @config.checking.actual = ''
    @config.checking.other = ''
    @config.checking.cash = ''
    @config.checking.subtotal = ''
    @config.checking.cd = ''
    @config.checking.total = ''
    #reset date
    @config.date = date
  end

  def self.save(audit)
    post = Current.post.numb.to_s + '-'

    date = Date.parse(audit[:date])
    eolq = date.beginning_of_quarter - 1.day
    #convert param hash to array of hashes
    ahash = []
    ohash = []
    audit[:accounts].each{|k,v| ahash << v}
    audit[:operations].each{|k,v| ohash << v}
    audit[:accounts] = ahash
    audit[:operations] = ohash

    filename = post + eolq.to_s + "-audit.yaml"
    filepath = Rails.root.join("db/audits",filename)
    File.write(filepath,audit.to_yaml)
  end


end