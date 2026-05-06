//
//  UserDefaults+Transaction.swift
//  SampleWalletApp
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import Foundation

extension UserDefaults {
  
  /// The transactions that occurred during a single user session.
  ///
  /// > Warning: This array is purged when the user logs out, and all
  /// previously stored transactions are effectively lost.
  ///
  /// > Important: This approach is extremely inefficient. Transactions should
  /// be cached using Core Data and managed objects, but we'll use UserDefaults
  /// for this demo app to avoid all the set up.
  /// >
  /// > There should be more nuance involved when merging purely local objects
  /// (i.e. the send money transactions) with data fetched from a mock web service,
  /// and then sorting them in a single list---but we will keep the implementation
  /// deliberately simple for this app.
  var transactions: [Transaction] {
    
    get {
      guard let data = data(forKey: Key.transactions.rawValue),
            let transactions = try? JSONDecoder().decode(
              [Transaction].self, from: data) else {
        return []
      }
      return transactions
    }
    
    set {
      if newValue.isEmpty {
        removeObject(forKey: Key.transactions.rawValue)
      } else if let data = try? JSONEncoder().encode(newValue) {
        set(data, forKey: Key.transactions.rawValue)
      }
    }
    
  }
  
}
