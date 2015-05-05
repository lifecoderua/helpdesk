# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

statuses = [
    { title: 'Waiting for Staff Response', display: Status.displays[:open], role: Status.roles[:waiting_for_staff_response] },
    { title: 'Waiting for Customer', display: Status.displays[:open], role: Status.roles[:waiting_for_customer] },
    { title: 'On Hold', display: Status.displays[:hold], role: Status.roles[:on_hold] },
    { title: 'Cancelled', display: Status.displays[:closed], role: Status.roles[:cancelled] },
    { title: 'Completed', display: Status.displays[:closed], role: Status.roles[:completed] },
]

statuses.each do |status|
  Status.create!(title: status[:title], display: status[:display], role: status[:role])
end


departments = %w(Tech Billing Press)
departments.each do |title|
  Department.create!(title: title)
end