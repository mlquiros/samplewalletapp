//
//  AuthenticationDelegate.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Authentication

final class AuthenticationDelegate: AuthenticationViewControllerDelegate {
  
  
  // MARK: - Login
  
  /// A closure that is performed when the delegate receives the callback
  /// for a successful log in. Set this property to perform additional tasks
  /// other than what the delegate does to maintain application state.
  var didSucceedLogIn: (() -> Void)?
  
  func authenticationViewController(
    _ authenticationViewController: AuthenticationViewController,
    didSucceedLoggingInWithSession session: Authentication.Session
  ) {
    let session = Session(username: session.username, token: session.token)
    Keychain.shared.session = session
    
    // Perform additional tasks.
    didSucceedLogIn?()
  }
  
  
  
  
}
