//
//  ActivityListConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction

class ActivityListConductor: TabConductor {
   fileprivate lazy var _activityListVC: ActivityListViewController = {
      let vc = ActivityListViewController()
      vc.title = "Activities"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "grid"), selectedImage: #imageLiteral(resourceName: "grid"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: " plus"),
                                                             tintColor: UIColor(.outerSpace),
                                                             target: self,
                                                             selector: #selector(ActivityListConductor._addActivity))
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _activityListVC }
   
   fileprivate(set) var activityConductor: ActivityConductor?
   fileprivate var _editing = false
   let dataLayer: StreaksDataLayer
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
      _updateActivityListViewController()
   }
   
   @objc private func _addActivity() {
      let activity = dataLayer.createNewActivity()
      _updateActivityListViewController()
      _show(activity: activity, isNew: true)
   }
   
   fileprivate func _show(activity: Activity, isNew: Bool) {
      activityConductor = ActivityConductor(dataLayer: dataLayer, activity: activity, isNew: isNew)
      activityConductor?.delegate = self
      show(conductor: activityConductor)
   }
   
   fileprivate func _updateActivityListViewController() {
      dataLayer.updateFetchedActivities()
      let activities = dataLayer.fetchedActivities
      let vm = ActivityListViewController.ViewModel(model: activities)
      vm.delegate = self
      _activityListVC.viewModel = vm
   }
}

extension ActivityListConductor: ActivityListViewModelDelegate {
   func activitySelected(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel) {
      guard !_editing else { return }
      _show(activity: activity, isNew: false)
   }
   
   func activitySwipedLeft(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel) {
      guard !_editing else { return }
      let alert = UIAlertController(style: .alert, title: "Delete \(activity.name!)?", message: "This cannot be undone.")
      alert.addAction(title: "Cancel", color: UIColor(.outerSpace), style: .default)
      alert.addAction(title: "Delete", color: UIColor(.lipstick), style: .destructive) { action in
         self.dataLayer.delete(activity: activity)
         self._updateActivityListViewController()
      }
      alert.show(animated: true, vibrate: true)
   }
   
   func activityLongPressed(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel) {
      guard !_editing else { return }
      _editing = true
      var newName: String? = nil
      let alert = UIAlertController(style: .alert, title: "Edit Name")
      let config: TextField.Config = { textField in
         textField.becomeFirstResponder()
         textField.textColor = UIColor(.outerSpace)
         textField.placeholder = "Edit Activity Name"
         textField.left(image: #imageLiteral(resourceName: " edit-3"), color: UIColor(.outerSpace))
         textField.leftViewPadding = 12
         textField.cornerRadius = 8
         textField.borderColor = UIColor(.outerSpace, alpha: 0.15)
         textField.borderWidth = 1
         textField.backgroundColor = nil
         textField.keyboardType = .default
         textField.autocapitalizationType = .words
         textField.returnKeyType = .done
         textField.text = activity.name
         textField.action { textField in
            newName = textField.text
         }
      }
      alert.addOneTextField(configuration: config)
      alert.addAction(title: "OK", style: .cancel) { action in
         defer { self._editing = false }
         
         guard let text = newName else { return }
         guard !text.isEmpty else { return }
         activity.name = text
         self.dataLayer.save()
         self._activityListVC.setNeedsReload()
      }
      alert.show(animated: true)
   }
}

extension ActivityListConductor: ActivityConductorDelegate {
   func activityConductor(conductor: ActivityConductor, didRenameActivity activity: Activity) {
      _activityListVC.setNeedsReload()
   }
}
