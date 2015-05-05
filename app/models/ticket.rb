class Ticket < ActiveRecord::Base
  belongs_to :department
  belongs_to :status
  belongs_to :owner, class_name: 'Staff', foreign_key: :staff_id

  has_many :ticket_updates
  accepts_nested_attributes_for :ticket_updates

  validates :subject, :body, :email, :customer_name, presence: true
  validates :email, email_format: {message: I18n.t('email.validation.format')}

  after_save :generate_slug

  # order doesn't want to support params, should be checked, issue filled
  scope :own_first, ->(staff) { order("CASE WHEN staff_id = #{staff.id} THEN 1 ELSE 2 END ASC") }
  scope :lookup_by_slug, ->(slug) { where('slug LIKE ?', "%#{slug}%") }

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

  def set_status_by_role(role)
    self.status = Status.find_by_role role
  end

  private

  # Generates slug on the ticket creation.
  # This logic is a compromise between the code simplicity, performance and the output aesthetics.
  #
  # ticket[:shift] may be omitted, it is added on purpose to show better default strings to the customer, rather than
  # ABC-00-000-01-ABC.
  #
  # The generator also may be implemented as a completely random string, with a DB check for duplicates and a recursion
  # in case of a duplicate found. This adds a query or two, but should not be too heavy for the performance, with
  # the collision probability around 1*10^10
  def generate_slug
    if self.id_changed? && !self.slug_changed?
      # this should not happen on regular DB setup, just a bit of insurance
      throw 'ID exceeded the storage limit' if self.id > TICKET_ID_LIMIT

      shifted_id = (Rails.application.secrets.ticket[:shift] + self.id) % TICKET_ID_LIMIT

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
