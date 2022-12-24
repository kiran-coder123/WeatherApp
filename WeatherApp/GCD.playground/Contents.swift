 import UIKit

// different types of serialization
//Serial - user interface

//Concurrent - non user interface tasks

   // High
   // Default
   // Low
   // Global Background




//different ways of handling tasks

//sync
//async


let countToTen = DispatchQueue(label: "count_to_ten")
let countToTwenty = DispatchQueue(label: "count_from_ten_to_twenty")

countToTen.sync {
    for i in 0...10 {
        print(i)
    }
}
countToTwenty.sync {
    for i in 11...20 {
        print(i)
    }
}
 
