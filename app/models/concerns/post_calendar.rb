require 'net/http'

class PostCalendar < Stash
  belongs_to :post
  # serialize :hash_data, Hash


  attr_accessor :calendars, :ics 

  def get_ics(refresh=false)
    get_calendars
    today = Date.today
    if refresh || today < updated_at.to_date || self.ics_string.blank?
      @ics = ''
      get_or_refresth_ics(true)
      self.update(text_data:ics.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '?'))
    end
    return ics_string
  end

  def tmp
    p = Post.find 19
    Current.post = p
    pc = Current.post.post_calendar
  end

  def json
    self.array_data
  end

  def ics_string
    self.text_data
  end

  def get_calendars
    @calendars = JSON.parse(json)
  end

  def get_or_refresth_ics(refresh=false)
    @calendars.each do |c,v|
      refresh_ics(c) if refresh
    end
  end

  def refresh_ics(calendar)
    @calendars[calendar]["ics"] = Net::HTTP.get(URI(@calendars[calendar]["uri"]))
    @ics << @calendars[calendar]["ics"]
  end

end
