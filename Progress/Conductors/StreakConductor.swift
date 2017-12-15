//
//  StreakConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

class StreakConductor: TabConductor {
   fileprivate lazy var _streakVC: StreakViewController = {
      let vc = StreakViewController()
      vc.title = "PROGRESS"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "grid"), selectedImage: #imageLiteral(resourceName: "grid"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _streakVC }
}
