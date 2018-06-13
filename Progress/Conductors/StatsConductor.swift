//
//  StatsConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

class StatsConductor: TabConductor {
   fileprivate lazy var _statsVC: StatsViewController = {
      let vc = StatsViewController()
      vc.title = "Stats"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "trending-up"), selectedImage: #imageLiteral(resourceName: "trending-up"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   let dataLayer: ProgressDataLayer
   override var rootViewController: UIViewController? { return _statsVC }
   
   init(dataLayer: ProgressDataLayer) {
      self.dataLayer = dataLayer
      super.init()
   }
}
