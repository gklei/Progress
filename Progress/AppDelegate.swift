//
//  AppDelegate.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow? = UIWindow()
   var appRouter: AppRouter?
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      appRouter = AppRouter(window: window!)
      return true
   }
}

