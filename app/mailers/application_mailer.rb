class ApplicationMailer < ActionMailer::Base
  add_template_helper TicketsHelper

  default from: "noreply.helpdesk@example.com"
  layout 'mailer'
end
