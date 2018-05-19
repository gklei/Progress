//
//  StreakListViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Elemental
import Foundation

class StreakListViewController: ElementalViewController {
   var viewModel: ViewModel? {
      didSet {
         setNeedsReload()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
   }
   
   override func formDidLoad() {
      formDelegate = self
   }
   
   override func generateElements() -> [Elemental]? {
      guard let vm = viewModel else { return nil }
      return vm.streakElements
   }
}

extension StreakListViewController: ElementalViewControllerDelegate {
   func elementSelected(_ element: Elemental, in viewController: ElementalViewController) {
      guard let element = element as? TextElement else { return }
      viewModel?.streakSelected(name: element.content)
   }
}

protocol StreakListViewModelDelegate: class {
   func streakSelected(_ streak: Streak, in: StreakListViewController.ViewModel)
}

extension StreakListViewController {
   final class ViewModel {
      let streaks: [Streak]
      weak var delegate: StreakListViewModelDelegate?
      
      init(model: [Streak]) {
         self.streaks = model
      }
      
      var streakElements: [Elemental] {
         let configuration = TextConfiguration(size: 26, weight: .xLight, alignment: .left)
         var elems: [Elemental] = [
            VerticalSpaceElement(value: 20),
         ]
         for streak in streaks {
            elems.append(TextElement(configuration: configuration, content: streak.name!))
            elems.append(VerticalSpaceElement(value: 20))
         }
         return elems
      }
      
      func streakSelected(name: String) {
         let streak = streaks.filter { $0.name == name }.first
         guard let s = streak else { return }
         delegate?.streakSelected(s, in: self)
      }
   }
}
