//
//  UINavigationController+Progress.swift
//  Progress
//
//  Created by Gregory Klein on 5/24/17.
//  Copyright © 2017 Incipia. All rights reserved.
//

import UIKit

enum NavigationBarStyle {
   case dark, light, white
   
   var barStyle: UIBarStyle {
      switch self {
      case .dark: return .black
      case .light: return .default
      case .white: return .default
      }
   }
   
   var backgroundImage: UIImage {
      switch self {
      case .dark: return UIImage.with(color: .chalkboard)!
      case .light: return UIImage.with(color: .white)!
//         let gradientLayer = CAGradientLayer()
//         let updatedFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 84)
//         gradientLayer.frame = updatedFrame
//         gradientLayer.colors = [UIColor(.lipstick, alpha: 0.25).cgColor,
//                                 UIColor(.pink, alpha: 0.25).cgColor]
//         gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//         gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//         UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//         gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//         let image = UIGraphicsGetImageFromCurrentImageContext()!
//         UIGraphicsEndImageContext()
//         return image
      case .white: return UIImage.with(color: .white)!
      }
   }
   
   var titleColor: UIColor {
      switch self {
      case .dark: return .white
      case .light: return UIColor(.chalkboard)
      case .white: return UIColor(.chalkboard)
//         return UIColor(white: 1, alpha: 1)
      }
   }
   
   var titleWeight: FontWeight {
      switch self {
      case .dark: return .medium
      case .light: return .medium
      case .white: return .medium
      }
   }
   
   var shadowImage: UIImage? {
      switch self {
      case .dark: return nil
      case .light:
         return UIImage.with(color: UIColor(.white))
//         let gradientLayer = CAGradientLayer()
//         let updatedFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 2)
//         gradientLayer.frame = updatedFrame
//         gradientLayer.colors = [UIColor(.lipstick, alpha: 0.7).cgColor, UIColor(.pink, alpha: 0.7).cgColor]
//         gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
//         gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
//
//         UIGraphicsBeginImageContext(gradientLayer.bounds.size)
//         gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
//         let image = UIGraphicsGetImageFromCurrentImageContext()!
//         UIGraphicsEndImageContext()
//         return image
      case .white: return UIImage.with(color: .white)
      }
   }
}

fileprivate class NavigationBar: UINavigationBar {
   init(style: NavigationBarStyle, frame: CGRect) {
      super.init(frame: frame)
      updateAppearance(style: style)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   static func `class`(for style: NavigationBarStyle) -> Swift.AnyClass? {
      switch style {
      case .dark: return DarkNavigationBar.self
      case .light: return LightNavigationBar.self
      case .white: return WhiteNavigationBar.self
      }
   }
}

fileprivate class DarkNavigationBar: NavigationBar {
   init(frame: CGRect) {
      super.init(style: .dark, frame: frame)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

fileprivate class LightNavigationBar: NavigationBar {
   init(frame: CGRect) {
      super.init(style: .light, frame: frame)
      shadowColor = UIColor(.shadowSpace)
      shadowOffset = CGSize(width: 0, height: 2.5)
      shadowRadius = 20
      shadowOpacity = 0.14
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

fileprivate class WhiteNavigationBar: NavigationBar {
   init(frame: CGRect) {
      super.init(style: .white, frame: frame)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
}

extension UINavigationController {
   convenience init(style: NavigationBarStyle) {
      self.init(navigationBarClass: NavigationBar.class(for: style), toolbarClass: nil)
   }
}

extension UINavigationBar {
   func updateAppearance(style: NavigationBarStyle) {
      shadowImage = style.shadowImage
      barStyle = style.barStyle
      setBackgroundImage(style.backgroundImage, for: .default)
      titleTextAttributes = UINavigationBar.titleAttributes(for: style)
   }
   
   class func titleAttributes(for style: NavigationBarStyle) -> [String : Any] {
      return [
         NSFontAttributeName : UIFont(14, style.titleWeight),
         NSForegroundColorAttributeName : style.titleColor,
         NSKernAttributeName : 4.0
      ]
   }
}
