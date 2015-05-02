class Ticket < ActiveRecord::Base
  belongs_to :department
  belongs_to :owner, class: 'Staff'

  after_save :generate_slug

private

  def generate_slug
    if self.id_changed? && !self.slug_changed?
      self.update_attribute(:slug, self.id)
    end
  end
end
