//
//  StreakConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

protocol ActivityConductorDelegate: class {
   func activityConductor(_ conductor: ActivityConductor, didRenameActivity activity: Activity)
   func activityConductorDidShake(_ conductor: ActivityConductor)
}

class ActivityConductor: Conductor {
   fileprivate lazy var _activityVC: ActivityViewController = {
      let vc = ActivityViewController()
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "chevron-left"),
                                                            tintColor: UIColor(.chalkboard),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      vc.dataSource = self
      vc.viewModel.delegate = self
      return vc
   }()
   
   let dataLayer: ProgressDataLayer
   let activity: Activity
   let isNew: Bool
   var feedbackGenerator: UIImpactFeedbackGenerator?
   weak var delegate: ActivityConductorDelegate?
   
   fileprivate let _queue = OperationQueue()
   fileprivate(set) var detailsConductor: MarkerConductor?
   fileprivate var _isShowingDetails = false
   
   override var rootViewController: UIViewController? { return _activityVC }
   
   init(dataLayer: ProgressDataLayer, activity: Activity, isNew: Bool = false) {
      self.dataLayer = dataLayer
      self.activity = activity
      self.isNew = isNew
      super.init()
      _updateTitleView()
   }
   
   fileprivate func _updateTitleView() {
      let label = UILabel()
      let width = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                            height: CGFloat.greatestFiniteMagnitude)).width
      label.frame = CGRect(origin: .zero, size:CGSize(width: width, height: 500))
      let attribtues = UINavigationBar.titleAttributes(for: .light)
      label.attributedText = NSAttributedString(string: activity.name!, attributes: attribtues)
      label.isUserInteractionEnabled = true
      
      let recognizer = UITapGestureRecognizer(target: self, action: #selector(ActivityConductor.editTitle))
      recognizer.cancelsTouchesInView = false
      label.addGestureRecognizer(recognizer)
      
      let longPressRecognizer = UIGestureRecognizer(target: self, action: #selector(ActivityConductor.animateDays))
      longPressRecognizer.cancelsTouchesInView = false
      label.addGestureRecognizer(longPressRecognizer)
      
      _activityVC.navigationItem.titleView = label
   }
   
   override func conductorDidShow(in context: UINavigationController) {
      defer { _activityVC.becomeFirstResponder() }
      guard isNew else { return }
      editTitle()
   }
   
   func editTitle() {
      let renameOp = RenameActivityOperation(dataLayer: dataLayer, activity: activity, style: .actionSheet)
      renameOp.completionBlock = {
         DispatchQueue.main.async {
            self._updateTitleView()
            self.delegate?.activityConductor(self, didRenameActivity: self.activity)
         }
      }
      _queue.addOperation(renameOp)
   }
   
   func hideCalendar() {
      _activityVC.hideCalendar()
   }
   
   func showCalendar() {
      _activityVC.showCalendar()
   }
   
   func animateCalendar(delay: TimeInterval) {
      _activityVC.animateCalendar(duration: 0.4, delay: delay)
   }
   
   func animateDays() {
      _activityVC.animateDays(duration: 3)
   }
   
   func reload() {
      _activityVC.reload()
   }
}

extension ActivityConductor: ActivityViewControllerDelegate {
   func dateDoubleTapped(_ date: Date, in: ActivityViewController.ViewModel, at indexPath: IndexPath) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      dataLayer.toggleActivity(at: date, for: activity)
      dataLayer.save()
      _activityVC.reload()
   }
   
   func dateTapped(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath) {
      guard detailsConductor?.context == nil else { return }
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
    
      let marker = activity.marker(for: date)
      detailsConductor = MarkerConductor(dataLayer: dataLayer, activity: activity, marker: marker, date: date)
      detailsConductor?.willDismissBlock = {
         self._activityVC.reload()
      }
      show(conductor: detailsConductor)
   }
   
   func activityViewControllerDidShake() {
      delegate?.activityConductorDidShake(self)
   }
}

extension ActivityConductor: ActivityViewControllerDataSource {
   func marker(at date: Date) -> Marker? {
      return activity.marker(for: date)
   }
}
