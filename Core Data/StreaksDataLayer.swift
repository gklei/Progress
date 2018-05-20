//
//  StreaksDataLayer.swift
//  Streaks
//
//  Created by Gregory Klein on 5/17/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Foundation
import CoreData

extension Activity {
   func marker(for date: Date) -> Marker? {
      return self.markers?.filter { ($0 as! Marker).epoch == date.timeIntervalSince1970 }.first as? Marker
   }
}

extension Marker {
   var color: StreaksColor {
      return StreaksColor(rawValue: activity!.markerColorHex!)!
   }
}

class StreaksDataLayer {
   // MARK: - Core Data Stack
   private lazy var persistentContainer: NSPersistentContainer = {
      /*
       The persistent container for the application. This implementation
       creates and returns a container, having loaded the store for the
       application to it. This property is optional since there are legitimate
       error conditions that could cause the creation of the store to fail.
       */
      let container = NSPersistentContainer(name: "Streaks")
      container.loadPersistentStores(completionHandler: { (storeDescription, error) in
         if let error = error as NSError? {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            
            /*
             Typical reasons for an error here include:
             * The parent directory does not exist, cannot be created, or disallows writing.
             * The persistent store is not accessible, due to permissions or data protection when the device is locked.
             * The device is out of space.
             * The store could not be migrated to the current model version.
             Check the error message to determine what the actual problem was.
             */
            fatalError("Unresolved error \(error), \(error.userInfo)")
         }
      })
      return container
   }()
   
   private var context: NSManagedObjectContext {
      return persistentContainer.viewContext
   }
   
   fileprivate(set) var fetchedData: [Marker] = []
   fileprivate(set) var fetchedActivities: [Activity] = []
   
   init() {
      updateFetchedActivities()
   }
   
   fileprivate func _newStreakName() -> String {
      switch fetchedActivities.count {
      case 0: return "New Activity"
      default: return "New Activity \(fetchedActivities.count + 1)"
      }
   }
   
   func updateFetchedActivities() {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Activity")
      request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
      request.returnsObjectsAsFaults = false
      fetchedActivities = try! context.fetch(request) as! [Activity]
   }
   
   func createNewActivity() -> Activity {
      updateFetchedActivities()
      let name = _newStreakName()
      let entity = NSEntityDescription.entity(forEntityName: "Activity", in: context)
      let newStreak = NSManagedObject(entity: entity!, insertInto: context)
      
      newStreak.setValue(name, forKey: "name")
      newStreak.setValue(Date(), forKey: "creationDate")
      newStreak.setValue(StreaksColor.markerYellow.rawValue, forKey: "markerColorHex")
      save()
      
      return newStreak as! Activity
   }
   
   // MARK: - Core Data Saving support
   func save() {
      let context = persistentContainer.viewContext
      if context.hasChanges {
         do {
            try context.save()
         } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
         }
      }
   }
   
   func delete(activity: Activity) {
      context.delete(activity)
      save()
   }
   
   func toggleActivity(at date: Date, for activity: Activity) {
      if let marker = activity.marker(for: date) {
         context.delete(marker)
      } else {
         createMarker(at: date, for: activity)
      }
      save()
      updateFetchedActivities()
   }
   
   @discardableResult func createMarker(at date: Date, for activity: Activity, with description: String = "") -> Marker? {
      guard activity.marker(for: date) == nil else { return nil }
      
      let entity = NSEntityDescription.entity(forEntityName: "Marker", in: context)
      let newActivity = NSManagedObject(entity: entity!, insertInto: context)
      
      newActivity.setValue(date, forKey: "date")
      newActivity.setValue(date.timeIntervalSince1970, forKey: "epoch")
      newActivity.setValue(description, forKey: "descriptionText")
      newActivity.setValue(activity, forKey: "activity")
      return newActivity as? Marker
   }
   
   func marker(before date: Date, in activity: Activity) -> Marker? {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Marker")
      request.predicate = NSPredicate(format: "activity == %@ AND date < %@", activity, date as NSDate)
      request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
      request.returnsObjectsAsFaults = false
      let markers = try! context.fetch(request) as! [Marker]
      return markers.last
   }
}
