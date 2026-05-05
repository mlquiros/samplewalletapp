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
  
  /// Determines whether the supplied string is a valid currency amount.
  ///
  /// - Parameters:
  ///   - string: The string to be tested.
  ///
  /// - Returns: A `Result` containing the valid amount as a `Decimal` value,
  /// or an `Error` explaining the failure if it is invalid.
  func validateCurrencyAmount(
    fromString string: String
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
  
  @discardableResult
  func validateTransactionAmount(_ amount: Decimal) throws -> Decimal {
    if amount <= walletBalance.amount {
      return amount
    }
    throw InsufficientBalance()
  }
  
  struct InsufficientBalance: LocalizedError {
    var errorDescription: String? { "Insufficient balance" }
  }
  
  
  
  // MARK: -
  
  private var currentTask: Task<Void, Never>?
  
  @MainActor
  func attemptSendingMoney(
//    successBlock: (@MainActor (_ success: SendMoney.Success) -> Void)? = nil,
//    failureBlock: (@MainActor (_ error: Error) -> Void)? = nil
    completionBlock: (@MainActor (_ result: Result<SendMoney.Success, Error>) -> Void)? = nil
  ) {
    guard model.isProcessing == false else { return }
    
    model.isProcessing = true
    let amountText = model.amountText
    let currencyCode = walletBalance.currencyCode
    let walletBalance = walletBalance
    
    currentTask = Task { [weak self] in
      do {
        guard let self else { return }
        let amount = try validateCurrencyAmount(fromString: amountText)
        try validateTransactionAmount(amount)
        
        // Build request parameters and fake an API call to send the money.
        let parameters = SendMoney.Parameters(
          amountToSend: CurrencyAmount(amount: amount, currencyCode: currencyCode),
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
  
  private static func __sendMoney(
    amount: Decimal,
    originalWalletBalance: CurrencyAmount
  ) async throws -> SendMoney.Success {
    
    // Sleep to emulate an actual API call.
    await try Task.sleep(nanoseconds: 2_000_000_000)
    
    // Determine the currency for the success result.
    let currencyCode = originalWalletBalance.currencyCode
    
    let success = SendMoney.Success(
      
      // Assume that the amount sent is in the same currency as the wallet balance.
      amountSent: CurrencyAmount(amount: amount, currencyCode: currencyCode),
      
      // Compute for the new wallet balance.
      walletBalance: CurrencyAmount(
        amount: originalWalletBalance.amount - amount,
        currencyCode: currencyCode))
    
    return success
  }
  
}
