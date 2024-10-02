//
//  DetectObjectDecoder.swift
//  DetectObject
//
//  Created by Mikhail Shendrikov on 01.10.2024.
//

import UIKit

struct TargetBody: Decodable {
    let amazon: Provider
    let google: Provider
    let eden: Provider

    enum CodingKeys: String, CodingKey {
        case amazon
        case google
        case eden = "eden-ai"
    }
    
    init(amazon: Provider, google: Provider, eden: Provider) {
        self.amazon = amazon
        self.google = google
        self.eden = eden
    }
    
    struct Provider: Decodable {
        let items: [Item]
        let status: String
        let cost: Double
        
        enum CodingKeys: String, CodingKey {
            case status, cost, items
        }
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.items = try container.decode([Item].self, forKey: .items)
            self.status = try container.decode(String.self, forKey: .status)
            self.cost = try container.decode(Double.self, forKey: .cost)
        }
        
        struct Item: Decodable {
            let label: String
            let confidence: Double
            let xMin: Double?
            let minY: Double?
            let maxX: Double?
            let maxY: Double?

            
            enum CodingKeys: String, CodingKey {
                case label
                case confidence
                case xMin = "x_min"
                case minY = "y_min"
                case maxX = "x_max"
                case maxY = "y_max"
            }
            
            init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.label = try container.decode(String.self, forKey: CodingKeys.label)
                self.confidence = try container.decode(Double.self, forKey: CodingKeys.confidence)
                self.xMin = try container.decode(Double?.self, forKey: CodingKeys.xMin)
                self.minY = try container.decode(Double?.self, forKey: CodingKeys.minY)
                self.maxX = try container.decode(Double?.self, forKey: CodingKeys.maxX)
                self.maxY = try container.decode(Double?.self, forKey: CodingKeys.maxY)
            }
        }
    }
}



