//
//  ActivityDetailsConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit
import Bindable
import Conduction

class ActivityDetailsConductor: Conductor, Bindable {
   enum Key: String, IncKVKeyType {
      case activityDetails
   }
   var bindingBlocks: [Key : [((targetObject: AnyObject, rawTargetKey: String)?, Any?) throws -> Bool?]] = [:]
   var keysBeingSet: [Key] = []
   var activityDetails: String = ""
   
   func setOwn(value: inout Any?, for key: ActivityDetailsConductor.Key) throws {
      switch key {
      case .activityDetails: activityDetails = value as? String ?? ""
      }
   }
   
   func value(for key: ActivityDetailsConductor.Key) -> Any? {
      switch key {
      case .activityDetails: return activityDetails
      }
   }
   
   static var df: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "E, MMM d"
      return df
   }
   
   fileprivate lazy var _detailsVC: ActivityDetailsViewController = {
      let vc = ActivityDetailsViewController()
      vc.title = ActivityDetailsConductor.df.string(from: self.date)
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "arrow_left"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      vc.viewModel = ActivityDetailsViewController.ViewModel(model: self)
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _detailsVC }
   
   let dataLayer: StreaksDataLayer
   let streak: Streak
   let activity: Activity?
   let date: Date
   
   init(dataLayer: StreaksDataLayer, streak: Streak, activity: Activity?, date: Date) {
      self.dataLayer = dataLayer
      self.streak = streak
      self.activity = activity
      activityDetails = activity?.descriptionText ?? ""
      self.date = date
      super.init()
   }
   
   override func conductorWillDismiss(from context: UINavigationController) {
      if let activity = activity {
         activity.descriptionText = activityDetails
      } else {
         dataLayer.createActivity(at: date, for: streak, with: activityDetails)
      }
      dataLayer.save()
   }
}
