//
//  ProfileConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction
import Bindable

protocol ActivitySettingsConductorDelegate: class {
   func settingChanged(key: ActivitySettingsConductor.Key, in conductor: ActivitySettingsConductor)
}

class ActivitySettingsConductor: TabConductor, Bindable {
   enum Key: String, IncKVKeyType {
      case markerColor
   }
   var bindingBlocks: [Key : [((targetObject: AnyObject, rawTargetKey: String)?, Any?) throws -> Bool?]] = [:]
   var keysBeingSet: [Key] = []
   
   func setOwn(value: inout Any?, for key: Key) throws {
      switch key {
      case .markerColor:
         guard let color = value as? ProgressColor else { fatalError() }
         activity.markerColorHex = color.rawValue
         dataLayer.save()
         _settingsVC.reloadColorPicker()
         self.delegate?.settingChanged(key: key, in: self)
      }
   }
   
   func value(for key: Key) -> Any? {
      switch key {
      case .markerColor: return ProgressColor(rawValue: activity.markerColorHex!)
      }
   }
   
   fileprivate lazy var _settingsVC: ActivitySettingsViewController = {
      let vc = ActivitySettingsViewController()
      vc.title = self.activity.name
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: " settings"), selectedImage: #imageLiteral(resourceName: " settings"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      vc.viewModel = ActivitySettingsViewController.ViewModel(model: self)
      return vc
   }()
   
   let dataLayer: ProgressDataLayer
   fileprivate(set) var activity: Activity
   weak var delegate: ActivitySettingsConductorDelegate?
   
   override var rootViewController: UIViewController? { return _settingsVC }
   
   init(dataLayer: ProgressDataLayer, activity: Activity) {
      self.dataLayer = dataLayer
      self.activity = activity
      super.init()
   }
   
   func _update(activity: Activity) {
      self.activity = activity
      _settingsVC.reloadColorPicker()
   }
}
