//
//  ViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/14/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import UIKit
import Elemental

class StreakViewController: ElementalViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
   
   override func generateElements() -> [Elemental]? {
      return Element.form([
         .verticalSpace(26),
         .text(configuration: TextConfiguration(size: 32, weight: .light),
               content: "Streaks."),
      ])
   }
}

