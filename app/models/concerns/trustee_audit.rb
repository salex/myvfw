class TrusteeAudit < Stash
  belongs_to :post
  serialize :hash_data, OpenStruct

  def audit
    self.hash_data
  end

  def config
    self.hash_data
  end

  def report
    self.hash_data
  end

end