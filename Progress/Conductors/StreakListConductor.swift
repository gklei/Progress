//
//  StreakListConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction

class StreakListConductor: TabConductor {
   fileprivate lazy var _streakListVC: StreakListViewController = {
      let vc = StreakListViewController()
      vc.title = "Streaks"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "grid"), selectedImage: #imageLiteral(resourceName: "grid"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: " plus"),
                                                             tintColor: UIColor(.outerSpace),
                                                             target: self,
                                                             selector: #selector(StreakListConductor._addStreak))
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _streakListVC }
   
   fileprivate(set) var streakConductor: StreakConductor?
   let dataLayer: StreaksDataLayer
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
      _updateStreakListViewController()
   }
   
   @objc private func _addStreak() {
      let streak = dataLayer.createNewStreak()
      _updateStreakListViewController()
      _show(streak: streak)
   }
   
   fileprivate func _show(streak: Streak) {
      streakConductor = StreakConductor(dataLayer: dataLayer, streak: streak)
      show(conductor: streakConductor)
   }
   
   fileprivate func _updateStreakListViewController() {
      dataLayer.updateFetchedStreaks()
      let streaks = dataLayer.fetchedStreaks
      let vm = StreakListViewController.ViewModel(model: streaks)
      vm.delegate = self
      _streakListVC.viewModel = vm
   }
}

extension StreakListConductor: StreakListViewModelDelegate {
   func streakSelected(_ streak: Streak, in viewModel: StreakListViewController.ViewModel) {
      _show(streak: streak)
   }
   
   func streakSwipedLeft(_ streak: Streak, in viewModel: StreakListViewController.ViewModel) {
      let alert = UIAlertController(style: .alert, title: "Delete \(streak.name!)?", message: "This cannot be undone.")
      alert.addAction(title: "Cancel", color: UIColor(.outerSpace), style: .default)
      alert.addAction(title: "Delete", color: UIColor(.lipstick), style: .destructive) { action in
         self.dataLayer.delete(streak: streak)
         self._updateStreakListViewController()
      }
      alert.show(animated: true, vibrate: true)
   }
}
