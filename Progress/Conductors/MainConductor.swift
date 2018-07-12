//
//  MainConductor.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Conduction

class MainConductor: Conductor {
   fileprivate let _tabController = UITabBarController()
   fileprivate let _activityListConductor: ActivityListConductor
   fileprivate var _currentActivityConductor: ActivityConductor?
   fileprivate let _statsConductor: StatsConductor
   fileprivate let _activityComposerConductor: ActivityComposerConductor
   fileprivate var _streaksSettingsConductor: GlobalSettingsConductor
   fileprivate var _activitySettingsConductor: ActivitySettingsConductor?
   
   override var rootViewController: UIViewController? { return _tabController }
   let dataLayer: ProgressDataLayer
   
   // MARK: - Init
   init(dataLayer: ProgressDataLayer) {
      self.dataLayer = dataLayer
      _activityListConductor = ActivityListConductor(dataLayer: dataLayer)
      _statsConductor = StatsConductor(dataLayer: dataLayer)
      _activityComposerConductor = ActivityComposerConductor(dataLayer: dataLayer)
      _streaksSettingsConductor = GlobalSettingsConductor(dataLayer: dataLayer)
      
      super.init()
      _activityListConductor.delegate = self
      _activityListConductor.show(in: _tabController, with: UINavigationController(style: .light))
      _statsConductor.show(in: _tabController, with: UINavigationController(style: .light))
      _streaksSettingsConductor.show(in: _tabController, with: UINavigationController(style: .light))
      
      _tabController.tabBar.configureWithProgressUIDefaults()
   }
   
   override func conductorWillShow(in context: UINavigationController) {
      context.setNavigationBarHidden(true, animated: false)
   }
}

extension MainConductor: ActivityListConductorDelegate {
   func activityConductorWillShow(_ conductor: ActivityConductor, from listConductor: ActivityListConductor) {
      if _activitySettingsConductor?.context != nil {
         _activitySettingsConductor?.dismiss()
      }
      _activitySettingsConductor = ActivitySettingsConductor(dataLayer: dataLayer, activity: conductor.activity)
      _activitySettingsConductor?.delegate = self
      
      _streaksSettingsConductor.dismiss()
      _activitySettingsConductor?.show(in: _tabController, with: UINavigationController(style: .light))
      _currentActivityConductor = conductor
   }
   
   func activityConductorWillDismiss(_ conductor: ActivityConductor, from listConductor: ActivityListConductor) {
      _activitySettingsConductor?.dismiss()
      _streaksSettingsConductor.show(in: _tabController, with: UINavigationController(style: .light))
   }
}

extension MainConductor: ActivitySettingsConductorDelegate {
   func settingChanged(key: ActivitySettingsConductor.Key, in conductor: ActivitySettingsConductor) {
      switch key {
      case .markerColor:
         _currentActivityConductor?.reload()
         _activityListConductor.reload()
      }
   }
}
