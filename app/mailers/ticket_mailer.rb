class TicketMailer < ApplicationMailer
  def ticket_created(ticket)
    @ticket = ticket
    mail(to: ticket.email, subject: 'Your ticket was created')
  end

  def ticket_updated(ticket, update_body)
    @ticket = ticket
    @update_body = update_body
    mail(to: ticket.email, subject: 'Your ticket received a new reply')
  end

end
