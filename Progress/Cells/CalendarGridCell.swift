//
//  CalendarGridCell.swift
//  Streaks
//
//  Created by Gregory Klein on 12/25/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

class CalendarGridCell: UICollectionViewCell {
   static var reuseID = "CalendarGridCell"
   static var df: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "MM/dd"
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
      label.font = UIFont(12, .medium)
      label.textColor = UIColor(.pink)
      return label
   }()
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      _label.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_label)
      NSLayoutConstraint.activate([
         _label.centerXAnchor.constraint(equalTo: centerXAnchor),
         _label.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
   }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   
   func configure(with date: Date, activity: Activity?) {
      let components = Calendar.current.dateComponents([.month, .day], from: date)
      _label.text = "\(components.month!)/\(components.day!)"
      _label.isHidden = true
      contentView.backgroundColor = activity == nil ? UIColor(hex: "EBEBEB") : .green
      
      if components.day == 1 {
         contentView.layer.borderColor = UIColor(.outerSpace).cgColor
         contentView.layer.borderWidth = 2
         contentView.layer.cornerRadius = 4
      } else {
         contentView.layer.borderWidth = 0
         contentView.layer.cornerRadius = 0
      }
   }
}
