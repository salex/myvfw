# Preview all emails at http://localhost:3000/rails/mailers/members_mailer
class MembersMailerPreview < ActionMailer::Preview

  def members_email
    # Set up a temporary order for the preview
    member = Member.new(full_name: "Joe Smith", email: "joe@gmail.com", address: "1-2-3 Chuo, Tokyo, 333-0000", phone: "090-7777-8888", message: "I want to place an member!")

    MembersMailer.with(member: member).members_email
  end


end
