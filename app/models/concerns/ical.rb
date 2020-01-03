require 'icalendar/recurrence'
class Ical
  attr_accessor :calendars, :ics_string, :date_events, :colors, :names, :session

  def initialize(refresh=false)

    post_calendar = Current.post.post_calendar
    @ics_string = post_calendar.get_ics(refresh)
    post_calendars = post_calendar.get_calendars
    @colors = []
    @names = []
    post_calendars.each do |c,v|
      @colors << v["color"]
      @names << c  
    end
    @calendars = Icalendar::Calendar.parse(ics_string)
  end

  def upcoming_events
    today = Date.today
      events = find_sorted_events(today,today+ 30.days)
      events.each do |d,a|
        a.each do |e|
          e[:summary] = e[:summary].to_s
          #filter espn events
          if e[:desc].present?
            url = e[:desc].index('http://')
            if url.present?
              e[:desc] = e[:desc][0..(url -1)].to_s
            else
              e[:desc] = e[:desc].to_s
            end
          end
        end
      end
    return events
  end


  def find_events(from,to,params=nil)
    from = Date.parse(from) unless from.class == Date
    to = Date.parse(to) unless to.class == Date
    @date_events = {}
    if params.present? && params[:cal].present?
      get_events(from,to,params[:cal].to_i)
    else
      @calendars.each_index do |cal|
        get_events(from,to,cal)
      end
    end
    @date_events
  end

  def find_sorted_events(from,to,params=nil)
    events = find_events(from,to,params)
    dates = events.keys
    dates.each do |d|
      e = events[d].sort_by{|h| h[:start_time]}
      events[d] = e
    end
    events
  end

  def get_events(from,to,cal)
    @calendars[cal].events.each do |e|
      occurrences = e.occurrences_between(from, to)
      if occurrences.present?
        occurrences.each do |o|
          add_occurrence(e,o,cal)
        end
      end
    end
  end

  def add_occurrence(e,o,cal)
    e.summary = e.summary.force_encoding("UTF-8")
    e.description = e.description.force_encoding("UTF-8") if e.description.present?
    dt = o.start_time.localtime.to_date
    occ = {start_time:o.start_time.localtime,
      end_time:o.end_time.localtime,
      summary:e.summary,desc:e.description,color:@colors[cal]}
    if @date_events.has_key?(dt)
      @date_events[dt] << occ
    else
      @date_events[dt] = [occ]
    end
  end
end