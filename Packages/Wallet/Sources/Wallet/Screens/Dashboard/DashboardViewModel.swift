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
  
  fileprivate init(session: Session? = nil) {
    self.session = session
  }
  
}

/// Manages the state of the `DashboardView`.
final class DashboardViewModelController {
  
  @MainActor
  let model: DashboardViewModel
  
  @MainActor
  init(session: Session?) {
    self.model = DashboardViewModel(session: session)
  }
  
  @MainActor
  func logOut() {
    model.session = nil
  }
  
}
