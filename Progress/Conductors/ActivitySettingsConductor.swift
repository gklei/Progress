//
//  ProfileConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction
import Bindable

class ActivitySettingsConductor: TabConductor, Bindable {
   enum Key: String, IncKVKeyType {
      case markerColor
   }
   var bindingBlocks: [Key : [((targetObject: AnyObject, rawTargetKey: String)?, Any?) throws -> Bool?]] = [:]
   var keysBeingSet: [Key] = []
   
   func setOwn(value: inout Any?, for key: Key) throws {
      switch key {
      case .markerColor: print("Setting marker color: \(value as! StreaksColor)")
      }
   }
   
   func value(for key: Key) -> Any? {
      switch key {
      case .markerColor: return StreaksColor(rawValue: activity.markerColorHex!)
      }
   }
   
   fileprivate lazy var _settingsVC: ActivitySettingsViewController = {
      let vc = ActivitySettingsViewController()
      vc.title = "Activity Settings"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: " settings"), selectedImage: #imageLiteral(resourceName: " settings"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   let activity: Activity
   override var rootViewController: UIViewController? { return _settingsVC }
   
   init(dataLayer: StreaksDataLayer, activity: Activity) {
      self.dataLayer = dataLayer
      self.activity = activity
      super.init()
   }
}
