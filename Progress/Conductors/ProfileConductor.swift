//
//  ProfileConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

class ProfileConductor: TabConductor {
   fileprivate lazy var _profileVC: ProfileViewController = {
      let vc = ProfileViewController()
      vc.title = "Settings"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: " settings"), selectedImage: #imageLiteral(resourceName: " settings"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   override var rootViewController: UIViewController? { return _profileVC }
   
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      super.init()
   }
}
