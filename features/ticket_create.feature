Feature: Customer creates a ticket

  Scenario: Viewing home page
    Given there's a tiket named "My cool ticket" exists
    When I am on the homepage
    Then I should see the "New ticket" title
