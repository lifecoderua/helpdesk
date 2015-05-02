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
  # [FF-AAA] part, 256 * 238328
  SLUG_FIRST_MULTIPLIER = 61011968
  # [-FF]
  SLUG_SECOND_MULTIPLIER = 256
  BASE62_LIMIT = 238327

private

  def generate_slug
    if self.id_changed? && !self.slug_changed?
      shifted_id = Rails.application.secrets.ticket[:shift] + self.id

      chunk1 = shifted_id / SLUG_FIRST_MULTIPLIER
      rest1 = shifted_id % SLUG_FIRST_MULTIPLIER

      chunk2 = rest1 / SLUG_SECOND_MULTIPLIER
      chunk3 = rest1 % SLUG_SECOND_MULTIPLIER

      slug = [
          rand(BASE62_LIMIT).b(10).to_s(Radix::BASE::B62).rjust(3, '0'),
          chunk1.to_s(16).upcase().rjust(2, '0'),
          chunk2.b(10).to_s(Radix::BASE::B62).rjust(3, '0'),
          chunk3.to_s(16).upcase().rjust(2, '0'),
          rand(BASE62_LIMIT).b(10).to_s(Radix::BASE::B62).rjust(3, '0'),
      ].join('-')

      self.update_attribute(:slug, slug)
    end
  end
end
