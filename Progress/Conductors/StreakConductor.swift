//
//  StreakConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

protocol StreakConductorDelegate: class {
   func streakConductor(conductor: StreakConductor, didRenameStreak streak: Streak)
}

class StreakConductor: Conductor {
   fileprivate lazy var _streakVC: StreakViewController = {
      let vc = StreakViewController()
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "chevron-left"),
                                                            tintColor: UIColor(.outerSpace),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      vc.dataSource = self
      let vm = StreakViewController.ViewModel()
      vm.delegate = self
      vc.viewModel = vm
      return vc
   }()
   
   let dataLayer: StreaksDataLayer
   let streak: Streak
   let isNew: Bool
   var activity: [Activity] { return dataLayer.fetchedData }
   var feedbackGenerator: UIImpactFeedbackGenerator?
   weak var delegate: StreakConductorDelegate?
   
   fileprivate(set) var detailsConductor: MarkerConductor?
   fileprivate var _isShowingDetails = false
   
   override var rootViewController: UIViewController? { return _streakVC }
   
   init(dataLayer: StreaksDataLayer, streak: Streak, isNew: Bool = false) {
      self.dataLayer = dataLayer
      self.streak = streak
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
      let recognizer = UITapGestureRecognizer(target: self, action: #selector(StreakConductor.editTitle))
      label.isUserInteractionEnabled = true
      label.addGestureRecognizer(recognizer)
      let attribtues = UINavigationBar.titleAttributes(for: .light)
      label.attributedText = NSAttributedString(string: streak.name!, attributes: attribtues)
      _streakVC.navigationItem.titleView = label
   }
   
   func editTitle() {
      var newName: String? = nil
      let alert = UIAlertController(style: .actionSheet, title: nil)
      let config: TextField.Config = { textField in
         textField.becomeFirstResponder()
         textField.textColor = UIColor(.outerSpace)
         textField.placeholder = self.isNew ? self.streak.name : "Edit Streak Name"
         textField.left(image: #imageLiteral(resourceName: " edit-3"), color: UIColor(.outerSpace))
         textField.leftViewPadding = 12
         textField.cornerRadius = 8
         textField.borderColor = UIColor(.outerSpace, alpha: 0.15)
         textField.backgroundColor = nil
         textField.keyboardType = .default
         textField.autocapitalizationType = .words
         textField.returnKeyType = .done
         textField.text = self.isNew ? "" : self.streak.name
         textField.action { textField in
            newName = textField.text
         }
      }
      alert.addOneTextField(configuration: config)
      alert.addAction(title: "OK", style: .cancel) { action in
         guard let text = newName else { return }
         guard !text.isEmpty else { return }
         self.streak.name = text
         self.dataLayer.save()
         self._updateTitleView()
         self.delegate?.streakConductor(conductor: self, didRenameStreak: self.streak)
      }
      alert.show()
   }
   
   override func conductorDidShow(in context: UINavigationController) {
      guard isNew else { return }
      editTitle()
   }
}

extension StreakConductor: StreakViewControllerDelegate {
   func dateSelected(_ date: Date, in: StreakViewController.ViewModel, at indexPath: IndexPath) {
      feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
      
      dataLayer.toggleActivity(at: date, for: streak)
      _streakVC.reload()
   }
   
   func dateLongPressed(_ date: Date, in: StreakViewController.ViewModel, at: IndexPath) {
      guard detailsConductor?.context == nil else { return }
      feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
      feedbackGenerator?.prepare()
      feedbackGenerator?.impactOccurred()
    
      let activity = streak.activity(for: date)
      detailsConductor = MarkerConductor(dataLayer: dataLayer, streak: streak, activity: activity, date: date)
      detailsConductor?.willDismissBlock = {
         self._streakVC.reload()
      }
      show(conductor: detailsConductor)
   }
}

extension StreakConductor: StreakViewControllerDataSource {
   func activity(at date: Date) -> Activity? {
      return streak.activity(for: date)
   }
}
