//
//  AuthenticationViewController.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import UIKit

public final class AuthenticationViewController: UINavigationController {
  
  public enum View {
    case login
    case register
    
    // Some apps have a pretty-looking welcome view with a carousel of images.
//    case welcome
  }
  
  public init(
    initialView: View
  ) {
    let rootViewController: UIViewController
    switch initialView {
    case .login:
      rootViewController = LoginViewController()
    case .register:
      fatalError("Unsupported case \(String(describing: View.register)) -- not yet implemented")
    }
    super.init(rootViewController: rootViewController)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  
  // MARK: - Delegation
  
  public weak var authenticationDelegate: AuthenticationViewControllerDelegate?
  
  
  
  
  // MARK: - Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  
  
  
}

extension AuthenticationViewController: @MainActor LoginViewControllerDelegate {
  
  func loginViewController(
    _ loginViewController: LoginViewController,
    didSucceedLoginWithSession session: Session
  ) {
    authenticationDelegate?.authenticationViewController(
        self, didSucceedLoggingInWithSession: session)
  }
  
  
}
