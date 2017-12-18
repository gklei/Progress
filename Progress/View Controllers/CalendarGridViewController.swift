//
//  CalendarGridViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/17/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit
import ALGReversedFlowLayout

protocol CalendarGridViewControllerDataSource: class {
   var calendar: Calendar { get }
   var startDate: Date { get }
   var endDate: Date { get }
}

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
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath, date: Date) -> CalendarGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! CalendarGridCell
      cell.configure(with: date)
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
   
   func configure(with date: Date) {
      let components = Calendar.current.dateComponents([.month, .day], from: date)
      _label.text = "\(components.month!)/\(components.day!)"
   }
}

class CalendarGridViewController : UIViewController {
   weak var dataSource: CalendarGridViewControllerDataSource?
   
   fileprivate var _cv: UICollectionView!
   fileprivate let _spacingFraction: CGFloat = 0.032
   
   override func loadView() {
      let view = UIView()
      
      let layout = ALGReversedFlowLayout()
      _cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      _cv.dataSource = self
      _cv.delegate = self
      CalendarGridCell.register(collectionView: _cv)
      
      _cv.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(_cv)
      NSLayoutConstraint.activate([
         _cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         _cv.topAnchor.constraint(equalTo: view.topAnchor),
         _cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         _cv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
      
      self.view = view
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      _cv.backgroundColor = .clear
   }
   
   func reload() {
      _cv.reloadData()
   }
}

extension CalendarGridViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      guard let ds = dataSource else { return 0 }
      let components = ds.calendar.dateComponents([.day], from: ds.startDate, to: ds.endDate)
      guard let totalDays = components.day else { return 0 }
      return totalDays + 1
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let date = _date(for: indexPath)
      let cell = CalendarGridCell.dequeueCell(with: collectionView, at: indexPath, date: date)
      cell.backgroundColor = UIColor(hex: "EBEBEB")
      return cell
   }
   
   fileprivate func _date(for indexPath: IndexPath) -> Date {
      guard let ds = dataSource else { fatalError() }
      
      var components = DateComponents()
      components.day = indexPath.row
      
      return ds.calendar.date(byAdding: components, to: ds.startDate)!
   }
}

extension CalendarGridViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let df = DateFormatter()
      df.calendar = dataSource!.calendar
      df.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
      df.locale = Locale.current
      df.timeZone = NSTimeZone.system
      let date = _date(for: indexPath)
      print(date)
      print(df.string(from: date))
   }
}

extension CalendarGridViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      let sidePadding = collectionView.bounds.width * _spacingFraction
      return UIEdgeInsets(top: sidePadding, left: sidePadding, bottom: sidePadding, right: sidePadding)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      guard let ds = dataSource else { return .zero }
      
      let itemsPerRow = CGFloat(ds.calendar.weekdaySymbols.count)
      let spacing: CGFloat = collectionView.bounds.width * _spacingFraction
      let totalSpacing = (itemsPerRow + 1) * spacing
      
      let size = (collectionView.bounds.size.width - totalSpacing) / CGFloat(ds.calendar.weekdaySymbols.count)
      return CGSize(width: size, height: size)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
      return collectionView.bounds.width * _spacingFraction
   }
}
