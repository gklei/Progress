//
//  StreakConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

protocol ActivityConductorDelegate: class {
   func activityConductor(conductor: ActivityConductor, didRenameActivity activity: Activity)
}

class ActivityConductor: Conductor {
   fileprivate lazy var _activityVC: ActivityViewController = {
      let vc = ActivityViewController()
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "chevron-left"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      vc.dataSource = self
      let vm = ActivityViewController.ViewModel()
      vm.delegate = self
      vc.viewModel = vm
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   let activity: Activity
   let isNew: Bool
   var marker: [Marker] { return dataLayer.fetchedData }
   var feedbackGenerator: UIImpactFeedbackGenerator?
   weak var delegate: ActivityConductorDelegate?
   
   fileprivate(set) var detailsConductor: MarkerConductor?
   fileprivate var _isShowingDetails = false
   
   override var rootViewController: UIViewController? { return _activityVC }
   
   init(dataLayer: StreaksDataLayer, activity: Activity, isNew: Bool = false) {
      self.dataLayer = dataLayer
      self.activity = activity
      self.isNew = isNew
      super.init()
      _updateTitleView()
   }
   
   @objc private func _menuSelected() {
   }
   
   fileprivate func _updateTitleView() {
      let label = UILabel()
      let width = label.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                            height: CGFloat.greatestFiniteMagnitude)).width
      label.frame = CGRect(origin: .zero, size:CGSize(width: width, height: 500))
      let recognizer = UITapGestureRecognizer(target: self, action: #selector(ActivityConductor.editTitle))
      label.isUserInteractionEnabled = true
      label.addGestureRecognizer(recognizer)
      let attribtues = UINavigationBar.titleAttributes(for: .light)
      label.attributedText = NSAttributedString(string: activity.name!, attributes: attribtues)
      _activityVC.navigationItem.titleView = label
   }
   
   func editTitle() {
      var newName: String? = nil
      let alert = UIAlertController(style: .actionSheet, title: nil)
      let config: TextField.Config = { textField in
         textField.becomeFirstResponder()
         textField.textColor = UIColor(.outerSpace)
         textField.placeholder = self.isNew ? self.activity.name : "Edit Activity Name"
         textField.left(image: #imageLiteral(resourceName: " edit-3"), color: UIColor(.outerSpace))
         textField.leftViewPadding = 12
         textField.cornerRadius = 8
         textField.borderColor = UIColor(.outerSpace, alpha: 0.15)
         textField.backgroundColor = nil
         textField.keyboardType = .default
         textField.autocapitalizationType = .words
         textField.returnKeyType = .done
         textField.text = self.isNew ? "" : self.activity.name
         textField.action { textField in
            newName = textField.text
         }
      }
      alert.addOneTextField(configuration: config)
      alert.addAction(title: "OK", style: .cancel) { action in
         guard let text = newName else { return }
         guard !text.isEmpty else { return }
         self.activity.name = text
         self.dataLayer.save()
         self._updateTitleView()
         self.delegate?.activityConductor(conductor: self, didRenameActivity: self.activity)
      }
      alert.show()
   }
   
   override func conductorDidShow(in context: UINavigationController) {
      guard isNew else { return }
      editTitle()
   }
}

extension ActivityConductor: ActivityViewControllerDelegate {
   func dateSelected(_ date: Date, in: ActivityViewController.ViewModel, at indexPath: IndexPath) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      dataLayer.toggleActivity(at: date, for: activity)
      _activityVC.reload()
   }
   
   func dateLongPressed(_ date: Date, in: ActivityViewController.ViewModel, at: IndexPath) {
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
}

extension ActivityConductor: ActivityViewControllerDataSource {
   func marker(at date: Date) -> Marker? {
      return activity.marker(for: date)
   }
}
