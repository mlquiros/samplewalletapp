//
//  TransactionListView.swift
//  Wallet
//
//  Created by Matthew L. Quiros on 6/5/26.
//

import UIKit

final class TransactionListView: UIView {
  
  @IBOutlet private(set) weak var collectionView: UICollectionView!
  
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
  }
  
  private func addViewFromNib() {
    let view = Bundle.module.loadNibNamed(
      "TransactionListView", owner: self)!.first as! UIView
    addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.topAnchor.constraint(equalTo: topAnchor).isActive = true
    view.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    view.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
  }
  
}
