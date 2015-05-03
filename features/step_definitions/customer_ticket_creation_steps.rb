Given(/^there's a tiket named "([^"]*)" exists$/) do |arg|
  FactoryGirl.create(:ticket, subject: arg)
end

When(/^I am on the homepage$/) do
  visit root_path
end

Then(/^I should see the "(.*?)" title/) do |title|
  expect(page).to have_content(title)
end