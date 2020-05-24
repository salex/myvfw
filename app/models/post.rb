class Post < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :markups, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :officers, dependent: :destroy
  has_many :trustee_audits, dependent: :destroy
  has_one :post_calendar, dependent: :destroy

  # def self.districts
  #   dist = User.where.not(district:nil).pluck(:district).uniq.sort
  # end

  # def self.posts
  #   dist = User.where.not(numb:nil).pluck(:numb).uniq.sort
  # end

  # def self.district_posts
  #   dist_posts = {}
  #   Post.districts.each do |d|

  #     dist_posts[d] = Post.where(district_id:d).order(:numb).pluck(:numb,:id).to_h
  #   end
  #   dist_posts
  # end

  def build_calendar
    key = "post-#{self.numb}-calendar"
    if self.post_calendar.blank?
      json = '{"holidays":{"color":"Blue","active":true,"uri":"https://p21-calendars.icloud.com/holiday/US_en.ics","ics":""},
        "tide":{"color":"Crimson","active":true,"uri":"https://api.calreply.net/webcal/a680a869-336c-483f-8d9f-9f06dafb0595","ics":""},
        "tigers":{"color":"#f68026","active":true,"uri":"https://api.calreply.net/webcal/ec3695ca-88bd-4b2f-83ab-6e32c5ac8389","ics":""}
      }'
      pc = self.build_post_calendar(key:key,date:Date.today,array_data:json)
      pc.save
    end
    return pc

  end

  def update_calendar(params)
    # puts params.inspect
    pc = self.post_calendar
    json = []
    jhash = {}
    params.each do |k,v|
      jhash[v["name"]] = v.except!("name") unless v["name"].blank?
    end
    pc.array_data= jhash.to_json
    pc.save
  end

  # params = {"0"=>{"name"=>"holidays", "color"=>"Blue", "active"=>"true", "uri"=>"https://p21-calendars.icloud.com/holiday/US_en.ics"}, "1"=>{"name"=>"vfw", "color"=>"#871B15", "active"=>"true", "uri"=>"https://p03-calendars.icloud.com/published/2/yDA7SN0imoKyRwRczElJRZZI9onlqUtZCftvEpV4cGtOJUv5InLGSj9y1FxR4x6ea1ME5at0r-5aP6gF__sXR2g3l3PFwn93tRZoV22HyG8"}, "2"=>{"name"=>"tide", "color"=>"Crimson", "active"=>"true", "uri"=>"https://api.calreply.net/webcal/a680a869-336c-483f-8d9f-9f06dafb0595"}, "3"=>{"name"=>"tigers", "color"=>"#f68026", "active"=>"true", "uri"=>"https://api.calreply.net/webcal/ec3695ca-88bd-4b2f-83ab-6e32c5ac8389"}, "4"=>{"name"=>"", "color"=>"", "active"=>"", "uri"=>""}}

  # '{"holidays":{"color":"Blue","active":true,"uri":"https://p21-calendars.icloud.com/holiday/US_en.ics","ics":""},
  # "vfw":{"color":"#871B15","active":true,"uri":"https://p03-calendars.icloud.com/published/2/yDA7SN0imoKyRwRczElJRZZI9onlqUtZCftvEpV4cGtOJUv5InLGSj9y1FxR4x6ea1ME5at0r-5aP6gF__sXR2g3l3PFwn93tRZoV22HyG8","ics":""},
  # "tide":{"color":"Crimson","active":true,"uri":"https://api.calreply.net/webcal/a680a869-336c-483f-8d9f-9f06dafb0595","ics":""},
  # "tigers":{"color":"#f68026","active":true,"uri":"https://api.calreply.net/webcal/ec3695ca-88bd-4b2f-83ab-6e32c5ac8389","ics":""}
  # }'


end
