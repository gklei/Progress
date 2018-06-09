//
//  MarkerViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit
import Elemental
import Bindable
import Conduction

class MarkerViewController: ElementalViewController {
   struct State: ConductionState {}
   class ViewModel: ConductionModel<MarkerConductor.Key, IncEmptyKey, State> {}
   var viewModel: ViewModel? {
      didSet {
         setNeedsReload()
      }
   }
   
   fileprivate var _textViewElement: TextViewInputElement?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
   
   override func generateElements() -> [Elemental]? {
      guard let viewModel = viewModel else { return nil }
      _textViewElement = TextViewInputElement(
         configuration: MarkerInputConfiguration(),
         content: TextInputElementContent(name: "", placeholder: "What did you do?"),
         bindings: [viewModel.viewData.targetBinding(key: BindableElementKey.text, targetKey: .activityDetails)]
      )
      return Element.form([
         .verticalSpace(26),
         _textViewElement!,
      ])
   }
   
   func startEditing() {
      _textViewElement?.startEditing()
   }
}
