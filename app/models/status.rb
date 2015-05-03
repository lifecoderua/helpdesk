class Status < ActiveRecord::Base
  # Displays: New, Open, On hold, Closed
  # New is not used due to name collision with ActiveRecord
  enum display: [:fresh, :open, :hold, :closed]

  # Role represents business logic function and may be used to access status by it's purpose
  # Statuses with a role different from :custom assumed as a system required and should not be allowed for deletion
  enum role: [:custom, :waiting_for_staff_response, :waiting_for_customer, :on_hold, :cancelled, :completed]

  def to_s
    title
  end
end
