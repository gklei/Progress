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
      vc.title = "PROFILE"
      vc.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "user"), selectedImage: #imageLiteral(resourceName: "user"))
      vc.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -10, right: 0)
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _profileVC }
}
