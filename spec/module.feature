Feature: A proper community module
    As a module owner
    In order to have a good community module
    I want to make sure everything works and the quality is high

Background: we have a module
    Given the module was named PSGraph
    And it had a psm1 file

Scenario: Should have correct project structure and files
    Given the project root folder    
    Then it will have a tests\*.Tests.ps1 file for Pester
    And it will have a spec\*.feature file for Gherkin
    And it will have a spec\*.Steps.ps1 file for Gherkin
    And it will have a build.ps1 file for builds
    And it will have a psake.ps1 file for builds
    And it will have a appveyor.yml file for build automation
    And it will have a PITCHME.md file for project promotion

Scenario: Should have correct module structure
    Given the module root folder
    Then it will have a *.psd1 file for module manifest
    And it will have a *.psm1 file for module 
    And it will have a public folder for public functions
    And it will have a public\*.ps1 file for a public function

Scenario: Module should import
    Given the module root folder
    And it had a *.psd1 file
    When the module is imported
    Then Get-Module will show the module
    And Get-Command will list functions

Scenario: Should be well documented
    Given the module is imported
    And we have public functions
    Then Node should have comment based help
    Then all public functions should have comment based help
    And all public functions should have a feature specification
    And all public functions should have a pester test
    And should have readthedoc pages
    And should be posted on the blog
    And should have a pitchme.md presentation
    

Scenario: Should be publically available
    Given we have a module
    Then is should be published to github
    And should be listed in the PSGallery
    And should be explained on the blog
