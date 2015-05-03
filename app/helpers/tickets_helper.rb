module TicketsHelper
  def ticket_path(ticket, options={})
    ticket_url(ticket, options.merge(:only_path => true))
  end

  def ticket_url(ticket, options={})
    url_for(options.merge(:controller => 'tickets', :action => 'show', :slug => ticket.slug))
  end
end
