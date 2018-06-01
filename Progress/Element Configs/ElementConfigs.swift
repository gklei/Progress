//
//  ElementConfigs.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Elemental

struct TextStyle: ElementalTextStyling {
   var font: UIFont
   var color: UIColor
   var alignment: NSTextAlignment
   
   init(size: CGFloat, weight: FontWeight, color: UIColor = UIColor(.chalkboard), alignment: NSTextAlignment = .left) {
      self.font = UIFont(size, weight)
      self.color = color
      self.alignment = alignment
   }
}

class TextConfiguration: TextElementConfiguration {
   init(size: CGFloat, weight: FontWeight, alignment: NSTextAlignment = .left, height: CGFloat? = nil) {
      super.init()
      self.textStyle = TextStyle(size: size, weight: weight, alignment: alignment)
      
      if let height = height {
         self.sizeConstraint = ElementalSize(width: .intrinsic, height: .constant(height))
      }
   }
}

class TextInputConfiguration: TextInputElementConfiguration {
   init(keyboardType: UIKeyboardType = .default, autocorrectionType: UITextAutocorrectionType = .default, secureEntry: Bool = false, autocapitalizationType: UITextAutocapitalizationType = .none, isEnabled: Bool = true) {
      super.init(nameStyle: TextStyle(size: 12, weight: .medium),
                 placeholderStyle: TextStyle(size: 14, weight: .medium, color: UIColor(.chalkboard, alpha: 0.4)),
                 inputStyle: TextStyle(size: 14, weight: .medium),
                 keyboardStyle: ElementalKeyboardStyle(type: keyboardType,
//                                                       appearance: .dark,
                                                       autocapitalizationType: autocapitalizationType,
                                                       autocorrectionType: autocorrectionType,
                                                       isSecureTextEntry: secureEntry),
                 inputBackgroundColor: .clear)
      isConfinedToMargins = false
      inputTintColor = UIColor(.chalkboard)
      self.isEnabled = isEnabled
   }
}

class MarkerInputConfiguration: TextInputConfiguration {
   init() {
      super.init(autocapitalizationType: .sentences)
      sizeConstraint.height = .constant(400)
      inputHeight = 400
      textInsets = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
      inputStyle = TextStyle(size: 24, weight: .xLight)
      placeholderStyle = TextStyle(size: 24, weight: .xLight, color: UIColor(.chalkboard, alpha: 0.5), alignment: .left)
   }
}

class LineConfiguration: LineElementConfiguration {
   init() {
      super.init()
      sizeConstraint.height = .constant(1)
      isConfinedToMargins = false
      color = UIColor(.chalkboard)
   }
}
