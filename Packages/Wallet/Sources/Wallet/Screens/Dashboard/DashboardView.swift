//
//  DashboardView.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import SwiftUI

struct DashboardView: View {
  
  let modelController: DashboardViewModelController
  @ObservedObject private var viewModel: DashboardViewModel
  
  private let didTapLogin: (() -> Void)?
  private let didTapLogout: (() -> Void)?
  
  init(
    modelController: DashboardViewModelController,
    didTapLogin: (() -> Void)? = nil,
    didTapLogout: (() -> Void)? = nil
  ) {
    self.modelController = modelController
    self._viewModel = ObservedObject(wrappedValue: modelController.model)
    self.didTapLogin = didTapLogin
    self.didTapLogout = didTapLogout
  }
  
  var body: some View {
    VStack {
      if let session = viewModel.session {
        BalanceSummaryView(modelController: modelController)
      } else {
        Text("No session found")
      }
      
      Button {
        if viewModel.session == nil {
          didTapLogin?()
        } else {
          modelController.setSession(nil)
          didTapLogout?()
        }
      } label: {
        Text(viewModel.session == nil ? "Log in" : "Log out")
      }

    }
  }
  
  
  
  
  private struct BalanceSummaryView: View {
    
    let modelController: DashboardViewModelController
    @ObservedObject private var model: DashboardViewModel
    
    private let amountFormatter = CurrencyAmountFormatter()
    
    init(modelController: DashboardViewModelController) {
      self.modelController = modelController
      self._model = ObservedObject(wrappedValue: modelController.model)
    }
    
    var body: some View {
      if let session = model.session {
        Text("Hello, \(session.username)")
      }
      
      HStack {
        Text("Your balance:")
        
        if model.isFetchingWalletInfo {
          ProgressView()
        } else {
          if model.balanceIsShowing {
            if let balance = model.walletInfo?.balance,
               let string = amountFormatter.string(for: balance.amount) {
              Text(string)
            }
          } else {
            Text("****")
          }
          
          Button {
            modelController.setBalanceIsShowing(!model.balanceIsShowing)
          } label: {
            Text(model.balanceIsShowing ? "Hide" : "Show")
          }

        }
      }
    }
    
    
    
  }
  
}
