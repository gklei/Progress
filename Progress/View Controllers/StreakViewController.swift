//
//  ViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

protocol StreakViewControllerDataSource: class {
   func marker(at date: Date) -> Marker?
}

class StreakViewController: UIViewController {
   fileprivate var _calendarGrid: CalendarGridViewController!
   weak var dataSource: StreakViewControllerDataSource?
   var viewModel = ViewModel()
   
   var daysBack: TimeInterval = 90 {
      didSet {
         _calendarGrid.reload()
      }
   }
   
   override func loadView() {
      let view = UIView()
      _calendarGrid = CalendarGridViewController(dataSource: self)
      _calendarGrid.viewModel.delegate = self
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
   
   func reload() {
      _calendarGrid.reload()
   }
}

protocol StreakViewControllerDelegate: class {
   func dateSelected(_ date: Date, in: StreakViewController.ViewModel, at: IndexPath)
   func dateLongPressed(_ date: Date, in: StreakViewController.ViewModel, at: IndexPath)
}

extension StreakViewController {
   class ViewModel {
      weak var delegate: StreakViewControllerDelegate?
      func dateSelected(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateSelected(date, in: self, at: indexPath)
      }
      
      func dateLongPressed(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateLongPressed(date, in: self, at: indexPath)
      }
   }
}

extension StreakViewController: CalendarGridViewControllerDataSource {
   var calendar: Calendar {
      return .gregorian
   }
   
   var startDate: Date {
      let timeIntervalSinceNow: TimeInterval = 60 * 60 * 24 * daysBack
      let daysAgo = calendar.startOfDay(for: Date(timeIntervalSinceNow: -timeIntervalSinceNow))
      let date =  calendar.startOfDay(for: daysAgo.startOfWeek!)
      return date
   }
   
   var endDate: Date {
      return calendar.startOfDay(for: Date())
   }
   
   func marker(at date: Date) -> Marker? {
      return dataSource?.marker(at: date)
   }
}

extension StreakViewController: CalendarGridViewModelDelegate {
   func dateSelected(_ date: Date, in viewModel: CalendarGridViewController.ViewModel, at indexPath: IndexPath) {
      self.viewModel.dateSelected(date, at: indexPath)
   }
   
   func dateLongPressed(_ date: Date, in: CalendarGridViewController.ViewModel, at indexPath: IndexPath) {
      self.viewModel.dateLongPressed(date, at: indexPath)
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
