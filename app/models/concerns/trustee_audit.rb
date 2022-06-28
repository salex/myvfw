class TrusteeAudit < Stash
  belongs_to :post
  # serialize :text_data, Hash
  DefaultAudit = "{\"date\":\"2019-10-10\",
  \"qm\":{\"name\":\"Steven V Alex\",\"address\":\"405 Karaway Hls\",\"city\":\"Gadsden AL, 35901\"},
  \"bond\":{\"name\":\"Tallman Insurance Agency\",\"amount\":\"500001.00\",\"to\":\"2022-08-31\"},
  \"accounts\":[{\"name\":\"General\",\"type\":\"Ck\",\"beginning\":\"0.00\",\"debit\":\"0.00\",\"credit\":\"0.00\",\"ending\":\"0.00\"},{\"name\":\"Relief\",\"type\":\"Ck\",\"beginning\":\"0.00\",\"debit\":\"0.00\",\"credit\":\"0.00\",\"ending\":\"0.00\"},{\"name\":\"CD\",\"type\":\"CD\",\"beginning\":\"0.00\",\"debit\":\"0.00\",\"credit\":\"0.00\",\"ending\":\"0.00\"},{\"name\":\"Cash\",\"type\":\"Ca\",\"beginning\":\"0.00\",\"debit\":\"0.00\",\"credit\":\"0.00\",\"ending\":\"0.00\"},{\"name\":\"Savings\",\"type\":\"Sv\",\"beginning\":\"0.00\",\"debit\":\"0.00\",\"credit\":\"0.00\",\"ending\":\"0.00\"}],\"totals\":{\"beginning\":\"0.00\",\"debit\":\"0.00\",\"credit\":\"0.00\",\"ending\":\"0.00\"},
  \"acct_types\":\"Ck Sv Ca CD\",
  \"operations\":[{\"question\":\"Have required payroll deductions been made?\",\"response\":\"\"},{\"question\":\"Have payments been made to the proper State \\u0026 Federal agencies this quarter?\",\"response\":\"\"},{\"question\":\"Have Sales Taxes been collected and paid?\",\"response\":\"\"},{\"question\":\"Are Club employees bonded?\",\"response\":\"\"},{\"question\":\"Amount of outstanding bills?\",\"response\":\"0.00\"},{\"question\":\"Value of Real Estate?\",\"response\":\"0.00\"},{\"question\":\"Amount of Liability Insurance?\",\"response\":\"0.00\"},{\"question\":\"Owed on Mortgages and Loans?\",\"response\":\"0.00\"},{\"question\":\"Value of Personal Property?\",\"response\":\"0.00\"},{\"question\":\"Amount of Property Insurance?\",\"response\":\"0.00\"}],
  \"checking\":{\"balance\":\"0.00\",\"outstanding\":\"0.00\",\"actual\":\"0.00\",\"other\":\"0.00\",\"cash\":\"0.00\",\"subtotal\":\"0.00\",\"cd\":\"0.00\",\"total\":\"0.00\"},
  \"post\":{\"name\":\"Wilson Parris\",\"post\":\"VFW Post 8600\",\"numb\":8600,\"address\":\"817 Rainbow Dr\",\"city\":\"Gadsden AL, 35901\",\"department\":\"Alabama\"}}"
  def audit
    if hash_data.blank?
      self.hash_data = TrusteeAudit::DefaultAudit
    end
    return hash_to_struct(JSON.parse(hash_data))
  end
  alias report audit

  # a_hash = {a: {b: {c: 'x'},d:[e1:{ev1:'a',ev2:'b'},e2:{ev1:'c',ev2:'d'}]}}


  def hash_to_struct(a_hash)
    # .to_struct is a monkey_patch to hash in config/initializer
    struct = a_hash.to_struct
    struct.members.each do |m|
      add_hash_to_struct(struct,m) if struct[m].is_a? Hash
      add_array_members_to_struct(struct,m) if struct[m].is_a? Array 
    end
    struct 
  end

  def add_hash_to_struct(struct,member)
    struct[member] = hash_to_struct(struct[member])
  end

  def add_array_members_to_struct(struct,array)
    struct[array].each_with_index do |elem,i|
      struct[array][i] = hash_to_struct(elem) if elem.is_a? Hash
      struct[array][i] = add_array_members_to_struct(struct[array][i],elem) if elem.is_a? Array 
    end
  end

  def params_to_hash(params)
    new_audit = params.dup
    new_audit[:accounts] = []
    new_audit[:operations] = []
    params[:accounts].each do |k,v|
      if !v[:name].blank?
        new_audit[:accounts] << v
      end
    end
    params[:operations].each do |k,v|
      if !v[:question].blank?
        new_audit[:operations] << v
      end
    end
    new_audit.permit!.to_h
  end

  def self.new_audit
    last = TrusteeAudit.order(:key).reverse_order.first
    post = Current.post
    pnumb = post.numb.to_s + '-'
    boq = last.date + 1.day
    eoq = boq.end_of_quarter

    keyname = pnumb+ eoq.to_s + "-audit"
    report = last.report
    this = TrusteeAudit.new(key:keyname,date:eoq,post_id:post.id)
    report.date = ''
    cnt = report.accounts.size
    0.upto cnt -1 do |i|
      report.accounts[i].beginning = report.accounts[i].ending
      report.accounts[i].debit = '0.00'
      report.accounts[i].credit = '0.00'
    end
    report.checking.balance = '0.00'
    report.checking.outstanding = '0.00'
    this.hash_data = report.to_h.to_json
    this
  end

end