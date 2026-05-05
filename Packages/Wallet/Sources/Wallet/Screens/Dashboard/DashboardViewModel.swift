//
//  DashboardViewModel.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import Combine

/// The state of the `DashboardView`.
@MainActor
final class DashboardViewModel: ObservableObject {
  
  @Published fileprivate(set) var session: Session?
  @Published fileprivate(set) var walletInfo: WalletInfo?
  @Published fileprivate(set) var balanceIsShowing = false
  
  @Published fileprivate(set) var isFetchingWalletInfo = false
  @Published fileprivate(set) var error: Error?
  
  
  
  
  fileprivate init(session: Session? = nil) {
    self.session = session
  }
  
}

/// Manages the state of the `DashboardView`.
final class DashboardViewModelController {
  
  @MainActor
  let model: DashboardViewModel
  
  
  // MARK: - Initialization
  
  @MainActor
  init(session: Session?) {
    self.model = DashboardViewModel(session: session)
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  
  // MARK: - Setting the session
  
  @MainActor
  func setSession(_ session: Session?) {
    model.session = session
  }
  
  
  // MARK: - Fetching wallet info
  
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func attemptFetchingWalletInfo() {
    guard model.isFetchingWalletInfo == false,
          let session = model.session
    else { return }
    
    model.isFetchingWalletInfo = true
    currentTask = Task {
      do {
        let walletInfo = try await Self.__proxy_fetchWalletInfo()
        await MainActor.run { [weak self] in
          guard let self else { return }
          self.showSuccess(walletInfo: walletInfo)
        }
      } catch {
        await MainActor.run { [weak self] in
          guard let self else { return }
          self.showFailure(error: error)
        }
      }
    }
  }
  
  /// Proxy function that simulates an API call to fetch wallet info.
  private static func __proxy_fetchWalletInfo() async throws -> WalletInfo {
    // Introduce a delay to mock network latency.
    try await Task.sleep(nanoseconds: 2_000_000_000)
    // Produce the success result.
    let walletInfo = WalletInfo(
      balance: .init(amount: 1000, currencyCode: "PHP"))
    return walletInfo
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
