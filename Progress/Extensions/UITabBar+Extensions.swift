//
//  UITabBar+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/26/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

extension UITabBar {
   func configureWithProgressUIDefaults() {
      unselectedItemTintColor = UIColor(.white, alpha: 0.5)
      tintColor = .white
      isTranslucent = false
      backgroundImage = UIImage.with(color: .outerSpace)
      
      let gradientLayer = CAGradientLayer()
      gradientLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2)
      gradientLayer.colors = [UIColor(.lipstick).cgColor, UIColor(.pink).cgColor]
      gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)

      UIGraphicsBeginImageContext(gradientLayer.bounds.size)
      gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
      let image = UIGraphicsGetImageFromCurrentImageContext()!
      UIGraphicsEndImageContext()
      
//      shadowImage = UIImage.with(color: .mint)
      shadowImage = image
   }
}
