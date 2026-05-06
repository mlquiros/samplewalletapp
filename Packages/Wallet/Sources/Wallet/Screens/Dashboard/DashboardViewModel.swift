//
//  DashboardViewModel.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Foundation
import Combine

/// The state of the `DashboardView`.
@MainActor
final class DashboardViewModel: ObservableObject {
  
  @Published fileprivate(set) var session: Session?
  @Published fileprivate(set) var walletInfo: WalletInfo?
  @Published fileprivate(set) var balanceIsShowing = false
  
  @Published fileprivate(set) var isFetchingWalletInfo = false
  @Published fileprivate(set) var error: Error?
  
  fileprivate init(
    session: Session?,
    walletInfo: WalletInfo?
  ) {
    self.session = session
    self.walletInfo = walletInfo
  }
  
}

/// Manages the state of the `DashboardView`.
final class DashboardViewModelController {
  
  @MainActor
  let model: DashboardViewModel
  
  
  // MARK: - Initialization
  
  @MainActor
  init(
    session: Session?,
    walletInfo: WalletInfo?
  ) {
    self.model = DashboardViewModel(session: session, walletInfo: walletInfo)
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  
  // MARK: - Setting the session
  
  @MainActor
  func setSession(_ session: Session?) {
    model.session = session
    if session == nil {
      model.walletInfo = nil
    }
  }
  
  
  
  // MARK: - Wallet info
  
  /// Directly sets a value for the wallet info.
  @MainActor
  func setWalletInfo(_ walletInfo: WalletInfo?) {
    model.walletInfo = walletInfo
  }
  
  private var currentTask: Task<Void, Never>?
  
  /// Fetches and sets the wallet info if there is currently no cached value.
  @MainActor
  func attemptFetchingWalletInfo() {
    guard model.isFetchingWalletInfo == false,
          let session = model.session
    else { return }
    
    model.isFetchingWalletInfo = true
    let cachedWalletInfo = model.walletInfo
    
    currentTask = Task {
      do {
        let parameters = GetWalletInfo.Parameters(
          username: session.username,
          sessionToken: session.token,
          cachedWalletInfo: cachedWalletInfo)
        let walletInfo = try await GetWalletInfo.dataTaskSuccess(
          withParameters: parameters)
        await MainActor.run { [weak self] in
          guard let self else { return }
          self.showSuccess(walletInfo: walletInfo)
          
          // Since the wallet balance had just been updated from server,
          // post the notification.
          NotificationCenter.default.post(
            name: WalletDidUpdate.notificationName,
            object: nil,
            userInfo: [
              WalletDidUpdate.userInfoKey: WalletDidUpdate.UserInfo(
                balance: walletInfo.balance.amount,
                currencyCode: walletInfo.balance.currencyCode)
            ])
        }
      } catch {
        await MainActor.run { [weak self] in
          guard let self else { return }
          self.showFailure(error: error)
        }
      }
    }
  }
  
  @MainActor
  private func showSuccess(walletInfo: WalletInfo) {
    model.isFetchingWalletInfo = false
    model.walletInfo = walletInfo
    model.error = nil
  }
  
  @MainActor
  private func showFailure(error: Error) {
    model.isFetchingWalletInfo = false
    model.walletInfo = nil
    model.error = error
  }
  
  
  // MARK: - Toggling balance visibility
  
  @MainActor
  func setBalanceIsShowing(_ isShowing: Bool) {
    model.balanceIsShowing = isShowing
  }
  
}
