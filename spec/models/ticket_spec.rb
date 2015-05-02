require 'rails_helper'

RSpec.describe Ticket, type: :model do

  it 'generates semi-random slug' do
    ticket = FactoryGirl.build(:ticket)
    expect(ticket.slug).to eq(ticket.id)
  end

end
