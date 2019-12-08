class Officer < ApplicationRecord
  attribute :vfw_id, :integer
  belongs_to :post
  belongs_to :member
  OFFICERS = ["Commander", "Senior Vice-Commander", "Junior Vice-Commander", "Quartermaster", "Adjutant", "Chaplain", "Judge Advocate", 
    "Surgeon", "Trustee - 1 Year", "Trustee - 2 Year", "Trustee - 3 Year", "Service Officer"]

  before_save :set_current
  before_validation  :set_seq
  # after_find do |o|
  #   self.vfw_id = self.member.vfw_id
  # end

  def set_vfw_id
    self.vfw_id = self.member.vfw_id
  end

  def name
    self.member.full_name
  end

  def self.current_officers
    list = {}
    OFFICERS.each do |p|
      o = Current.post.officers.find_by(current:true,position:p)
      if o.present?
        list[p] = {name:o.member.full_name,from:o.from_date,email:o.member.email}
      else
        list[p] = {name:'Vacant',from:nil,email:nil}
      end
    end
    list
  end

  def set_seq
    self.seq = OFFICERS.index(position)
  end

  def set_current
    # called on a before filter(update?) if the current value is true 
    # looks for someone else who holds the position.
    # if it finds it, changes current to false and to date to today
    if self.new_record? && self.current
      check_last = Current.post.officers.find_by(current:true,position:self.position)
      if check_last.present?
        check_last.current = false
        check_last.to_date = self.from_date
        check_last.save
      end
    end
  end

end
