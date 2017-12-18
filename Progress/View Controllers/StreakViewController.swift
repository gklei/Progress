//
//  ViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

class StreakViewController: UIViewController {
   fileprivate let _calendarGrid = CalendarGridViewController()
   var daysBack: TimeInterval = 90 {
      didSet {
         _calendarGrid.reload()
      }
   }
   
   override func loadView() {
      let view = UIView()
      
      _calendarGrid.dataSource = self
      addChildViewController(_calendarGrid)
      _calendarGrid.view.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(_calendarGrid.view)
      NSLayoutConstraint.activate([
         _calendarGrid.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         _calendarGrid.view.topAnchor.constraint(equalTo: view.topAnchor),
         _calendarGrid.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         _calendarGrid.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
      
      self.view = view
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
}

extension StreakViewController: CalendarGridViewControllerDataSource {
   var calendar: Calendar { return .gregorian }
   var startDate: Date {
      let timeIntervalSinceNow: TimeInterval = 60 * 60 * 24 * daysBack
      let daysAgo = calendar.startOfDay(for: Date(timeIntervalSinceNow: -timeIntervalSinceNow))
      let date =  calendar.startOfDay(for: daysAgo.startOfWeek!)
      return date
   }
   var endDate: Date {
      return calendar.startOfDay(for: Date())
   }
}

extension Calendar {
   static let gregorian = Calendar(identifier: .gregorian)
}

extension Date {
   var startOfWeek: Date? {
      let calendar = Calendar.gregorian
      let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
      return calendar.date(from: components)
   }
}
