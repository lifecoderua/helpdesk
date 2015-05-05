class TicketUpdate < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :status
  belongs_to :owner, class_name: 'Staff', foreign_key: :staff_id
  belongs_to :editor, class_name: 'Staff', foreign_key: :editor_id

  validate :update_contains_information

private

  def update_contains_information
    unless body.present? || status_id_changed? || staff_id_changed?
      errors.add(:base, 'Update should contains something')
    end
  end


end
