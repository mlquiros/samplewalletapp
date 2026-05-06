//
//  TransactionListItemCell.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import UIKit

final class TransactionListItemCell: UICollectionViewCell {
  
  @IBOutlet private(set) weak var dateLabel: UILabel!
  @IBOutlet private(set) weak var amountLabel: UILabel!
  @IBOutlet private(set) weak var idLabel: UILabel!
  
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    initialize()
  }
  
  private func initialize() {
    addViewFromNib()
    
    // Add a view for the selected background.
    selectedBackgroundView = UIView(frame: .zero)
    selectedBackgroundView?.backgroundColor = .systemGray4
  }
  
  private func addViewFromNib() {
    let view = Bundle.module.loadNibNamed(
      "TransactionListItemView", owner: self)!.first as! UIView
    contentView.addSubview(view)
    
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.trailingAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor).isActive = true
    view.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor).isActive = true
    
    view.isUserInteractionEnabled = false
  }
  
}
