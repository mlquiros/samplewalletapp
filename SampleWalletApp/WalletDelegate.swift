//
//  WalletDelegate.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import UIKit
import Wallet
import Authentication

final class WalletDelegate: DashboardViewControllerDelegate {
  
  private let authenticationDelegate = AuthenticationDelegate()
  
  
  
  // MARK: - Logging in
  
  func dashboardViewControllerDidTapLogin(
    _ dashboardViewController: DashboardViewController
  ) {
    presentLoginModal(dashboardViewController: dashboardViewController)
  }
  
  func dashboardViewControllerDidTapLogout(
    _ dashboardViewController: DashboardViewController
  ) {
    presentLoginModal(dashboardViewController: dashboardViewController)
  }
  
  /// Performs the work of presenting the login modal.
  /// - Parameters:
  ///   - dashboardViewController: The presenter of the modal and the dashboard
  ///     that will be refreshed when a successful login produces a valid session.
  private func presentLoginModal(
    dashboardViewController: DashboardViewController
  ) {
    // Present the authentication container, starting from the login view.
    let authVC = AuthenticationViewController(initialView: .login)
    authVC.authenticationDelegate = authenticationDelegate
    dashboardViewController.present(authVC, animated: true)
    
    // When the authentication delegate receives login success,
    // dismiss the container and reload the session in the dashboard.
    authenticationDelegate.didSucceedLogIn = {
      authVC.dismiss(animated: true) {
        let session = Keychain.shared.session?.convertToWalletType()
        dashboardViewController.setSession(session)
      }
    }
  }
  
}
