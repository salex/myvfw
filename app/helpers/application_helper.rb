module ApplicationHelper
  def inspect_session
    inspect = {}
    session.keys.each do |k|
      inspect[k] = session[k]
    end
    inspect
  end
  alias session_inspect inspect_session

  def set_date(date=nil)
    return date if date.class == Date
    return Date.today if date.blank?
    date = Date.parse(date) rescue Date.today
  end

  def icon(klass, text = nil)
    icon_tag = tag.i(class: klass)
    text_tag = tag.span text
    text ? tag.span(icon_tag + text_tag) : icon_tag
  end


  
end
