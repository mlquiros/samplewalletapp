//
//  SendMoneyView.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 5/5/26.
//

import UIKit

final class SendMoneyView: UIView {
  
  @IBOutlet private(set) weak var amountTextField: UITextField!
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  // MARK: - Setup
  
  private func initialize() {
    addViewFromNib()
  }
  
  private func addViewFromNib() {
    let view = Bundle.module.loadNibNamed(
      "SendMoneyView", owner: self)!.first! as! UIView
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: topAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
  }
  
}
