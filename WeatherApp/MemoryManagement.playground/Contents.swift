import UIKit
/*
 RULE 1 - A strong referance cycle may be created if two classes refer to each other.

 RULE 2 - A strong referance cycle may be created if you create and use delegates.
 */

/*
 CASE 1 - if the referances are both optional then use the weak keyword
 */

enum NameError: Error {
    case NameWrong
}
let correctName: String = "Steve Harley"

func check(name: String) throws -> Bool {
    if correctName == name {
        return true
    }
    throw NameError.NameWrong
}

var isNameCorrect: Bool = false

do {
    
    isNameCorrect = try check(name: "Steve Harley")
    
} catch {
    print("name is incorrect")
}
print(isNameCorrect)
