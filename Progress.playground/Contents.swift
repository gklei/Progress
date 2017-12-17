//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class Cell: UICollectionViewCell {
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: "Cell")
   }
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath) -> Cell {
      return collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
   }
}

class HeaderCell: UICollectionViewCell {
   static func register(collectionView cv: UICollectionView) {
      cv.register(self, forCellWithReuseIdentifier: "HeaderCell")
   }
   
   static func dequeueCell(with collectionView: UICollectionView, at indexPath: IndexPath) -> Cell {
      return collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderCell", for: indexPath) as! Cell
   }
}

class MyViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   override func loadView() {
      let view = UIView()
      
      let layout = UICollectionViewFlowLayout()
      let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
      cv.dataSource = self
      cv.delegate = self
      Cell.register(collectionView: cv)
      
      cv.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(cv)
      NSLayoutConstraint.activate([
         cv.leadingAnchor.constraint(equalTo: view.leadingAnchor),
         cv.topAnchor.constraint(equalTo: view.topAnchor),
         cv.trailingAnchor.constraint(equalTo: view.trailingAnchor),
         cv.bottomAnchor.constraint(equalTo: view.bottomAnchor)
      ])
      
      self.view = view
   }
   
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 2
   }
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      switch section {
      case 0: return Calendar.current.weekdaySymbols.count
      case 1: return 20
      default: return 0
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = Cell.dequeueCell(with: collectionView, at: indexPath)
      cell.backgroundColor = .red
      return cell
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
      return UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
   }
   
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let size = collectionView.bounds.size.width / CGFloat(Calendar.current.weekdaySymbols.count)
      switch indexPath.section {
      case 0: return CGSize(width: size, height: 20)
      case 1: return CGSize(width: size, height: size)
      default: return .zero
      }
   }
}

let calendar = NSCalendar.current
print(calendar.weekdaySymbols)
print(calendar.shortWeekdaySymbols)
print(calendar.veryShortWeekdaySymbols)

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
