import UIKit

func demo(name: String = "", execute: Bool = true, _ block: () throws -> Void) {
    if execute {
        print("------\(name) start-------")
        do {
            try block()
        } catch {
            print(error)
        }
        print("------\(name) end-------")
    }
    
}

demo(execute: false) { }

let encoder = JSONEncoder()
let decoder = JSONDecoder()


struct School: Codable {
    var name: String
    var age: Int
}

extension School: CustomStringConvertible {
    var description: String {
        return "School: { name: \(name), age: \(age) }"
    }
}


demo(name: "Basic", execute: true) {
    let s1 = School(name: "Fuzhou University", age: 60)
    // encode
    let s1Data = try encoder.encode(s1)
    if let s1Str = String(data: s1Data, encoding: .utf8) {
        print(s1Str)
    }
    
    // decode
    let jsonStr1 = "{\"name\": \"Peking University\", \"age\": 110 }"
    if let data1 = jsonStr1.data(using: .utf8) {
        let decodedS1 = try decoder.decode(School.self, from: data1)
        print(decodedS1)
    }
}


enum Gender: Int, Codable {
    case male = 0
    case female = 1
    case unknown = 2
}

extension Gender: CustomStringConvertible {
    var description: String {
        switch self {
        case .male: return "male"
        case .female: return "female"
        case .unknown: return "unknown"
        }
    }
}

struct Student: Codable {
    var id: String
    var name: String
    var gender: Gender
    var age: Int
    var score: Float
}

extension Student: CustomStringConvertible {
    var description: String {
        return "Student: { id: \(id), name: \(name), gender: \(gender), age: \(age), score: \(score) }"
    }
}

// Encode enum
demo(name: "Encode enum", execute: true) {
    let stu1 = Student(id: "001", name: "Kobe", gender: .male, age: 21, score: 3.6)
    let stu1Data = try encoder.encode(stu1)
    if let stu1Str = String(data: stu1Data, encoding: .utf8) {
        print(stu1Str)
    }
    
    let jsonStr1 = "{\"gender\":1,\"id\":\"003\",\"age\":22,\"score\":4.5,\"name\":\"Jane\"}"
    if let data1 = jsonStr1.data(using: .utf8) {
        let stu = try decoder.decode(Student.self, from: data1)
        print(stu)
    }
}
