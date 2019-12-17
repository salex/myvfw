class TrusteeAudit
  attr_accessor :config
  def initialize(date=nil)
    post = Current.post.numb.to_s + '-'
    if date.present?
      date = Date.parse(date) unless date.class == Date
      eolq = date.beginning_of_quarter - 1.day
      filename = post+ eolq.to_s + "-audit.yaml"
      filepath = Rails.root.join("db/audits",filename)
      if File.exist?(filepath)
        @config = YAML.load_file(filepath)
        @config = @config.to_o
      else
        filepath = Rails.root.join("db/audits","vfwbase.yaml")
        @config = YAML.load_file(filepath)
        @config = @config.to_o 
      end
    else
      eolq = Date.today.beginning_of_quarter - 1.day
      filename = post + eolq.to_s + "-audit.yaml"
      puts "no date Filename #{filename}"

      filepath = Rails.root.join("db/audits",filename)
      if File.exist?(filepath)
        @config = YAML.load_file(filepath)
        @config = @config.to_o 
      else
        filepath = Rails.root.join("db/audits","vfwbase.yaml")
        @config = YAML.load_file(filepath)
        @config = @config.to_o
      end
    end
    return @config
  end

  def accounts
    config.accounts
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