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
   
   override var rootViewController: UIViewController? { return _streakVC }
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
   }
}

extension StreakConductor: StreakViewControllerDelegate {
   func dateSelected(_ date: Date, in: StreakViewController.ViewModel, at indexPath: IndexPath) {
      dataLayer.toggleActivity(at: date)
      _streakVC.reload()
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
