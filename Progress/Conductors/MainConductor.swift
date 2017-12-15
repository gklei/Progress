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
   fileprivate let _streakConductor = StreakConductor()
   fileprivate let _statsConductor = StatsConductor()
   fileprivate let _profileConductor = ProfileConductor()
   
   fileprivate lazy var _childConductors: [TabConductor] = {
      return [self._streakConductor, self._statsConductor, self._profileConductor]
   }()
   
   override var rootViewController: UIViewController? { return _tabController }
   
   // MARK: - Init
   override init() {
      super.init()
      _childConductors.forEach { $0.show(in: self._tabController, with: UINavigationController(style: .light)) }
      _tabController.tabBar.configureWithProgressUIDefaults()
   }
   
   override func conductorWillShow(in context: UINavigationController) {
      context.setNavigationBarHidden(true, animated: false)
   }
}
