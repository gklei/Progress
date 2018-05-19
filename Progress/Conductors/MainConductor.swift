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
   
   fileprivate var _streaksSettingsConductor: StreaksSettingsConductor
   fileprivate var _activitySettingsConductor: ActivitySettingsConductor?
   
   override var rootViewController: UIViewController? { return _tabController }
   let dataLayer: StreaksDataLayer
   
   // MARK: - Init
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      _activityListConductor = ActivityListConductor(dataLayer: dataLayer)
      _statsConductor = StatsConductor(dataLayer: dataLayer)
      _streaksSettingsConductor = StreaksSettingsConductor(dataLayer: dataLayer)
      
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
      _currentActivityConductor = conductor
      
      _activitySettingsConductor = ActivitySettingsConductor(dataLayer: dataLayer, activity: conductor.activity)
      _activitySettingsConductor?.delegate = self
      
      _streaksSettingsConductor.dismiss()
      _activitySettingsConductor?.show(in: _tabController, with: UINavigationController(style: .light))
   }
   
   func activityConductorWillDismiss(_ conductor: ActivityConductor, from listConductor: ActivityListConductor) {
      _activitySettingsConductor?.dismiss()
      _streaksSettingsConductor.show(in: _tabController, with: UINavigationController(style: .light))
   }
}

extension MainConductor: ActivitySettingsConductorDelegate {
   func settingChanged(key: ActivitySettingsConductor.Key, in conductor: ActivitySettingsConductor) {
      switch key {
      case .markerColor: _currentActivityConductor?.reload()
      }
   }
}
