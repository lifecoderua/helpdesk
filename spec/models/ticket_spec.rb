require 'rails_helper'

RSpec.describe Ticket, type: :model do

  it 'creates ticket with specific ID required for slug test' do
    id = 290
    ticket = FactoryGirl.build(:ticket, id: id)
    expect(ticket.id).to eq(id)
  end

  it 'generates semi-random slug' do
    id = 1
    slug = Rails.application.secrets.ticket[:test_plus_one]

    ticket = FactoryGirl.build(:ticket, id: id)
    ticket.save
    expect(ticket.slug.slice(4, 9)).to eq(slug)
  end

  # The ticket limit is quite big for regular DB id column.
  # This test may become handly for custom setups, but the default int32 catches RangeError way earlier
  # it 'slug exception raised on limit overflow' do
  #   id = Ticket::TICKET_ID_LIMIT
  #
  #   ticket = FactoryGirl.build(:ticket, id: id)
  #   expect{ticket.save}.to raise_error(Exception, 'strict limit pushed')
  # end

end
