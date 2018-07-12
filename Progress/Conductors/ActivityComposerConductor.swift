//
//  ActivityComposerConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 6/21/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction

class ActivityComposerConductor: TabConductor {
   fileprivate lazy var _settingsVC: ActivityComposerViewController = {
      let vc = ActivityComposerViewController()
      vc.title = "Composer"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "box"), selectedImage: #imageLiteral(resourceName: "box"))
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
