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
  
  struct ListItem {
    let ID: Int
    let iso8601Date: String
    let amount: Decimal
  }
  
}



final class TransactionListViewModelController {
  
  let model: TransactionListViewModel
  
  @MainActor
  init() {
    self.model = TransactionListViewModel()
  }
  
  @MainActor
  func attemptFetchingTransactions() {
    
  }
  
}
