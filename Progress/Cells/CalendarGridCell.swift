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
   
   fileprivate lazy var _monthLabel: UILabel = {
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
      
      _monthLabel.translatesAutoresizingMaskIntoConstraints = false
      contentView.addSubview(_monthLabel)
      NSLayoutConstraint.activate([
         _monthLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
         _monthLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
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
      let vm = ViewModel(marker: marker, date: date)
      
      contentView.backgroundColor = vm.cellBackgroundColor
      contentView.layer.borderColor = vm.cellBorderColor.cgColor
      contentView.layer.cornerRadius = vm.cellCornerRadius
      contentView.layer.borderWidth = vm.cellBorderWidth
      
      _monthLabel.isHidden = vm.isMonthLabelHidden
      _monthLabel.textColor = vm.monthLabelTextColor
      _monthLabel.text = vm.monthLabelText
      dayNumberLabel.text = vm.dayNumberLabelText
   }
}

extension CalendarGridCell {
   final class ViewModel {
      let marker: Marker?
      let date: Date
      let components: DateComponents
      init(marker: Marker?, date: Date) {
         self.marker = marker
         self.date = date
         components = Calendar.current.dateComponents([.month, .day], from: date)
      }
      
      var monthLabelTextColor: UIColor {
         guard let m = marker else { return .white }
         return m.color.labelTextColor
      }
      
      var isMonthLabelHidden: Bool {
         switch components.day! {
         case 1: return false
         default: return true
         }
      }
      
      var monthLabelText: String {
         return CalendarGridCell.monthNameDateFormatter.string(from: date).uppercased()
      }
      
      var dayNumberLabelText: String {
         switch components.day! {
         case 1: return ""
         default: return "\(components.day!)"
         }
      }
      
      var cellCornerRadius: CGFloat {
         switch components.day! {
         case 1: return 6
         default: return 0
         }
      }
      
      var cellBorderWidth: CGFloat {
         switch components.day! {
         case 1: return marker == nil ? 0 : 2
         default: return 0
         }
      }
      
      var cellBorderColor: UIColor {
         switch marker {
         case .some: return UIColor(.shadowSpace, alpha: 0.1)
         case .none: return UIColor(.chalkboard, alpha: 0.2)
         }
      }
      
      var cellBackgroundColor: UIColor {
         switch components.day! {
         case 1:
            switch marker {
            case .some(let m): return UIColor(m.color)
            case .none: return UIColor(.chalkboard, alpha: 0.15)
            }
         default:
            switch marker {
            case .some(let m): return UIColor(m.color)
            case .none: return UIColor(.tileGray)
            }
         }
      }
   }
}
