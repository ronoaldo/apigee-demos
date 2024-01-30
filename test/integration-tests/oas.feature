Feature:
  As an API Developer
  I want to get the Open API Spec document
  So that I can generate code for my system directly

  Scenario:
    When I GET /$discovery/oas
    Then response code should be 200
    And response header content-type should be application/yaml
    And response body should contain openapi
    And response body should contain GCP Release Notes
