//
//  StatsViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Elemental

class StatsViewController: ElementalViewController {
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      collectionView.contentInsetAdjustmentBehavior = .always
   }
   
   override func generateElements() -> [Elemental]? {
      return Element.form([
         .verticalSpace(26),
         .text(configuration: TextConfiguration(size: 32, weight: .light),
               content: "Stats."),
         ])
   }
}
