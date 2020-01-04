class Calendar
  require 'net/http'
  attr_accessor :calendars #, :ics_string, :date_events, :colors, :names, :session

  def initialize
    json = Current.post.markups.find_by(category:'kiosk',title:'calendar').content
    @calendars = JSON.parse( json)

    # return
    #   This is original hardwired calendars. now a json object in markups
    #   @calendars = {
    #   holidays: {
    #    color: 'Blue',
    #    active: true,
    #    uri: 'https://p21-calendars.icloud.com/holiday/US_en.ics',
    #    ics:''
    #   },
    #   vfw: {
    #    color: '#871B15',
    #    active: true,
    #    uri: 'https://p03-calendars.icloud.com/published/2/yDA7SN0imoKyRwRczElJRZZI9onlqUtZCftvEpV4cGtOJUv5InLGSj9y1FxR4x6ea1ME5at0r-5aP6gF__sXR2g3l3PFwn93tRZoV22HyG8',
    #    ics:''
    #   },
    #   tide: {
    #    color: 'Crimson',
    #    active: true,
    #    uri: 'https://api.calreply.net/webcal/a680a869-336c-483f-8d9f-9f06dafb0595',
    #    ics: ''
    #   },
    #   tigers: {
    #    color: '#f68026',
    #    active: true,
    #    uri: 'https://api.calreply.net/webcal/ec3695ca-88bd-4b2f-83ab-6e32c5ac8389',
    #    ics:''
    #   }
    # }.with_indifferent_access
  end

  def get_ics(refresh=false)
    @calendars.each do |c,v|
      refresh_ics(c) if refresh || v[:ics].blank?
    end
  end

  def refresh_ics(calendar)
    @calendars[calendar]["ics"] = Net::HTTP.get(URI(@calendars[calendar]["uri"]))
  end

end
