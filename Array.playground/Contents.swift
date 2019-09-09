import UIKit

var strs: [String] = ["a", "b", "c", "d"]
strs.joined(separator: ",")

// map & flatMap

do {
   let array1 = [[1], [2, 3], [4, 5]]
    let result1 = array1.flatMap { $0 }
    print(result1)
    
    let array2 = [1, nil, 2, nil]
    let result2 = array2.compactMap { $0 }
    print(result2)
    
}
