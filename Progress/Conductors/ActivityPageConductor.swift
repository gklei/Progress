//
//  ActivityPageConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Conduction
import Elemental

protocol ActivityPageConductorDelegate: class {
   func activityPageConductor(_ conductor: ActivityPageConductor, didChangeFocusedConductor focusedConductor: ActivityConductor)
}

class ActivityPageConductor: Conductor {
   fileprivate lazy var _activityPageVC: ElementalPageViewController = {
      let vc = ElementalPageViewController(viewControllers: self.activityConductors.flatMap { $0.rootViewController })
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "chevron-left"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(ActivityPageConductor.dismiss))
      vc.view.backgroundColor = .white
      vc.showsPageIndicator = false
      vc.elementalDelegate = self
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   let activities: [Activity]
   var activityConductors: [ActivityConductor]
   
   fileprivate(set) var focusedActivity: Activity
   var focusedConductor: ActivityConductor {
      return activityConductors.filter { $0.activity == focusedActivity }.first!
   }
   
   weak var delegate: ActivityPageConductorDelegate?
   weak var activiesConductorDelegate: ActivityConductorDelegate? {
      didSet {
         activityConductors.forEach { $0.delegate = activiesConductorDelegate }
      }
   }

   fileprivate(set) var detailsConductor: MarkerConductor?
   var feedbackGenerator: UIImpactFeedbackGenerator?
   
   override var rootViewController: UIViewController? { return _activityPageVC }
   
   init(dataLayer: StreaksDataLayer, activities: [Activity], focusedActivity: Activity) {
      self.dataLayer = dataLayer
      self.activities = activities
      self.focusedActivity = focusedActivity
      activityConductors = activities.map { ActivityConductor(dataLayer: dataLayer, activity: $0) }
      super.init()
      
      activityConductors.forEach { ($0.rootViewController as? ActivityViewController)?.viewModel.delegate = self }
      guard let index = activities.index(of: focusedActivity) else { fatalError() }
      _activityPageVC.navigate(to: index)
      _updateTitleView()
   }
   
   fileprivate func _updateTitleView() {
      let label = UILabel()
      let width = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                            height: CGFloat.greatestFiniteMagnitude)).width
      label.frame = CGRect(origin: .zero, size:CGSize(width: width, height: 500))
      let recognizer = UITapGestureRecognizer(target: focusedConductor, action: #selector(ActivityConductor.editTitle))
      label.isUserInteractionEnabled = true
      label.addGestureRecognizer(recognizer)
      let attribtues = UINavigationBar.titleAttributes(for: .light)
      label.attributedText = NSAttributedString(string: focusedActivity.name!, attributes: attribtues)
      _activityPageVC.navigationItem.titleView = label
   }
   
   func reload() {
      _updateTitleView()
   }
}

extension ActivityPageConductor: ActivityViewControllerDelegate {
   func dateSelected(_ date: Date, in: ActivityViewController.ViewModel, at indexPath: IndexPath) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      dataLayer.toggleActivity(at: date, for: focusedActivity)
      focusedConductor.reload()
   }
   
   func dateLongPressed(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath) {
      guard detailsConductor?.context == nil else { return }
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      let marker = focusedActivity.marker(for: date)
      detailsConductor = MarkerConductor(dataLayer: dataLayer, activity: focusedActivity, marker: marker, date: date)
      detailsConductor?.willDismissBlock = {
         self.focusedConductor.reload()
      }
      show(conductor: detailsConductor)
   }
}

extension ActivityPageConductor: ActivityViewControllerDataSource {
   func marker(at date: Date) -> Marker? {
      return focusedActivity.marker(for: date)
   }
}

extension ActivityPageConductor: ElementalPageViewControllerDelegate {
   func elementalPageTransitionCompleted(index: Int, destinationIndex: Int, in viewController: ElementalPageViewController) {
      focusedActivity = activities[index]
      _updateTitleView()
      delegate?.activityPageConductor(self, didChangeFocusedConductor: focusedConductor)
   }
}
