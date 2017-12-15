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
   
   init(size: CGFloat, weight: FontWeight, color: UIColor = UIColor(.outerSpace), alignment: NSTextAlignment = .left) {
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
