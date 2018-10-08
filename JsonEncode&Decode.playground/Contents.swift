import UIKit

extension JSONEncoder {
    func encodeString<T>(_ value: T, encoding: String.Encoding = .utf8) throws -> String where T : Encodable {
        return String(data: try encode(value), encoding: encoding) ?? ""
    }
}

extension JSONDecoder {
    func decode<T>(_ type: T.Type, from stringValue: String, encoding: String.Encoding = .utf8) throws -> T where T : Decodable {
        let data = stringValue.data(using: encoding) ?? Data()
        return try decode(type, from: data)
    }
}

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
encoder.outputFormatting = .prettyPrinted
let decoder = JSONDecoder()


struct School: Codable {
    var name: String
    var age: Int
}

demo(name: "Basic", execute: true) {
    let s1 = School(name: "Fuzhou University", age: 60)
    // encode
    print(try encoder.encodeString(s1))
    
    // decode
    let json = "{\"name\": \"Peking University\", \"age\": 110 }"
    print(try decoder.decode(School.self, from: json))
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

// Encode enum
demo(name: "Encode enum", execute: true) {
    let stu1 = Student(id: "001", name: "Kobe", gender: .male, age: 21, score: 3.6)
    print(try encoder.encodeString(stu1))
    
    let json = "{\"gender\":1,\"id\":\"003\",\"age\":22,\"score\":4.5,\"name\":\"Jane\"}"
    print(try decoder.decode(Student.self, from: json))
}


struct Man: Codable {
    var name: String
    var age: Int
}

// Encode Optional
demo(name: "Encode Optional", execute: true) {
    let man = Man(name: "Gernet", age: 34)
    print(try encoder.encodeString(man))
    
    let json = "{\"name\":\"Dencan\", \"age\": 44}"
    let decodedMan = try decoder.decode(Man.self, from: json)
    print(decodedMan)
}


// Encode and Decode manually
struct Coordinate {
    var latitude: Double
    var longitude: Double
    var elevation: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case additionalInfo
    }
    
    enum AdditionalInfoKeys: String, CodingKey {
        case elevation
    }
}

extension Coordinate: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
        
        let additionalInfo = try values.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        elevation = try additionalInfo.decode(Double.self, forKey: .elevation)
    }
}

extension Coordinate: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        
        var additionalInfo = container.nestedContainer(keyedBy: AdditionalInfoKeys.self, forKey: .additionalInfo)
        try additionalInfo.encode(elevation, forKey: .elevation)
    }
}

demo(name: "Encode and Decode manually", execute: true) {
    let c1 = Coordinate(latitude: 11.5, longitude: 15.0, elevation: 12.0)
    print(try encoder.encodeString(c1))
    
    let json = "{\"latitude\": 12.3, \"longitude\": 13.25, \"additionalInfo\": { \"elevation\": 12.5 } }"
    print(try decoder.decode(Coordinate.self, from: json))
}


