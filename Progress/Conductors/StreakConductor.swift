//
//  StreakConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

class StreakConductor: Conductor {
   fileprivate lazy var _streakVC: StreakViewController = {
      let vc = StreakViewController()
//      vc.title = self.streak.name
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "chevron-left"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: "three_dots"),
                                                             tintColor: UIColor(.outerSpace),
                                                             target: self,
                                                             selector: #selector(StreakConductor._menuSelected))
      vc.dataSource = self
      let vm = StreakViewController.ViewModel()
      vm.delegate = self
      vc.viewModel = vm
      
      let titleView = UILabel()
      titleView.text = self.streak.name
      titleView.font = UIFont(14, .light)
      let width = titleView.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                height: CGFloat.greatestFiniteMagnitude)).width
      titleView.frame = CGRect(origin: .zero, size:CGSize(width: width, height: 500))
      let recognizer = UITapGestureRecognizer(target: self, action: #selector(StreakConductor._titleTapped))
      titleView.isUserInteractionEnabled = true
      titleView.addGestureRecognizer(recognizer)
      vc.navigationItem.titleView = titleView
      
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   let streak: Streak
   var activity: [Activity] { return dataLayer.fetchedData }
   
   fileprivate(set) var detailsConductor: ActivityDetailsConductor?
   var feedbackGenerator: UIImpactFeedbackGenerator?
   fileprivate var _isShowingDetails = false
   
   override var rootViewController: UIViewController? { return _streakVC }
   
   init(dataLayer: StreaksDataLayer, streak: Streak) {
      self.dataLayer = dataLayer
      self.streak = streak
      super.init()
   }
   
   @objc private func _menuSelected() {
   }
   
   @objc private func _titleTapped() {
   }
}

extension StreakConductor: StreakViewControllerDelegate {
   func dateSelected(_ date: Date, in: StreakViewController.ViewModel, at indexPath: IndexPath) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      dataLayer.toggleActivity(at: date, for: streak)
      _streakVC.reload()
   }
   
   func dateLongPressed(_ date: Date, in: StreakViewController.ViewModel, at: IndexPath) {
      guard detailsConductor?.context == nil else { return }
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
    
      let activity = streak.activity(for: date)
      detailsConductor = ActivityDetailsConductor(dataLayer: dataLayer, streak: streak, activity: activity, date: date)
      detailsConductor?.willDismissBlock = {
         self._streakVC.reload()
      }
      show(conductor: detailsConductor)
   }
}

extension StreakConductor: StreakViewControllerDataSource {
   func activity(at date: Date) -> Activity? {
      return streak.activity(for: date)
   }
}
