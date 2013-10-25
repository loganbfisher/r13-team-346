Feature: Complete the process of creating a game

  Scenario: I click create game and fill out and submit the form
    Given I am logged in
    When I visit new games url
    Then I fill create a game form fields in
    Then I should see a group created successfully message
