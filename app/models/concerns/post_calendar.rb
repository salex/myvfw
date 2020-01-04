require 'net/http'

class PostCalendar < Stash
  belongs_to :post
  # serialize :hash_data, Hash


  attr_accessor :calendars, :ics, :slices

  def get_ics(params)
    refresh = true if params.present? && params['refresh'].present?
    get_calendars
    today = Date.today
    # puts "what is refresh set to #{refresh}"
    if refresh || today < updated_at.to_date || self.ics_string.blank?
      @ics = ''
      get_or_refresth_ics(true)
      self.update(text_data:ics.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: ''))
    end
    # @slices = calendar_indexes

    puts "what is cal set to #{params['cal'].to_i}"

    # if params.present? && params['cal'].present?
    #   return ics_string  #.slice(@slices(params['cal'].to_i))
    # else
    #   return ics_string
    # end
    return ics_string


  end

  def tmp
    p = Post.find 19
    Current.post = p
    pc = Current.post.post_calendar
  end

  # def calendar_indexes
  #   bvcal = "BEGIN:VCALENDAR"
  #   numb_cals = get_calendars.keys.count
  #   idxes = []
  #   start_idx = 0
  #   0.upto(numb_cals -1) do |idx|
  #     start_idx = ics_string.index(bvcal,start_idx)
  #     next_idx = ics_string.index(bvcal,start_idx+1)
  #     #test for done?
  #     idxes << [start_idx,next_idx]
  #     start_idx = next_idx
  #   end
  #   slices = []
  #   idxes.each do |s|
  #     s[1] = ics_string.length if s[1].nil? 
  #     slices << [s[0],s[1]-1]
  #   end
  #   slices
  # end



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
