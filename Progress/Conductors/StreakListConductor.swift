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
   fileprivate var _editing = false
   let dataLayer: StreaksDataLayer
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
      _updateStreakListViewController()
   }
   
   @objc private func _addStreak() {
      let streak = dataLayer.createNewStreak()
      _updateStreakListViewController()
      _show(streak: streak, isNew: true)
   }
   
   fileprivate func _show(streak: Streak, isNew: Bool) {
      streakConductor = StreakConductor(dataLayer: dataLayer, streak: streak, isNew: isNew)
      streakConductor?.delegate = self
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
      guard !_editing else { return }
      _show(streak: streak, isNew: false)
   }
   
   func streakSwipedLeft(_ streak: Streak, in viewModel: StreakListViewController.ViewModel) {
      guard !_editing else { return }
      let alert = UIAlertController(style: .alert, title: "Delete \(streak.name!)?", message: "This cannot be undone.")
      alert.addAction(title: "Cancel", color: UIColor(.outerSpace), style: .default)
      alert.addAction(title: "Delete", color: UIColor(.lipstick), style: .destructive) { action in
         self.dataLayer.delete(streak: streak)
         self._updateStreakListViewController()
      }
      alert.show(animated: true, vibrate: true)
   }
   
   func streakLongPressed(_ streak: Streak, in viewModel: StreakListViewController.ViewModel) {
      guard !_editing else { return }
      _editing = true
      var newName: String? = nil
      let alert = UIAlertController(style: .alert, title: "Edit Name")
      let config: TextField.Config = { textField in
         textField.becomeFirstResponder()
         textField.textColor = UIColor(.outerSpace)
         textField.placeholder = "Edit Streak Name"
         textField.left(image: #imageLiteral(resourceName: " edit-3"), color: UIColor(.outerSpace))
         textField.leftViewPadding = 12
         textField.cornerRadius = 8
         textField.borderColor = UIColor(.outerSpace, alpha: 0.15)
         textField.borderWidth = 1
         textField.backgroundColor = nil
         textField.keyboardType = .default
         textField.autocapitalizationType = .words
         textField.returnKeyType = .done
         textField.text = streak.name
         textField.action { textField in
            newName = textField.text
         }
      }
      alert.addOneTextField(configuration: config)
      alert.addAction(title: "OK", style: .cancel) { action in
         defer { self._editing = false }
         
         guard let text = newName else { return }
         guard !text.isEmpty else { return }
         streak.name = text
         self.dataLayer.save()
         self._streakListVC.setNeedsReload()
      }
      alert.show(animated: true)
   }
}

extension StreakListConductor: StreakConductorDelegate {
   func streakConductor(conductor: StreakConductor, didRenameStreak streak: Streak) {
      _streakListVC.setNeedsReload()
   }
}
