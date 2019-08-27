import UIKit

@objcMembers
class SomeClass: NSObject {
//    var someProperty: Int
    dynamic var someProperty: Int
    init(someProperty: Int) {
        self.someProperty = someProperty
    }
}


let c = SomeClass(someProperty: 10)
// kvo加上@objc dynamic
// 如果需要old & new value需要增加options，否则都为nil
c.observe(\.someProperty, options: [.old, .new]) { (object, change) in
    print(change.newValue, change.oldValue)
}

c[keyPath: \.someProperty] = 15
c.someProperty = 20
c.someProperty = 30

var compoundValue = (a: 1, b: 2)
compoundValue[keyPath: \.self] = (a: 10, b: 20)
print(compoundValue)



struct SomeStructure {
    var someValue: Int
}

let s = SomeStructure(someValue: 12)
let pathToProperty = \SomeStructure.someValue

let value = s[keyPath: pathToProperty]


struct OuterStructure {
    var outer: SomeStructure
    init(someValue: Int) {
        self.outer = SomeStructure(someValue: someValue)
    }
}

let nested = OuterStructure(someValue: 24)
let nestedKeyPath = \OuterStructure.outer.someValue

let nestedValue = nested[keyPath: nestedKeyPath]



struct UnmutableStructure {
    let value: Int
}

let unmutable = UnmutableStructure(value: 20)
let unmutableValue = unmutable[keyPath: \.value]

class MutableClass {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
    
    func method1() {
        print(#function)
    }
}


let mutableValueObject = MutableClass(value: 10)
let mutableObjectValueProperty = \MutableClass.value
mutableValueObject[keyPath: mutableObjectValueProperty]
mutableValueObject[keyPath: mutableObjectValueProperty] = 30


let greetings = ["hello", "hola", "bonjour", "안녕"]
let myGreeting = greetings[keyPath: \[String].[1]]

var index = 2
let path = \[String].[index]
let fn: ([String]) -> String = { strings in strings[index] }
print(greetings[keyPath: path])
print(fn(greetings))

index += 1
print(greetings[keyPath: path])
print(fn(greetings))


let firstGreeting: String? = greetings.first
print(firstGreeting?.count as Any)
// Prints "Optional(5)"

// Do the same thing using a key path.
let count = greetings[keyPath: \[String].first?.count]
print(count as Any)
// Prints "Optional(5)"


var mutableClassMethodsCount: UInt32 = 0

// 不是@objcMembers获取不到
if let mutableClassMethodsRef = class_copyMethodList(MutableClass.self, &mutableClassMethodsCount) {
    for offset in 0 ..< Int(mutableClassMethodsCount) {
        let method = mutableClassMethodsRef.advanced(by: offset).pointee
        print(method_getName(method))
    }
}


