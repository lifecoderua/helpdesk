Given(/^there's a ticket named "([^"]*)" exists$/) do |subject|
  FactoryGirl.create(:ticket, subject: subject)
end

Given(/^I am on the homepage$/) do
  visit root_path
end

Given(/^I fill "([^"]*)" ticket with email "([^"]*)", name "([^"]*)" and body "([^"]*)"$/) do |title, email, name, body|
  step %{I fill in "Subject" with "#{title}"}
  step %{I fill in "Email" with "#{email}"}
  step %{I fill in "Name" with "#{name}"}
  step %{I fill in "Body" with "#{body}"}
end

Given(/^I create a "([^"]*)" ticket with email "([^"]*)", name "([^"]*)" and body "([^"]*)"$/) do |title, email, name, body|
  step %{I fill "#{title}" ticket with email "#{email}", name "#{name}" and body "#{body}"}
  step %{I press "Create"}
  step %{I should see the "Server is down" title}
  step %{I should see the "Waiting for Staff Response" status}
end

Given(/^I can't create a ticket without email$/) do
  title = 'Some title'
  email = ''
  name = 'The Name'
  body = 'The Ticket Body'
  step %{I fill "#{title}" ticket with email "#{email}", name "#{name}" and body "#{body}"}
  step %{I press "Create"}
  step %{I should see the inline error "can't be blank" for "Email"}
end


When(/^I fill in "([^"]*)" with "([^"]*)"$/) do |field, value|
  fill_in field, with: value
end

When(/^I press "([^"]*)"/) do |button|
  find_button(button).click
end



Then(/^I should see the "(.*?)" title$/) do |title|
  expect(page).to have_content(title)
end

Then(/^I should see the "(.*?)" status$/) do |status|
  expect(page).to have_content("Status: #{status}")
end

Then(/^I should see the inline error "([^"]*)" for "([^"]*)"$/) do |message, field|
  expect(find(".#{field.downcase} .error").text).to eq(message)
end