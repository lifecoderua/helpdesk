class TicketUpdate < ActiveRecord::Base
  belongs_to :ticket
  has_one :owner, class_name: 'Staff'
  has_one :status
end
