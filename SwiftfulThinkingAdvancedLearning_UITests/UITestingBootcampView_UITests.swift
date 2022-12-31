//
//  UITestingBootcampView_UITests.swift
//  SwiftfulThinkingAdvancedLearning_UITests
//
//  Created by Artur Remizov on 30.12.22.
//

import XCTest

final class UITestingBootcampView_UITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
//        app.launchArguments = ["-UITest_startSignIn"]
//        app.launchEnvironment = ["-UITest_startSignIn2": "true"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_UITestingBootcampView_SignUpButton_shouldSignIn() {
        // given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // when
        let navBar = app.navigationBars["Welcome"]
        // then
        XCTAssertTrue(navBar.exists)
    }
    
    func test_UITestingBootcampView_SignUpButton_shouldNotSignIn() {
        // given
        signUpAndSignIn(shouldTypeOnKeyboard: false)
        // when
        let navBar = app.navigationBars["Welcome"]
        // then
        XCTAssertFalse(navBar.exists)
    }
    
    func test_SignedInHomeView_ShowAlertButton_shouldDisplayAlert() {
        // given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // when
        tapAlertButton(shouldDismissAlert: false)
        // then
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists)
    }
    
    func test_SignedInHomeView_ShowAlertButton_shouldDisplayAndDismissAlert() {
        // given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // when
        tapAlertButton(shouldDismissAlert: true)
        // then
        let alertExists = app.alerts.firstMatch.waitForExistence(timeout: 5)
        XCTAssertFalse(alertExists)
    }
    
    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestination() {
        // given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // when
        tapNavigationLink(shouldDismissDestination: false)
        // then
        let destinationText = app.staticTexts["Destination"]
        XCTAssertTrue(destinationText.exists)
    }
    
    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestinationAndGoBack() {
        // given
        signUpAndSignIn(shouldTypeOnKeyboard: true)
        // when
        tapNavigationLink(shouldDismissDestination: true)
        // then
        let navBar = app.navigationBars["Welcome"]
        XCTAssertTrue(navBar.exists)
    }
    
//    func test_SignedInHomeView_NavigationLinkToDestination_shouldNavigateToDestinationAndGoBack2() {
//        // given
//        // when
//        tapNavigationLink(shouldDismissDestination: true)
//        // then
//        let navBar = app.navigationBars["Welcome"]
//        XCTAssertTrue(navBar.exists)
//    }
}

// MARK: - Funtions
extension UITestingBootcampView_UITests {
    
    func signUpAndSignIn(shouldTypeOnKeyboard: Bool) {
        
        let textField = app.textFields["SignUpTextField"]
        textField.tap()
        
        if shouldTypeOnKeyboard {
            let keyA = app.keys["A"]
            keyA.tap()
            
            let keya = app.keys["a"]
            keya.tap()
            keya.tap()
        }
                
        let returnButton = app.buttons["Return"]
        returnButton.tap()
        
        let signUpButton = app.buttons["SignUpButton"]
        signUpButton.tap()
    }
    
    func tapAlertButton(shouldDismissAlert: Bool) {
        let alertButton = app.buttons["ShowAlertButton"]
        alertButton.tap()
        
        if shouldDismissAlert {
            let alert = app.alerts.firstMatch
            let alertOKButton = alert.buttons["OK"]
            
            let alertOKButtonExists = alertOKButton.waitForExistence(timeout: 5)
            XCTAssertTrue(alertOKButtonExists)
            
            alertOKButton.tap()
        }
    }
    
    func tapNavigationLink(shouldDismissDestination: Bool) {
        let navLinkButton = app.buttons["NavigationLinkToDestination"]
        navLinkButton.tap()
        
        if shouldDismissDestination {
            let backButton = app.navigationBars.buttons["Welcome"]
            backButton.tap()
        }
    }
}
