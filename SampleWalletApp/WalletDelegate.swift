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
  
  
  
  // MARK: - Logging in/out
  
  func dashboardViewControllerDidTapLogin(
    _ dashboardViewController: DashboardViewController
  ) {
    presentLoginModal(dashboardViewController: dashboardViewController)
  }
  
  func dashboardViewControllerDidTapLogout(
    _ dashboardViewController: DashboardViewController
  ) {
    presentLoginModal(dashboardViewController: dashboardViewController)
    Keychain.shared.session = nil
    UserDefaults.standard.clearAllKeys()
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
        dashboardViewController.reloadContent(forSession: session)
      }
    }
  }
  
  
  
  // MARK: - Cache queries
  
  func cachedTransactions(
    for dashboardViewController: DashboardViewController
  ) -> [CachedTransaction] {
    return UserDefaults.standard.transactions.reversed().map {
      .init(ID: $0.ID,
            date: $0.date,
            amount: $0.amount,
            currencyCode: $0.currencyCode)
    }
  }
  
}
