//
//  StreaksDataLayer.swift
//  Streaks
//
//  Created by Gregory Klein on 5/17/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Foundation
import CoreData

extension Streak {
   func marker(for date: Date) -> Marker? {
      return self.marker?.filter { ($0 as! Marker).epoch == date.timeIntervalSince1970 }.first as? Marker
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
   fileprivate(set) var fetchedStreaks: [Streak] = []
   
   init() {
      updateFetchedStreaks()
   }
   
   func updateFetchedStreaks() {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Streak")
      request.returnsObjectsAsFaults = false
      fetchedStreaks = try! context.fetch(request) as! [Streak]
   }
   
   func createNewStreak() -> Streak {
      updateFetchedStreaks()
      let name = _newStreakName()
      let entity = NSEntityDescription.entity(forEntityName: "Streak", in: context)
      let newStreak = NSManagedObject(entity: entity!, insertInto: context)
      
      newStreak.setValue(name, forKey: "name")
      newStreak.setValue(Date(), forKey: "creationDate")
      save()
      
      return newStreak as! Streak
   }
   
   fileprivate func _newStreakName() -> String {
      switch fetchedStreaks.count {
      case 0: return "New Streak with a really long name"
      default: return "New Streak \(fetchedStreaks.count + 1)"
      }
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
   
   func toggleActivity(at date: Date, for streak: Streak) {
      if let marker = streak.marker(for: date) {
         context.delete(marker)
      } else {
         createActivity(at: date, for: streak)
      }
      save()
      updateFetchedStreaks()
   }
   
   @discardableResult func createActivity(at date: Date, for streak: Streak, with description: String = "") -> Marker? {
      guard streak.marker(for: date) == nil else { return nil }
      
      let entity = NSEntityDescription.entity(forEntityName: "Marker", in: context)
      let newActivity = NSManagedObject(entity: entity!, insertInto: context)
      
      newActivity.setValue(date, forKey: "date")
      newActivity.setValue(date.timeIntervalSince1970, forKey: "epoch")
      newActivity.setValue(description, forKey: "descriptionText")
      newActivity.setValue(streak, forKey: "streak")
      return newActivity as? Marker
   }
   
   func delete(streak: Streak) {
      context.delete(streak)
      save()
   }
}
