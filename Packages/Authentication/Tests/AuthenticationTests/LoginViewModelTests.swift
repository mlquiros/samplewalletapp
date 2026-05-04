//
//  LoginViewModelTests.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import XCTest
@testable import Authentication

final class LoginViewModelTests: XCTestCase {
  
  @MainActor
  func test_ifUsernameContainsSymbols_thenLoginShouldFail() {
    
    let modelController = LoginViewModelController()
    let model = modelController.model
    
    modelController.setUsername("matthew@mlq.software")
    
    let expectation = expectation(description: #function)
    modelController.attemptLoggingIn(
      
      successBlock: { _, _ in
        XCTFail("Success block should not have been executed")
        expectation.fulfill()
      },
      
      failureBlock: { error in
        XCTAssertTrue(error is LoginViewModelController.InvalidUsername)
        XCTAssertNotNil(model.error)
        XCTAssertTrue(model.error is LoginViewModelController.InvalidUsername)
        expectation.fulfill()
      })
    
    wait(for: [expectation], timeout: 2.0)
  }
  
  @MainActor
  func test_ifUsernameContainsOnlyLettersAndNumbers_thenLoginShouldSucceed() {
    
    let modelController = LoginViewModelController()
    
    modelController.setUsername("mlq555")
    
    let expectation = expectation(description: #function)
    modelController.attemptLoggingIn(
      
      successBlock: { username, _ in
        // Test the produced session credentials.
        XCTAssertEqual("mlq555", username)
        
        // Note: No tests for the view model here, since the LoginVC does not
        // retain the session credentials when login succeeds.
        
        expectation.fulfill()
      },
      
      failureBlock: { error in
        XCTFail("Failure block should not have been executed")
        expectation.fulfill()
      })
    
    wait(for: [expectation], timeout: 2.0)
  }
  
}
