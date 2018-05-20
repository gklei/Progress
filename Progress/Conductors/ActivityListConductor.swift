//
//  ActivityListConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction

protocol ActivityListConductorDelegate: class {
   func activityConductorWillShow(_ conductor: ActivityConductor, from listConductor: ActivityListConductor)
   func activityConductorWillDismiss(_ conductor: ActivityConductor, from listConductor: ActivityListConductor)
}

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
   
   fileprivate let _queue = OperationQueue()
   fileprivate(set) var activityConductor: ActivityConductor?
   fileprivate var _editing = false
   let dataLayer: StreaksDataLayer
   weak var delegate: ActivityListConductorDelegate?
   
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
      let conductor = ActivityConductor(dataLayer: dataLayer, activity: activity, isNew: isNew)
      conductor.delegate = self
      conductor.willDismissBlock = {
         self.delegate?.activityConductorWillDismiss(conductor, from: self)
      }
      
      delegate?.activityConductorWillShow(conductor, from: self)
      activityConductor = conductor
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
      alert.addAction(title: "Cancel", color: UIColor(.markerBlue), style: .default)
      alert.addAction(title: "Delete", color: UIColor(.lipstick), style: .destructive) { action in
         self.dataLayer.delete(activity: activity)
         self._updateActivityListViewController()
      }
      alert.show(animated: true, vibrate: true)
   }
   
   func activityLongPressed(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel) {
      guard !_editing else { return }
      _editing = true
      
      let renameOp = RenameActivityOperation(dataLayer: dataLayer,
                                             activity: activity,
                                             style: .alert,
                                             alertTitle: "Rename Activity",
                                             textFieldBorderWidth: 1)
      renameOp.completionBlock = {
         self._editing = false
         DispatchQueue.main.async { self._activityListVC.setNeedsReload() }
      }
      _queue.addOperation(renameOp)
   }
}

extension ActivityListConductor: ActivityConductorDelegate {
   func activityConductor(conductor: ActivityConductor, didRenameActivity activity: Activity) {
      _activityListVC.setNeedsReload()
   }
}
