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
   func cellTapped(cell: CalendarGridCell)
}

class CalendarGridCell: UICollectionViewCell {
   static var reuseID = "CalendarGridCell"
   
   static var monthNameDateFormatter: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "MMM"
      return df
   }
   
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: reuseID)
   }
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath, date: Date, marker: Marker?) -> CalendarGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CalendarGridCell
      cell.configure(with: date, marker: marker)
      return cell
   }
   
   fileprivate lazy var _label: UILabel = {
      let label = UILabel()
      label.font = UIFont(14, .medium)
      label.textColor = UIColor(.white)
      return label
   }()
   
   fileprivate(set) lazy var dayNumberLabel: UILabel = {
      let label = UILabel()
      label.font = UIFont(14, .medium)
      label.textColor = UIColor(.shadowSpace, alpha: 0.25)
      return label
   }()
   
   var _doubleTapRecognizer: UITapGestureRecognizer!
   var _singleTapRecognizer: UITapGestureRecognizer!
   
   weak var delegate: CalendarGridCellDelegate?
   
   override init(frame: CGRect) {
      super.init(frame: frame)
      
      _label.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_label)
      NSLayoutConstraint.activate([
         _label.centerXAnchor.constraint(equalTo: centerXAnchor),
         _label.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
      
      dayNumberLabel.alpha = 0
      dayNumberLabel.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(dayNumberLabel)
      NSLayoutConstraint.activate([
         dayNumberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         dayNumberLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
         ])
      
      _doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarGridCell._doubleTapped))
      _doubleTapRecognizer.numberOfTapsRequired = 2
      
      _singleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(CalendarGridCell._singleTapped))
      contentView.addGestureRecognizer(_doubleTapRecognizer)
      contentView.addGestureRecognizer(_singleTapRecognizer)
      
      _singleTapRecognizer.require(toFail: _doubleTapRecognizer)
   }
   
   override func prepareForReuse() {
      removeGestureRecognizer(_doubleTapRecognizer)
      removeGestureRecognizer(_singleTapRecognizer)
   }
   
   @objc private func _doubleTapped() {
      delegate?.cellDoubleTapped(cell: self)
   }
   
   @objc private func _singleTapped() {
      delegate?.cellTapped(cell: self)
   }
   
   required init?(coder aDecoder: NSCoder) { fatalError() }
   
   func configure(with date: Date, marker: Marker?) {
      let components = Calendar.current.dateComponents([.month, .day], from: date)
      _label.text = CalendarGridCell.monthNameDateFormatter.string(from: date).uppercased()
      switch marker {
      case .some(let m): contentView.backgroundColor = UIColor(m.color)
      case .none: contentView.backgroundColor = UIColor(.tileGray)
      }
      
      if components.day == 1 {
         contentView.backgroundColor = marker == nil ? UIColor(.chalkboard, alpha: 0.15) : UIColor(marker!.color)
         contentView.layer.borderColor = marker == nil ? UIColor(.chalkboard, alpha: 0.2).cgColor : UIColor(.shadowSpace, alpha: 0.1).cgColor
         contentView.layer.borderWidth = marker == nil ? 0 : 2
         contentView.layer.cornerRadius = 6
         dayNumberLabel.text = ""
         _label.textColor = marker == nil ? UIColor(.white) : UIColor(.shadowSpace, alpha: 0.2)
         _label.isHidden = false
      } else {
         contentView.layer.borderWidth = 0
         contentView.layer.cornerRadius = 0
         dayNumberLabel.text = "\(components.day!)"
         _label.isHidden = true
      }
   }
}
