//
//  RenameActivityOperation.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Foundation
import UIKit

class RenameActivityOperation: BaseOperation {
   enum Result {
      case renamed(String), cancelled
   }
   
   let dataLayer: StreaksDataLayer
   let activity: Activity
   let style: UIAlertControllerStyle
   let alertTitle: String?
   let textFieldBorderWidth: CGFloat
   fileprivate(set) var result: Result = .cancelled
   
   init(dataLayer: StreaksDataLayer, activity: Activity, style: UIAlertControllerStyle, alertTitle: String? = nil, textFieldBorderWidth: CGFloat = 0) {
      self.dataLayer = dataLayer
      self.activity = activity
      self.style = style
      self.alertTitle = alertTitle
      self.textFieldBorderWidth = textFieldBorderWidth
   }
   
   override func execute() {
      var newName: String? = nil
      let alert = UIAlertController(style: style, title: alertTitle)
      let config: TextField.Config = { textField in
         textField.becomeFirstResponder()
         textField.textColor = UIColor(.chalkboard)
         textField.placeholder = "Edit Activity Name"
         textField.left(image: #imageLiteral(resourceName: " edit-3"), color: UIColor(.chalkboard))
         textField.leftViewPadding = 12
         textField.cornerRadius = 8
         textField.borderColor = UIColor(.chalkboard, alpha: 0.15)
         textField.borderWidth = self.textFieldBorderWidth
         textField.backgroundColor = nil
         textField.keyboardType = .default
         textField.autocapitalizationType = .words
         textField.returnKeyType = .done
         textField.text = self.activity.name
         textField.clearButtonMode = .always
         textField.action { textField in
            newName = textField.text
         }
      }
      alert.addOneTextField(configuration: config)
      alert.addAction(title: "Cancel", color: UIColor(.markerBlue), style: .cancel) { action in
         self.result = .cancelled
         self.finish()
      }
      alert.addAction(title: "OK", style: .default) { action in
         guard let text = newName, !text.isEmpty else {
            self.result = .cancelled
            self.finish()
            return
         }
         self.activity.name = text
         self.dataLayer.save()
         self.result = .renamed(text)
         self.finish()
      }
      alert.show(animated: true)
   }
}
