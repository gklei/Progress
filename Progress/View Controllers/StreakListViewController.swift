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
   
   private var _swipeRecognizer: UISwipeGestureRecognizer!
   private var _longPressRecognizer: UILongPressGestureRecognizer!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      _swipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(StreakListViewController._leftSwipeRecognized(sender:)))
      _swipeRecognizer.direction = .left
      _swipeRecognizer.cancelsTouchesInView = false
      view.addGestureRecognizer(_swipeRecognizer)
      
      _longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                          action: #selector(StreakListViewController._longPressRecognized(sender:)))
      _longPressRecognizer.cancelsTouchesInView = false
      view.addGestureRecognizer(_longPressRecognizer)
   }
   
   override func formDidLoad() {
      super.formDidLoad()
      formDelegate = self
   }
   
   override func generateElements() -> [Elemental]? {
      guard let vm = viewModel else { return nil }
      return vm.streakElements
   }
   
   @objc private func _leftSwipeRecognized(sender: UISwipeGestureRecognizer) {
      let location = sender.location(in: view)
      guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
      viewModel?.streakSwipedLeft(at: indexPath)
   }
   
   @objc private func _longPressRecognized(sender: UISwipeGestureRecognizer) {
      let location = sender.location(in: view)
      guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
      viewModel?.streakLongPressed(at: indexPath)
   }
}

extension StreakListViewController: ElementalViewControllerDelegate {
   func elementSelected(_ element: Elemental, in viewController: ElementalViewController) {
      guard let index = self.index(of: element) else { return }
      viewModel?.streakSelected(at: IndexPath(row: index, section: 0))
   }
}

protocol StreakListViewModelDelegate: class {
   func streakSelected(_ streak: Streak, in viewModel: StreakListViewController.ViewModel)
   func streakSwipedLeft(_ streak: Streak, in viewModel: StreakListViewController.ViewModel)
   func streakLongPressed(_ streak: Streak, in viewModel: StreakListViewController.ViewModel)
}

extension StreakListViewController {
   final class ViewModel {
      let streaks: [Streak]
      weak var delegate: StreakListViewModelDelegate?
      
      init(model: [Streak]) {
         self.streaks = model
      }
      
      var streakElements: [Elemental] {
         var elems: [Elemental] = []
         for streak in streaks {
            let label = UILabel()
            label.font = UIFont(26, .xLight)
            label.textColor = UIColor(.outerSpace, alpha: 0.5)
            label.text = streak.name
            label.numberOfLines = 0
            label.sizeToFit(constrainedWidth: UIScreen.main.bounds.width - 40)
            let view = UIView()
            var size = label.frame.size
            size.height += 30
            view.frame = CGRect(origin: .zero, size: size)
            view.addSubview(label)
            label.center = view.center
            elems.append(CustomViewElement(view: view))
         }
         return elems
      }
      
      func streakSelected(at indexPath: IndexPath) {
         guard let streak = _streak(at: indexPath) else { return }
         delegate?.streakSelected(streak, in: self)
      }
      
      func streakSwipedLeft(at indexPath: IndexPath) {
         guard let streak = _streak(at: indexPath) else { return }
         delegate?.streakSwipedLeft(streak, in: self)
      }
      
      func streakLongPressed(at indexPath: IndexPath) {
         guard let streak = _streak(at: indexPath) else { return }
         delegate?.streakLongPressed(streak, in: self)
      }
      
      private func _streak(at indexPath: IndexPath) -> Streak? {
         guard streaks.count > indexPath.row else { return nil }
         return streaks[indexPath.row]
      }
   }
}
