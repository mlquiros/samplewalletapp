//
//  DashboardView.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 4/5/26.
//

import SwiftUI

struct DashboardView: View {
  
  
  
  // MARK: - State management
  
  let modelController: DashboardViewModelController
  @ObservedObject private var model: DashboardViewModel
  
  
  
  // MARK: - Initialization
  
  init(
    modelController: DashboardViewModelController,
    callbacks: Callbacks = .init()
  ) {
    self.modelController = modelController
    self._model = ObservedObject(wrappedValue: modelController.model)
    self.callbacks = callbacks
  }
  
  
  
  // MARK: - Call backs
  
  struct Callbacks {
    var didTapLogin: (() -> Void)?
    var didTapLogout: (() -> Void)?
    var didTapSendMoney: (() -> Void)?
    var didTapTransactionList: (() -> Void)?
  }
  
  private let callbacks: Callbacks
  
  
  
  // MARK: - Main view body
  
  var body: some View {
    VStack {
      
      // Subviews for when there is a session.
      if let session = model.session {
        
        BalanceSummaryView(modelController: modelController)
        
        Button {
          callbacks.didTapSendMoney?()
        } label: {
          Text("Send money")
        }
        .disabled(model.isFetchingWalletInfo)
        
        Button {
          callbacks.didTapTransactionList?()
        } label: {
          Text("Transaction history")
        }
      }
      
      // Display for no session.
      else {
        Text("No session found")
      }
      
      // Log in/out
      Button {
        if model.session == nil {
          callbacks.didTapLogin?()
        } else {
          modelController.setSession(nil)
          callbacks.didTapLogout?()
        }
      } label: {
        Text(model.session == nil ? "Log in" : "Log out")
      }

    }
  }
  
  
  
  // MARK: - Subviews
  
  /// The subview that shows the current user's wallet balance.
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
      
      .onChange(of: model.walletInfo?.balance.currencyCode) { newValue in
        amountFormatter.currencyCode = newValue
      }
    }
    
  }
  
}
