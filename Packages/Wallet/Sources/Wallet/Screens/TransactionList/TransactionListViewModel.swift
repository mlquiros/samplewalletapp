//
//  TransactionListViewModel.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation
import Combine

@MainActor
final class TransactionListViewModel: ObservableObject {
  
  @Published fileprivate(set) var isLoading = false
  @Published fileprivate(set) var items = [ListItem]()
  
  struct ListItem: Identifiable, Hashable {
    let id: String
    let date: Date
    let amount: Decimal
    let currencyCode: String
    
    var formattedDate: String {
      date.formatted(
        Date.ISO8601FormatStyle(timeZone: TimeZone.current)
      )
    }
    
    var formattedAmount: String {
      let formatter = CurrencyAmountFormatter.shared
      formatter.currencyCode = currencyCode
      return formatter.string(from: NSDecimalNumber(decimal: amount)) ?? "N/A"
    }
    
  }
  
}



final class TransactionListViewModelController {
  
  let model: TransactionListViewModel
//  private let cachedTransactions: [CachedTransaction]
  
  @MainActor
  init(
    cachedTransactions: [CachedTransaction]
  ) {
    self.model = TransactionListViewModel()
    model.items = cachedTransactions.map {
      .init(id: $0.ID,
            date: $0.date,
            amount: $0.amount,
            currencyCode: $0.currencyCode)
    }
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  
  // MARK: - Assembling the transaction history list
  
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func attemptFetchingTransactions() {
    guard !model.isLoading else { return }
    model.isLoading = true
  }
  
}
