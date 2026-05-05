//
//  SendMoneyResultView.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import SwiftUI

struct SendMoneyResultView: View {
  
  let result: Result<SendMoney.Success, Error>
  private let amountFormatter = CurrencyAmountFormatter()
  let didTapDismiss: (() -> Void)?
  
  var body: some View {
    NavigationView {
      VStack {
        switch result {
        case .success(let success):
            Text("Successfully sent \(amountFormatter.string(for: success.amountSent.amount)!)")
            Text("Your balance now: \(amountFormatter.string(for: success.walletBalance.amount)!)")
          
        case .failure(let error):
          Text(error.localizedDescription)
        }
      }
      .padding(16)
    }
    
    .toolbar {
      ToolbarItem(placement: .navigationBarTrailing) {
        Button(action: {
          didTapDismiss?()
        }) {
          Image(systemName: "checkmark")
        }
      }
    }
    
  }
  
}
