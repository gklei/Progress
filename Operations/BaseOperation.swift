//
//  BaseOperation.swift
//  Streaks
//
//  Created by Gregory Klein on 5/19/18.
//  Copyright © 2018 Gregory Klein. All rights reserved.
//

import Foundation

class BaseOperation: Operation {
   // MARK: - Public Properties
   var showDebugOutput = false
   
   // MARK: - Private Properties
   fileprivate var _executing = false {
      willSet { willChangeValue(forKey: "isExecuting") }
      didSet { didChangeValue(forKey: "isExecuting") }
   }
   
   fileprivate var _finished = false {
      willSet { willChangeValue(forKey: "isFinished") }
      didSet { didChangeValue(forKey: "isFinished") }
   }
   
   // MARK: - Overridden
   override var isAsynchronous: Bool { return true }
   override var isExecuting: Bool { return _executing }
   override var isFinished: Bool { return _finished }
   
   override func start() {
      if showDebugOutput {
         print("--- START : \(type(of: self)) ---")
      }
      _executing = true
      execute()
   }
   
   // MARK: - Public
   func finish() {
      if showDebugOutput {
         print("--- FINISH : \(type(of: self)) ---")
      }
      _executing = false
      _finished = true
   }
   
   func execute() {
      fatalError("Must override!")
   }
}
