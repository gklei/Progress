//
//  StreakConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

class StreakConductor: TabConductor {
   fileprivate lazy var _streakVC: StreakViewController = {
      let vc = StreakViewController()
      vc.title = "Streaks"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "grid"), selectedImage: #imageLiteral(resourceName: "grid"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: "three_dots"),
                                                             tintColor: UIColor(.outerSpace),
                                                             target: self,
                                                             selector: #selector(StreakConductor._menuSelected))
      vc.dataSource = self
      
      let vm = StreakViewController.ViewModel()
      vm.delegate = self
      vc.viewModel = vm
      
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   var activity: [Activity] { return dataLayer.fetchedData }
   
   fileprivate(set) var detailsConductor: ActivityDetailsConductor?
   var feedbackGenerator: UIImpactFeedbackGenerator?
   fileprivate var _isShowingDetails = false
   
   override var rootViewController: UIViewController? { return _streakVC }
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
   }
   
   @objc private func _menuSelected() {
   }
}

extension StreakConductor: StreakViewControllerDelegate {
   func dateSelected(_ date: Date, in: StreakViewController.ViewModel, at indexPath: IndexPath) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      dataLayer.toggleActivity(at: date)
      _streakVC.reload()
   }
   
   func dateLongPressed(_ date: Date, in: StreakViewController.ViewModel, at: IndexPath) {
      guard detailsConductor?.context == nil else { return }
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
    
      let activity = dataLayer.activity(at: date)
      detailsConductor = ActivityDetailsConductor(activity: activity, date: date)
      show(conductor: detailsConductor)
   }
}

extension StreakConductor: StreakViewControllerDataSource {
   func activity(at date: Date) -> Activity? {
      return dataLayer.activity(at: date)
   }
}

class ActivityDetailsConductor: Conductor {
   static var df: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "E, MMM d"
      return df
   }
   
   fileprivate lazy var _detailsVC: ActivityDetailsViewController = {
      let vc = ActivityDetailsViewController(model: self.activity)
      vc.title = ActivityDetailsConductor.df.string(from: self.date)
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "arrow_left"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _detailsVC }
   
   let activity: Activity?
   let date: Date
   
   init(activity: Activity?, date: Date) {
      self.activity = activity
      self.date = date
      super.init()
   }
}
