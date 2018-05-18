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
      vc.dataSource = self
      
      let vm = StreakViewController.ViewModel()
      vm.delegate = self
      vc.viewModel = vm
      
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   var activity: [Activity] { return dataLayer.fetchedData }
   
   let detailsConductor = ActivityDetailsConductor()
   var feedbackGenerator: UIImpactFeedbackGenerator?
   fileprivate var _isShowingDetails = false
   
   override var rootViewController: UIViewController? { return _streakVC }
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
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
      guard detailsConductor.context == nil else { return }
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      show(conductor: detailsConductor)
   }
}

extension StreakConductor: StreakViewControllerDataSource {
   func activity(at date: Date) -> Activity? {
      return dataLayer.activity(at: date)
   }
}

class ActivityDetailsConductor: Conductor {
   fileprivate lazy var _detailsVC: UIViewController = {
      let vc = UIViewController()
      vc.title = "Details"
      vc.view.backgroundColor = .magenta
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "left_arrow"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _detailsVC }
}
