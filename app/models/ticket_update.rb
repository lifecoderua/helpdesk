class TicketUpdate < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :status
  has_one :owner, class_name: 'Staff'

  validate :update_contains_information

private

  def update_contains_information
    # owner_id_changed?
    unless body.present? || status_id_changed?
      errors.add(:base, 'Update should contains something')
    end
  end


end
