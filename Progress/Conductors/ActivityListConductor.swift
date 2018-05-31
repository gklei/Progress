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
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "list"), selectedImage: #imageLiteral(resourceName: "list"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: " plus"),
                                                             tintColor: UIColor(.outerSpace),
                                                             target: self,
                                                             selector: #selector(ActivityListConductor._addActivity))
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: "info_icon"),
                                                             tintColor: UIColor(.outerSpace),
                                                             target: self,
                                                             selector: #selector(ActivityListConductor._migrateDatabase))
      vc.collectionView.alwaysBounceVertical = true
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _activityListVC }
   
   fileprivate let _queue = OperationQueue()
   fileprivate(set) var activityConductor: ActivityConductor?
   fileprivate(set) var _activityPageConductor: ActivityPageConductor?
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
      _showActivityPages(focusedActivity: activity)
   }
   
   @objc private func _migrateDatabase() {
      let alert = UIAlertController(style: .alert,
                                    title: "Database Migration",
                                    message: "Update all marker timezones to \(TimeZone.autoupdatingCurrent.identifier)?")
      alert.addAction(title: "Cancel", color: UIColor(.outerSpace), style: .default)
      alert.addAction(title: "Update", color: UIColor(.markerBlue), style: .default) { action in
         self.dataLayer.fetchedActivities.forEach {
            $0.markers?.forEach { marker in
               guard (marker as! Marker).timeZoneID == nil else { return }
               (marker as! Marker).timeZoneID = TimeZone.autoupdatingCurrent.identifier
            }
         }
         self.dataLayer.save()
      }
      alert.show(animated: true, vibrate: true)
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
   
   fileprivate func _showActivityPages(focusedActivity activity: Activity) {
      let activities = dataLayer.fetchedActivities
      let conductor = ActivityPageConductor(dataLayer: dataLayer, activities: activities, focusedActivity: activity)
      conductor.delegate = self
      conductor.activiesConductorDelegate = self
      conductor.willDismissBlock = {
         self.delegate?.activityConductorWillDismiss(conductor.focusedConductor, from: self)
      }
      
      delegate?.activityConductorWillShow(conductor.focusedConductor, from: self)
      _activityPageConductor = conductor
      show(conductor: _activityPageConductor)
   }
   
   fileprivate func _updateActivityListViewController() {
      dataLayer.updateFetchedActivities()
      let activities = dataLayer.fetchedActivities
      let vm = ActivityListViewController.ViewModel(model: activities)
      vm.delegate = self
      _activityListVC.viewModel = vm
   }
   
   func reload() {
      _updateActivityListViewController()
      _activityPageConductor?.reload()
   }
}

extension ActivityListConductor: ActivityListViewModelDelegate {
   func activitySelected(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel) {
      guard !_editing else { return }
      _showActivityPages(focusedActivity: activity)
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
         DispatchQueue.main.async { self._updateActivityListViewController() }
      }
      _queue.addOperation(renameOp)
   }
}

extension ActivityListConductor: ActivityConductorDelegate {
   func activityConductor(_ conductor: ActivityConductor, didRenameActivity activity: Activity) {
      reload()
   }
   
   func activityConductorDidShake(_ conductor: ActivityConductor) {
      conductor.animateDays()
   }
}

extension ActivityListConductor: ActivityPageConductorDelegate {
   func activityPageConductor(_ conductor: ActivityPageConductor, didChangeFocusedConductor focusedConductor: ActivityConductor) {
      delegate?.activityConductorWillShow(conductor.focusedConductor, from: self)
   }
}
