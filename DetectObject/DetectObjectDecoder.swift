//
//  DetectObjectDecoder.swift
//  DetectObject
//
//  Created by Mikhail Shendrikov on 01.10.2024.
//

import UIKit

struct DetectObjectDecoder: Decodable {
    let amazon: ObjectType
    let google: ObjectType
    let eden: ObjectType

    enum CodingKeys: String, CodingKey {
        case amazon
        case google
        case eden = "eden-ai"
    }
    
    init(amazon: ObjectType, google: ObjectType, eden: ObjectType) {
        self.amazon = amazon
        self.google = google
        self.eden = eden
    }
}

struct ObjectType: Decodable {
//    let items:
    let status: String
    let cost: Double
    
    enum CodingKeys: String, CodingKey {
        case status, cost
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try container.decode(String.self, forKey: .status)
        self.cost = try container.decode(Double.self, forKey: .cost)
    }
}
