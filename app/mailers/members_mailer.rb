class MembersMailer < ApplicationMailer

  def members_email
    @member = Member.find(2)
    @member.message = "Now is the time for all good men to come to the aid of their country."

    mail(to: @member.email, subject: "You got a new email!")
  end

end
