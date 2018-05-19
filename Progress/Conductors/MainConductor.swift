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
   fileprivate let _statsConductor: StatsConductor
   fileprivate let _settingsConductor: ActivitySettingsConductor
   
   fileprivate lazy var _childConductors: [TabConductor] = {
      return [self._activityListConductor, self._statsConductor, self._settingsConductor]
   }()
   
   override var rootViewController: UIViewController? { return _tabController }
   let dataLayer: StreaksDataLayer
   
   // MARK: - Init
   init(dataLayer: StreaksDataLayer) {
      self.dataLayer = dataLayer
      _activityListConductor = ActivityListConductor(dataLayer: dataLayer)
      _statsConductor = StatsConductor(dataLayer: dataLayer)
      _settingsConductor = ActivitySettingsConductor(dataLayer: dataLayer)
      
      super.init()
      _activityListConductor.show(in: _tabController, with: UINavigationController(style: .light))
      _statsConductor.show(in: _tabController, with: UINavigationController(style: .light))
      _settingsConductor.show(in: _tabController, with: UINavigationController(style: .light))
      
      _tabController.tabBar.configureWithProgressUIDefaults()
   }
   
   override func conductorWillShow(in context: UINavigationController) {
      context.setNavigationBarHidden(true, animated: false)
   }
}
