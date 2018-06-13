//
//  ColorGridCell.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import UIKit

class ColorGridCell: UICollectionViewCell {
   static var reuseID = "ColorGridCell"
   
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: reuseID)
   }
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath, with color: ProgressColor, selected: Bool) -> ColorGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! ColorGridCell
      cell.configure(with: color, selected: selected)
      return cell
   }
   
   func configure(with color: ProgressColor, selected: Bool) {
      contentView.backgroundColor = UIColor(color)
      switch selected {
      case true:
//         contentView.layer.cornerRadius = 16
         contentView.layer.borderWidth = 4
         contentView.layer.borderColor = UIColor(.chalkboard, alpha: 0.1).cgColor
      case false:
         contentView.layer.cornerRadius = 0
         contentView.layer.borderWidth = 0
         contentView.layer.borderColor = UIColor.clear.cgColor
      }
   }
}
