//
//  SendMoneyViewModel.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import Foundation
import Combine

@MainActor
final class SendMoneyViewModel: ObservableObject {
  
  @Published fileprivate(set) var walletBalanceLabel = ""
  @Published fileprivate(set) var amountText = ""
  
  @Published fileprivate(set) var isProcessing = false
  
}

final class SendMoneyViewModelController {
  
  let model: SendMoneyViewModel
  let walletBalance: CurrencyAmount
  let amountFormatter = CurrencyAmountFormatter()
  
  @MainActor
  init(
    walletBalance: CurrencyAmount
  ) {
    model = SendMoneyViewModel()
    self.walletBalance = walletBalance
    // Compute initial values for the view state.
    reloadContent()
  }
  
  deinit {
    currentTask?.cancel()
  }
  
  
  
  // MARK: - Setting the content
  
  @MainActor
  func reloadContent() {
    if let formattedAmount = amountFormatter.string(for: walletBalance.amount) {
      model.walletBalanceLabel = "Wallet balance: \(formattedAmount)"
    }
  }
  
  @MainActor
  func setAmountText(_ text: String) {
    model.amountText = text
  }
  
  
  
  // MARK: - Validation: Text entry
  
  /// Determines whether the supplied string is a valid monetary amount.
  ///
  /// - Parameters:
  ///   - string: The string to be tested.
  ///
  /// - Returns: The amount string converted into a `Decimal`.
  func validateAmountString(
    _ string: String
  ) throws -> Decimal {
    let pattern = #"^(?:\d+(?:\.\d*)?|\.\d*)?$"#
    
    let regex = try! NSRegularExpression(pattern: pattern)
    let range = NSRange(string.startIndex..<string.endIndex, in: string)
    let firstMatch = regex.firstMatch(in: string, options: [], range: range)
    if firstMatch == nil {
      throw InvalidAmount(originalString: string)
    }
    
    let amountFromString = Decimal(string: string) ?? 0
    return amountFromString
  }
  
  struct InvalidAmount: LocalizedError {
    let originalString: String
    var errorDescription: String? { "Invalid amount '\(originalString)'" }
  }
  
  
  
  // MARK: - Validation: Transaction logic
  
  /// Determines whether the provided amount makes for a valid send money transaction.
  @discardableResult
  func validateTransactionAmount(
    _ amount: CurrencyAmount
  ) throws -> CurrencyAmount {
    
    // Currencies must match.
    guard amount.currencyCode == walletBalance.currencyCode else {
      throw CurrencyMismatch(
        amountCurrencyCode: amount.currencyCode,
        walletCurrencyCode: walletBalance.currencyCode)
    }
    
    guard amount.amount > 0 else {
      throw AmountMustBeGreaterThanZero(intendedAmount: amount)
    }
    
    // Balance in wallet must be enough.
    if amount.amount <= walletBalance.amount {
      return amount
    } else {
      throw InsufficientBalance(
        amountToSend: amount, walletBalance: walletBalance)
    }
  }
  
  private struct CurrencyMismatch: LocalizedError {
    let amountCurrencyCode: String
    let walletCurrencyCode: String
    var errorDescription: String? {
      "Currency mismatch: Sending \(amountCurrencyCode) from wallet in \(walletCurrencyCode)"
    }
  }
  
  private struct AmountMustBeGreaterThanZero: LocalizedError {
    let intendedAmount: CurrencyAmount
    private var formatter: CurrencyAmountFormatter {
      .shared(usingCurrencyCode: intendedAmount.currencyCode)
    }
    
    var errorDescription: String? {
      "Cannot send \(formatter.string(for: intendedAmount.amount)!) " +
      "-- amount must be greater than zero."
    }
  }
  
  private struct InsufficientBalance: LocalizedError {
    
    let amountToSend: CurrencyAmount
    let walletBalance: CurrencyAmount
    
    private var formatter: CurrencyAmountFormatter {
      .shared(usingCurrencyCode: amountToSend.currencyCode)
    }
    
    init(amountToSend: CurrencyAmount, walletBalance: CurrencyAmount) {
      self.amountToSend = amountToSend
      self.walletBalance = walletBalance
    }
    
    var errorDescription: String? {
      "Insufficient balance. " +
      "Sending \(formatter.string(for: amountToSend.amount)!), " +
      "wallet only has \(formatter.string(for: walletBalance.amount)!)."}
  }
  
  
  
  // MARK: -
  
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func attemptSendingMoney(
    completionBlock: (@MainActor (_ result: Result<SendMoney.Success, Error>) -> Void)? = nil
  ) {
    guard model.isProcessing == false else { return }
    
    model.isProcessing = true
    let amountText = model.amountText
    let walletBalance = walletBalance
    
    currentTask = Task { [weak self] in
      do {
        guard let self else { return }
        let amount = try validateAmountString(amountText)
        let amountToSend = CurrencyAmount(amount: amount, currencyCode: walletBalance.currencyCode)
        try validateTransactionAmount(amountToSend)
        
        // Build request parameters and fake an API call to send the money.
        let parameters = SendMoney.Parameters(
          amountToSend: amountToSend,
          walletBalance: walletBalance)
        let success = try await SendMoney.dataTaskSuccess(withParameters: parameters)
        
        await MainActor.run { [weak self] in
          guard let self else { return }
          model.isProcessing = false
          completionBlock?(.success(success))
        }
      } catch {
        await MainActor.run { [weak self] in
          guard let self else { return }
          model.isProcessing = false
          completionBlock?(.failure(error))
        }
      }
    }
    
  }
  
}
