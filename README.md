# HelpDesk

This is a sample HelpDesk solution, supporting fast ticket creation, basic management, and lookup options.

## Project Requirements

This application should meet the next requirements list:
- Rails 4
- HAML
- Receive tickets and allow reply through UI
- Customer does not need to login to submit a ticket
- Ticket form includes:
 - name
 - email
 - subject
 - body
 - Department
- On ticket creation
 - ticket receives unique random string slug with a mask **AAA-HH-AAA-HH-AAA** (**A** stands for random character, 
 **H** stands for Hex digit)
 - ticket receives Status `Waiting for Staff Respons`
 - customer receives an email with the link to his ticket
 - this URL should allow to track ticket status and history
- Statuses includes: `Waiting for Staff Response`, `Waiting for Customer`, `On Hold`, `Cancelled`, `Completed`. 
This list may be changed by the System Admin
- Staff member logs in by username & password
- Staff interface should
 - allow to list all tickets and take control over them
 - allow to Reply, change Status or Owner of the ticket within one action
 - all replies should be emailed to the customer
 - provide views for: New, Open, On hold, Closed tickets
 - quick ticket load by slug
 - ticket search by words in Subject or Body

## Assumptions

- As Admin is able to add new statuses, and we have constant set of views, each status should be assigned 
to one of the views
- Basic statuses involved into the business logic, so they should be protected from deletion
- Ticket may be reopened from closed Status both by Staff or Customer
- Truly random string may not guarantee it would be unique, so we would use semi-random string based on the id 
for the Ticket's slug

## Technical Requirements

- Make sure the DB uses **case sensitive collation** in order to support ticket slug lookup (`base62` is case sensitive)