//
//  ViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

protocol ActivityViewControllerDataSource: class {
   func marker(at date: Date) -> Marker?
}

class ActivityViewController: UIViewController {
   fileprivate var _calendarGrid: CalendarGridViewController!
   weak var dataSource: ActivityViewControllerDataSource?
   var viewModel = ViewModel()
   
   var daysBack: TimeInterval = 90 {
      didSet {
         _calendarGrid.reload()
      }
   }
   
   override var canBecomeFirstResponder: Bool {
      get {
         return true
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
   
   // Enable detection of shake motion
   override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
      switch motion {
      case .motionShake: viewModel.shake()
      default: return
      }
   }
   
   func reload() {
      _calendarGrid.reload()
   }
   
   func animateDays(duration: TimeInterval) {
      _calendarGrid.animateDays(duration: duration)
   }
}

protocol ActivityViewControllerDelegate: class {
   func dateDoubleTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath)
   func dateTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath)
   func activityViewControllerDidShake()
}

extension ActivityViewController {
   class ViewModel {
      weak var delegate: ActivityViewControllerDelegate?
      func dateDoubleTapped(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateDoubleTapped(date, in: self, at: indexPath)
      }
      
      func dateTapped(_ date: Date, at indexPath: IndexPath) {
         delegate?.dateTapped(date, in: self, at: indexPath)
      }
      
      func shake() {
         delegate?.activityViewControllerDidShake()
      }
   }
}

extension ActivityViewController: CalendarGridViewControllerDataSource {
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

extension ActivityViewController: CalendarGridViewModelDelegate {
   func dateDoubleTapped(_ date: Date, in viewModel: CalendarGridViewController.ViewModel, at indexPath: IndexPath) {
      self.viewModel.dateDoubleTapped(date, at: indexPath)
   }
   
   func dateTapped(_ date: Date, in: CalendarGridViewController.ViewModel, at indexPath: IndexPath) {
      self.viewModel.dateTapped(date, at: indexPath)
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
