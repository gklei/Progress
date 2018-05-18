//
//  ActivityDetailsViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit
import Elemental

class ActivityDetailsViewController: ElementalViewController {
   let viewModel: ViewModel
   
   init(model: Activity?) {
      viewModel = ViewModel(model: model)
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
   
   override func generateElements() -> [Elemental]? {
      return Element.form([
         .verticalSpace(26),
         .text(configuration: TextConfiguration(size: 32, weight: .light),
               content: viewModel.details ?? "No details"),
      ])
   }
}

extension ActivityDetailsViewController {
   final class ViewModel {
      var details: String?
      var date: NSDate?
      
      init(model: Activity?) {
         details = model?.descriptionText
         date = model?.date
      }
   }
}
