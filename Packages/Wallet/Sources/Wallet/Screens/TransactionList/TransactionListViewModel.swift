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
  @Published fileprivate(set) var error: Error?
  
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
  private let cachedTransactions: [CachedTransaction]
  private let urlSession: URLSession
  
  @MainActor
  init(
    cachedTransactions: [CachedTransaction],
    urlSession: URLSession? = nil
  ) {
    self.model = TransactionListViewModel()
    self.cachedTransactions = cachedTransactions
    self.urlSession = urlSession ?? {
      var config = URLSessionConfiguration.ephemeral
      let session = URLSession(configuration: config)
      return session
    }()
    
//    model.items = Self.makeItemsFromCachedTransactions(cachedTransactions)
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  
  // MARK: - Assembling the transaction history list
  
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func attemptFetchingTransactions(
    
  ) {
    guard !model.isLoading else { return }
    model.isLoading = true
    
    let cachedItems = cachedTransactions
    
    currentTask = Task { [weak self] in
      guard let self else { return }
      
      // Start an items array with the cached transactions.
      var items = Self.makeItemsFromCachedTransactions(cachedItems)
      
      do {
        // If there are no cached items, immediately throw an empty error
        // and avoid making a web service request.
        guard items.count > 0 else {
          throw EmptyError()
        }
        
        // Fetch mock transactions from a fake web service.
        let parameters = GetFakeTransactions.Parameters(limit: 30)
        let request = try GetFakeTransactions.request(withParameters: parameters)
        let (data, response) = try await self.urlSession.data(for: request)
        let success = try await GetFakeTransactions.success(
          fromData: data, response: response)
        
        // Convert the results to transaction items and append.
        let newItems = success.transactions.map {
          TransactionListViewModel.ListItem(
            id: $0.id,
            date: $0.date,
            amount: $0.amount,
            currencyCode: $0.currencyCode)
        }
        items.append(contentsOf: newItems)
        
        // Generate an empty error if there are no results.
        if items.isEmpty {
          throw EmptyError()
        }
        
        // Update the success state.
        await MainActor.run { [weak self] in
          guard let self else { return }
          model.isLoading = false
          model.items = items
          model.error = nil
        }
        
      } catch {
        
        // Show the failure state.
        await MainActor.run { [weak self] in
          guard let self else { return }
          model.isLoading = false
          model.items = []
          model.error = error
        }
      }
    }
  }
  
  private static func makeItemsFromCachedTransactions(
    _ cachedTransactions: [CachedTransaction]
  ) -> [TransactionListViewModel.ListItem] {
    return cachedTransactions.map {
      .init(id: $0.ID,
            date: $0.date,
            amount: $0.amount,
            currencyCode: $0.currencyCode)
    }
  }
  
  private struct EmptyError: LocalizedError {
    var errorDescription: String? { "No transactions available." }
  }
  
}
