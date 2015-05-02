require 'rails_helper'

RSpec.describe Ticket, type: :model do

  it 'creates ticket with specific ID required for slug test' do
    id = 290
    ticket = FactoryGirl.build(:ticket, id: id)
    expect(ticket.id).to eq(id)
  end

  it 'generates semi-random slug' do
    ticket = FactoryGirl.build(:ticket)
    expect(ticket.slug).to eq(ticket.id)
  end

end
