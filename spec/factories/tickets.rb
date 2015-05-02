FactoryGirl.define do
  factory :ticket do
    subject 'Test Ticket'
    body 'I want to take some help on my very special server issue NOW!!!!'
    customer_name 'Customer One'
    email 'customer+one@example.com'
  end

end
