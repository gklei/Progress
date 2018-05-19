//
//  ActivityDetailsViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit
import Elemental
import Bindable
import Conduction

class ActivityDetailsViewController: ElementalViewController {
   struct State: ConductionState {}
   class ViewModel: ConductionModel<ActivityDetailsConductor.Key, IncEmptyKey, State> {}
   var viewModel: ViewModel? {
      didSet {
         setNeedsReload()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
   
   override func generateElements() -> [Elemental]? {
      guard let viewModel = viewModel else { return nil }
      return Element.form([
         .verticalSpace(26),
         .textViewInput(configuration: ActivityDetailsInputConfiguration(),
                        content: TextInputElementContent(name: "", placeholder: "No details."),
                        bindings: [viewModel.viewData.targetBinding(key: BindableElementKey.text, targetKey: .activityDetails)]),
      ])
   }
}
