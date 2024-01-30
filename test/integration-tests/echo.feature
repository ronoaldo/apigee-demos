Feature:
  As an API Developer
  I want to get mock data
  So that I can independently build an API

  Scenario: Get the user agent
    Given I set User-Agent header to bdd-test-browser/v1
    When I GET /echo
    Then response code should be 200
    And response body should be valid json
    And response body should contain bdd-test-browser/v1

  Scenario: Get the data as XML
    Given I set Accept header to application/xml
    When I GET /echo
    Then response code should be 200
    And response body should be valid xml
    And response body should contain application/xml

  Scenario: CORS is configured for POST /echo
    When I request OPTIONS for /echo
    Then response code should be 204
    And response header access-control-allow-origin should exist
    And response header access-control-allow-origin should be \\*