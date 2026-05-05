//
//  LoginViewControllerDelegate.swift
//  Authentication
//
//  Created by Matthew L. Quiros on 5/5/26.
//

protocol LoginViewControllerDelegate: AnyObject {
  
  func loginViewController(
    _ loginViewController: LoginViewController,
    didSucceedLoginWithSession session: Session
  )
  
}
