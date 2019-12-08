module MembersHelper
  def format_phone(text)
    text = text.gsub(/[^\d]/,"") unless text.nil?
    numb = text.to_i
    if numb == 0
      return("")
    else
      return number_to_phone(numb)
    end
  end
  
  def unformat_phone(text)
    numb =  text.scan /[-+]?\d*\.?\d+/
    return numb
  end

  def display_phone(member)
    results = ""
    if @current_user.present?
      results = format_phone(member.phone)
    else
      results = member.phone.present? ? link_to( "Phone","contact_phone/#{member.id}" ): ''
    end
    results
  end

  def display_email(member)
    results = ""
    if @current_user.present?
      if member.email.present? 
        results = mail_to(member.email,'eMail').html_safe 
       end
    else
      results = member.email.present? ? link_to("eMail","contact_member/#{member.id}") : ""
    end
    results
  end

  def display_contact(member)
    "#{display_phone(member)} #{display_email(member)}".html_safe
  end
 
end
