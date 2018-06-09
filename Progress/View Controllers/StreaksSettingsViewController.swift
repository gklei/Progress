//
//  StreaksSettingsViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Elemental

class StreaksSettingsViewController: ElementalViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
   
   override func generateElements() -> [Elemental]? {
      return Element.form([
         .verticalSpace(26),
         .text(configuration: TextConfiguration(size: 80, weight: .light, alignment: .center),
               content: "⚙️"),
      ])
   }
}
