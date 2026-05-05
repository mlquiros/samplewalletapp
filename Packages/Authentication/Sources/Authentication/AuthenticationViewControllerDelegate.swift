//
//  AuthenticationViewControllerDelegate.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 5/5/26.
//

public protocol AuthenticationViewControllerDelegate: AnyObject {
  
  func authenticationViewController(
    _ authenticationViewController: AuthenticationViewController,
    didSucceedLoggingInWithSession session: Session
  )
  
}
