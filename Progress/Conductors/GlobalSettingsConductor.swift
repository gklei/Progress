//
//  StreaksSettingsConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction

class GlobalSettingsConductor: TabConductor {
   fileprivate lazy var _settingsVC: GlobalSettingsViewController = {
      let vc = GlobalSettingsViewController()
      vc.title = "Settings"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: " settings"), selectedImage: #imageLiteral(resourceName: " settings"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _settingsVC }
   
   let dataLayer: ProgressDataLayer
   
   init(dataLayer: ProgressDataLayer) {
      self.dataLayer = dataLayer
      super.init()
   }
}
