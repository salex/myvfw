class MembersMailer < ApplicationMailer
  helper MembersHelper
  
  def members_email
    attachments['Commander-letter.pdf'] = File.read(Rails.root.join("pdf/20220105-letter.pdf"))
    @member = params[:member]
    # @member.message = "Now is the time for all good men to come to the aid of their country."

    mail(to: @member.email, subject: "An important message from VFW Post 8600")
  end

end
