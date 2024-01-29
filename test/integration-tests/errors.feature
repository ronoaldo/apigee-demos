Feature:
  As an API Developer
  I want to get detailed error resopnses
  So that I get fix any errors from my program

  Scenario: Get non-existing page
    When I GET /non-existing-service
    Then response code should be 404
    And response body should not contain 'fault'
    And response body should be valid json
