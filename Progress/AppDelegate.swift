//
//  AppDelegate.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit
import IQKeyboardManager

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow? = UIWindow()
   var appRouter: AppRouter?
   let dataLayer = StreaksDataLayer()
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      appRouter = AppRouter(window: window!, dataLayer: dataLayer)
      IQKeyboardManager.shared().isEnabled = true
      return true
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
      dataLayer.save()
   }
}

