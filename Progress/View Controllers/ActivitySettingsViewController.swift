//
//  ProfileViewController.swift
//  Progress
//
//  Created by Gregory Klein on 12/15/17.
//  Copyright © 2017 Gregory Klein. All rights reserved.
//

import Bindable
import Elemental
import Conduction

class ActivitySettingsViewController: ElementalViewController {
   fileprivate lazy var _colorGridVC: ColorGridViewController = {
      let vc = ColorGridViewController()
      vc.dataSource = self
      vc.delegate = self
      return vc
   }()
   
   var viewModel: ViewModel? {
      didSet {
         setNeedsReload()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      collectionView.contentInsetAdjustmentBehavior = .always
   }
   
   func reloadColorPicker() {
      _colorGridVC.reload()
   }
   
   override func generateElements() -> [Elemental]? {
      let size = ElementalSize(width: .multiplier(1), height: .constant(200))
      let config = ElementalConfiguration(sizeConstraint: size)
      config.isConfinedToMargins = false
      let vcElement = CustomViewControllerElement(viewController: _colorGridVC, configuration: config)
      
      return Element.form([
         .verticalSpace(26),
         .text(configuration: TextConfiguration(size: 24, weight: .light),
               content: "Marker Color"),
         vcElement
      ])
   }
}

extension ActivitySettingsViewController {
   struct State: ConductionState {}
   class ViewModel: ConductionModel<ActivitySettingsConductor.Key, IncEmptyKey, State> {}
}

extension ActivitySettingsViewController: ColorGridViewControllerDataSource {
   var colors: [StreaksColor] {
      return [
         .markerYellow, .markerOrange, .markerIndigo, .markerBlue,
         .markerGreen, .markerRed, .markerViolet, .markerGray
      ]
   }
   
   var markerColor: StreaksColor {
      guard let vm = viewModel else { fatalError() }
      return vm.viewData.forceCast(key: .markerColor)
   }
}

extension ActivitySettingsViewController: ColorGridViewControllerDelegate {
   func colorSelected(_ color: StreaksColor, in viewController: ColorGridViewController) {
      viewModel?.viewData[.markerColor] = color
   }
}
