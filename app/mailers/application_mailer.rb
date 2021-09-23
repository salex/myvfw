class ApplicationMailer < ActionMailer::Base
  default from: 'vfwpost8600@gmail.com'
  default reply_to: 'vfwpost8600@gmail.com'

  layout 'mailer'
end
