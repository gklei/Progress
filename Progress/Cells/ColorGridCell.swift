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
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath, with color: StreaksColor, selected: Bool) -> ColorGridCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! ColorGridCell
      cell.configure(with: color, selected: selected)
      return cell
   }
   
   func configure(with color: StreaksColor, selected: Bool) {
      contentView.backgroundColor = UIColor(color)
   }
}
