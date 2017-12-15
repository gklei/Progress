//
//  AppRouter.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit
import Elemental

class AppRouter {
   let rootNavigationController = UINavigationController(style: .dark)
   let mainConductor = MainConductor()
   
   init(window: UIWindow) {
      window.rootViewController = rootNavigationController
      window.makeKeyAndVisible()
      
      mainConductor.show(with: rootNavigationController)
   }
}
