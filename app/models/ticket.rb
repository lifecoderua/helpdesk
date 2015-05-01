class Ticket < ActiveRecord::Base
  belongs_to :department
  belongs_to :owner, class: 'Staff'
end
