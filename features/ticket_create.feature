Feature: Customer creates a ticket

  Background:
    Given there's a ticket named "My cool ticket" exists
    And I am on the homepage

  Scenario: Viewing home page
    Then I should see the "New ticket" title

  Scenario: I create a valid ticket
    Given I create a "Server is down" ticket with email "test@example.com", name "That One Customer" and body "Everything is broken!"

  Scenario: I forgot to enter Email
    Given I can't create a ticket without email