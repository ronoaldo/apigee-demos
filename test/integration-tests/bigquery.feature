Feature:
  As an API Developer
  I want to get the bigquery responses
  So that I can implement my own client

  Scenario: List recent 10 releases as JSON
    When I GET /releases
    Then response code should be 200
    And response body should be valid json
    And response body path $. should be of type array with length 10
    And response body path $.[0] should be object
    And response body path $.[0].projectName should not be null

  Scenario: List recent 10 releases as XML
    Given I set accept header to application/xml
    When I GET /releases
    Then response code should be 200
    And response body should be valid xml
    And response body path //response/item[1] should not be null
    And response body path //response/item[10] should not be null
    And response body xml xpath //response/item appears 10 times
