//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

let calendar = Calendar.current

let daysBack: TimeInterval = 2
let timeIntervalSinceNow: TimeInterval = 60 * 60 * 24 * daysBack
let daysAgo = calendar.startOfDay(for: Date(timeIntervalSinceNow: -timeIntervalSinceNow))
calendar.date(bySetting: .weekday, value: 1, of: daysAgo)

calendar.firstWeekday

