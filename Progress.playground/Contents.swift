//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

let name = "E"

let index = name.index(name.startIndex, offsetBy: 1)
let firstPart = name.substring(to: index)
let secondPart = name.substring(from: index)

print(firstPart)
print(secondPart)

