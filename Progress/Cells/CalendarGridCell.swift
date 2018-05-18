//
//  CalendarGridCell.swift
//  Streaks
//
//  Created by Gregory Klein on 12/25/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

protocol CalendarGridCellDelegate: class {
   func cellDoubleTapped(cell: CalendarGridCell)
   func cellLongPressed(cell: CalendarGridCell)
}

class CalendarGridCell: UICollectionViewCell {
   static var reuseID = "CalendarGridCell"
   static var df: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "MMM"
      return df
   }
   
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: reuseID)
   }
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath, date: Date, activity: Activity?) -> CalendarGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CalendarGridCell
      cell.configure(with: date, activity: activity)
      return cell
   }
   
   fileprivate lazy var _label: UILabel = {
      let label = UILabel()
      label.font = UIFont(14, .light)
      label.textColor = UIColor(.outerSpace, alpha: 0.6)
      return label
   }()
   
   var _doubleTapRecognizer: UITapGestureRecognizer!
   var _longPressRecognizer: UILongPressGestureRecognizer!
   
   weak var delegate: CalendarGridCellDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      _label.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_label)
      NSLayoutConstraint.activate([
         _label.centerXAnchor.constraint(equalTo: centerXAnchor),
         _label.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
      
      _doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarGridCell._doubleTapped))
      _doubleTapRecognizer.numberOfTapsRequired = 2
      
      _longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CalendarGridCell._longPressed))
      contentView.addGestureRecognizer(_doubleTapRecognizer)
      contentView.addGestureRecognizer(_longPressRecognizer)
   }
   
   override func prepareForReuse() {
      removeGestureRecognizer(_doubleTapRecognizer)
      removeGestureRecognizer(_longPressRecognizer)
   }
   
   @objc private func _doubleTapped() {
      delegate?.cellDoubleTapped(cell: self)
   }
   
   @objc private func _longPressed() {
      delegate?.cellLongPressed(cell: self)
   }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   
   func configure(with date: Date, activity: Activity?) {
      let components = Calendar.current.dateComponents([.month, .day], from: date)
      _label.text = CalendarGridCell.df.string(from: date).uppercased()
      contentView.backgroundColor = activity == nil ? UIColor(hex: "EBEBEB") : UIColor(.lime)
      
      if components.day == 1 {
         contentView.layer.borderColor = UIColor(.outerSpace, alpha: 0.15).cgColor
         contentView.layer.borderWidth = 2
         contentView.layer.cornerRadius = 6
         _label.isHidden = false
      } else {
         contentView.layer.borderWidth = 0
         contentView.layer.cornerRadius = 0
         _label.isHidden = true
      }
   }
}
