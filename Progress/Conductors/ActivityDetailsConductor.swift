//
//  ActivityDetailsConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit
import Conduction

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
