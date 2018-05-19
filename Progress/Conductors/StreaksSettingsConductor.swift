//
//  StreaksSettingsConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction

class StreaksSettingsConductor: TabConductor {
   fileprivate lazy var _settingsVC: StreaksSettingsViewController = {
      let vc = StreaksSettingsViewController()
      vc.title = "Streaks Settings"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: " settings"), selectedImage: #imageLiteral(resourceName: " settings"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _settingsVC }
   
   let dataLayer: StreaksDataLayer
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
   }
}
