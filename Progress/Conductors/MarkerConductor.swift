//
//  MarkerConductor.swift
//  Streaks
//
//  Created by Gregory Klein on 5/18/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit
import Bindable
import Conduction

class MarkerConductor: Conductor, Bindable {
   enum Key: String, IncKVKeyType {
      case activityDetails
   }
   var bindingBlocks: [Key : [((targetObject: AnyObject, rawTargetKey: String)?, Any?) throws -> Bool?]] = [:]
   var keysBeingSet: [Key] = []
   var activityDetails: String = ""
   
   func setOwn(value: inout Any?, for key: MarkerConductor.Key) throws {
      switch key {
      case .activityDetails: activityDetails = value as? String ?? ""
      }
   }
   
   func value(for key: MarkerConductor.Key) -> Any? {
      switch key {
      case .activityDetails: return activityDetails
      }
   }
   
   static var df: DateFormatter {
      let df = DateFormatter()
      df.dateFormat = "E, MMM d"
      return df
   }
   
   fileprivate lazy var _detailsVC: MarkerViewController = {
      let vc = MarkerViewController()
      vc.title = MarkerConductor.df.string(from: self.date)
      vc.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "",
                                                            icon: #imageLiteral(resourceName: "arrow_left"),
                                                            tintColor: UIColor(.chalkboard),
                                                            target: self,
                                                            selector: #selector(Conductor.dismiss))
      
      vc.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "",
                                                             icon: #imageLiteral(resourceName: "more_vertical"),
                                                             tintColor: UIColor(.chalkboard),
                                                             target: self,
                                                             selector: #selector(MarkerConductor._morePressed))
      vc.viewModel = MarkerViewController.ViewModel(model: self)
      return vc
   }()
   
   override var rootViewController: UIViewController? { return _detailsVC }
   
   let dataLayer: ProgressDataLayer
   let activity: Activity
   let marker: Marker?
   let date: Date
   
   init(dataLayer: ProgressDataLayer, activity: Activity, marker: Marker?, date: Date) {
      self.dataLayer = dataLayer
      self.activity = activity
      self.marker = marker
      activityDetails = marker?.descriptionText ?? ""
      self.date = date
      super.init()
   }
   
   override func conductorWillDismiss(from context: UINavigationController) {
      switch marker {
      case .some(let a): a.descriptionText = activityDetails
      case .none:
         guard !activityDetails.isEmpty else { return }
         dataLayer.createMarker(on: date, for: activity, with: activityDetails)
      }
      dataLayer.save()
   }
   
   override func conductorDidShow(in context: UINavigationController) {
      _detailsVC.startEditing()
   }
   
   @objc func _morePressed() {
      let alert = UIAlertController(style: .actionSheet, title: nil)
      alert.addAction(title: "Cancel", color: UIColor(.markerBlue), style: .cancel)
      alert.addAction(image: #imageLiteral(resourceName: "copy"), title: "Copy from previous", color: UIColor(.chalkboard), style: .default) { action in
         guard let lastMarker = self.dataLayer.markerWithText(before: self.date, in: self.activity) else { return }
         self[.activityDetails] = lastMarker.descriptionText
      }
      alert.show(animated: true)
   }
}
