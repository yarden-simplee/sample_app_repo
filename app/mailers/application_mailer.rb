class ApplicationMailer < ActionMailer::Base
  default from: "noreply@example.com"
  layout 'mailer'
end

# *** Sending mails in production is done using 'SendGrid'
