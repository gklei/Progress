//
//  StreakListViewController.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Elemental
import Foundation

class ActivityListViewController: ElementalViewController {
   var viewModel: ViewModel? {
      didSet {
         setNeedsReload()
      }
   }
   
   private var _swipeRecognizer: UISwipeGestureRecognizer!
   private var _longPressRecognizer: UILongPressGestureRecognizer!
   fileprivate let _topPadding: CGFloat = 18
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      _swipeRecognizer = UISwipeGestureRecognizer(target: self,
                                                  action: #selector(ActivityListViewController._leftSwipeRecognized(sender:)))
      _swipeRecognizer.direction = .left
      _swipeRecognizer.cancelsTouchesInView = false
      view.addGestureRecognizer(_swipeRecognizer)
      
      _longPressRecognizer = UILongPressGestureRecognizer(target: self,
                                                          action: #selector(ActivityListViewController._longPressRecognized(sender:)))
      _longPressRecognizer.cancelsTouchesInView = false
      view.addGestureRecognizer(_longPressRecognizer)
   }
   
   override func formDidLoad() {
      super.formDidLoad()
      formDelegate = self
      sidePadding = 20
   }
   
   override func generateElements() -> [Elemental]? {
      guard let vm = viewModel else { return nil }
      var elements: [Elemental] = Element.form([
         .verticalSpace(_topPadding),
      ])
      elements.append(contentsOf: vm.activityElements)
      return elements
   }
   
   @objc private func _leftSwipeRecognized(sender: UISwipeGestureRecognizer) {
      var location = sender.location(in: view)
      location.y += collectionView.contentOffset.y
      guard var indexPath = collectionView.indexPathForItem(at: location) else { return }
      indexPath.row -= 1
      viewModel?.activitySwipedLeft(at: indexPath)
   }
   
   @objc private func _longPressRecognized(sender: UISwipeGestureRecognizer) {
      var location = sender.location(in: view)
      location.y += collectionView.contentOffset.y
      guard var indexPath = collectionView.indexPathForItem(at: location) else { return }
      indexPath.row -= 1
      viewModel?.activityLongPressed(at: indexPath)
   }
}

extension ActivityListViewController: ElementalViewControllerDelegate {
   func elementSelected(_ element: Elemental, in viewController: ElementalViewController) {
      guard let index = self.index(of: element) else { return }
      viewModel?.activitySelected(at: IndexPath(row: index - 1, section: 0))
   }
}

protocol ActivityListViewModelDelegate: class {
   func activitySelected(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel)
   func activitySwipedLeft(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel)
   func activityLongPressed(_ activity: Activity, in viewModel: ActivityListViewController.ViewModel)
}

extension ActivityListViewController {
   final class ViewModel {
      let activities: [Activity]
      weak var delegate: ActivityListViewModelDelegate?
      
      init(model: [Activity]) {
         self.activities = model
      }
      
      var activityElements: [Elemental] {
         var elems: [Elemental] = []
         for activity in activities {
            let label = UILabel()
            let activityColor = StreaksColor(rawValue: activity.markerColorHex!)!
            let hbsa = UIColor(activityColor).hsbaComponents
            let saturatedColor: UIColor
            switch activityColor {
            case .markerGray: saturatedColor = UIColor(.outerSpace, alpha: 0.5)
            default: saturatedColor = UIColor(hue: hbsa.hue,
                                              saturation: 1,
                                              brightness: hbsa.brightness,
                                              alpha: hbsa.alpha)
            }
            
            let firstAttrs: [String : Any] = [
               NSForegroundColorAttributeName : UIColor(.outerSpace, alpha: 0.5),
               NSFontAttributeName : UIFont(26, .light),
            ]
            let secondAttrs: [String : Any] = [
               NSForegroundColorAttributeName : UIColor(.outerSpace, alpha: 0.5),
               NSFontAttributeName : UIFont(26, .xLight),
               ]
            let name = activity.name!
            let index = name.index(name.startIndex, offsetBy: 1)
            let firstPart = name.substring(to: index)
            let secondPart = name.substring(from: index)
            
            let firstAttrString = NSAttributedString(string: firstPart, attributes: firstAttrs)
            let secondAttrString = NSAttributedString(string: secondPart, attributes: secondAttrs)
            let attrString = NSMutableAttributedString(attributedString: firstAttrString)
            attrString.append(secondAttrString)
            
            label.attributedText = attrString
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
      
      func activitySelected(at indexPath: IndexPath) {
         guard let activity = _activity(at: indexPath) else { return }
         delegate?.activitySelected(activity, in: self)
      }
      
      func activitySwipedLeft(at indexPath: IndexPath) {
         guard let activity = _activity(at: indexPath) else { return }
         delegate?.activitySwipedLeft(activity, in: self)
      }
      
      func activityLongPressed(at indexPath: IndexPath) {
         guard let activity = _activity(at: indexPath) else { return }
         delegate?.activityLongPressed(activity, in: self)
      }
      
      private func _activity(at indexPath: IndexPath) -> Activity? {
         guard activities.count > indexPath.row else { return nil }
         return activities[indexPath.row]
      }
   }
}
