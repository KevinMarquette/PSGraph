Feature: A proper community module     
    As a module owner
    In order to have a good community module
    I want to make sure everything works and the quality is high

Background: we have a module
    Given the module was named PSGraph


Scenario: Should have correct project structure and files
    Given we use the project root folder   
    Then it will have a readme.md file for general information 
    And it will have a LICENSE file
    And it will have a tests\*.Tests.ps1 file for Pester
    And it will have a spec\*.feature file for Gherkin
    And it will have a spec\*.Steps.ps1 file for Gherkin
    And it will have a build.ps1 file for builds
    And it will have a psake.ps1 file for builds
    And it will have a appveyor.yml file for build automation


Scenario: Should have correct module structure
    Given we use the module root folder
    Then it will have a *.psd1 file for module manifest
    And it will have a *.psm1 file for module 
    And it will have a public folder for public functions
    And it will have a public\*.ps1 file for a public function


Scenario: Module should import
    Given we use the module root folder
    And it had a *.psd1 file
    When the module is imported
    Then Get-Module will show the module
    And Get-Command will list functions


Scenario: Public function features
    Given the module is imported
    And we have public functions
    Then all public functions will be listed in module manifest
    And all public functions will contain cmdletbinding
    And all public functions will contain ThrowTerminatingError


Scenario: Should be well documented
    Given the module is imported
    And we use the project root folder
    And we have public functions
    Then it will have a readme.md file for general information 
    And all public functions will have comment based help
    And function Node will have a feature specification or a pester test
    And all public functions will have a feature specification or a pester test
    And will have readthedoc pages    
    And it will have a PITCHME.md file for project promotion
    
@PSScriptAnalyzer
Scenario: Should pass PSScriptAnalyzer rules
    Given we use the module root folder    
    Then it will have a public\*.ps1 file for a public function
    And all script files pass PSScriptAnalyzer rules
    
@Slow
Scenario: Should be published
    Given the module can be imported
    Then will be listed in the PSGallery
