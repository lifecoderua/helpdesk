class Ticket < ActiveRecord::Base
  belongs_to :department
  belongs_to :owner, class: 'Staff'

  after_save :generate_slug

  # Strict limit which means id's may become not unique.
  # If the system pushed it - slug generation must be revised
  # (with the system in general, which should be obsolete at the point of 15.6*10^9 tickets)
  # * You should never push it with the regular DB settings, which provides int32 for id column
  # it is HH-AAA-HH
  TICKET_ID_LIMIT = 15619063808

private

  def generate_slug
    if self.id_changed? && !self.slug_changed?
      slug = Rails.application.secrets.ticket[:shift]

      self.update_attribute(:slug, slug)
    end
  end
end
