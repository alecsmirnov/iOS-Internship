//
//  Networking.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation
import SystemConfiguration

enum Networking {
    static func getData(url string: String, completionHandler: @escaping (Data) -> ()) -> URLSessionTask? {
        guard let url = URL(string: string) else { return nil }
        
        let session = URLSession.shared
        
        let sessionTask = session.dataTask(with: url) { (data, response, error) in
            if error != nil { return }
            guard let data = data else { return }
            guard response != nil else { return }
            
            completionHandler(data)
        }

        sessionTask.resume()
        
        return sessionTask
    }
    
    static func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }

        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }

        let isReachable = flags == .reachable
        let needsConnection = flags == .connectionRequired

        return isReachable && !needsConnection
    }
}

// Restaurant Data presentation
extension Networking {
    struct Location: Codable {
        let lat: Float
        let lon: Float
    }

    struct Restaurant: Codable {
        let id: Int
        let name: String
        let description: String
        let address: String
        let location: Location
        let imagePaths: [String]
        let rating: Float
    }
}

// Review Data presentation
extension Networking {
    enum ReviewRestaurantId: Codable {
        case int(Int)
        case string(String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let id = try? container.decode(Int.self) {
                self = .int(id)
                return
            }
            
            if let id = try? container.decode(String.self) {
                self = .string(id)
                return
            }
            
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type of RestaurantIdJSON")
            throw DecodingError.typeMismatch(ReviewRestaurantId.self, context)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case .int(let id):
                try container.encode(id)
                break
            case .string(let id):
                try container.encode(id)
                break
            }
        }
    }
    
    enum ReviewDate: Codable {
        case double(Double)
        case string(String)

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let date = try? container.decode(Double.self) {
                self = .double(date)
                return
            }
            
            if let date = try? container.decode(String.self) {
                self = .string(date)
                return
            }
            
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type of DateJSON")
            throw DecodingError.typeMismatch(ReviewDate.self, context)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case .double(let date):
                try container.encode(date)
                break
            case .string(let date):
                try container.encode(date)
                break
            }
        }
    }

    struct Test: Codable {
        let text: String
        
        enum CodingKeys: String, CodingKey {
            case text = "test"
        }
    }

    struct Review: Codable {
        let restaurantId: ReviewRestaurantId?
        let author: String
        let date: ReviewDate?
        let reviewText: String
    }

    enum ReviewRecord: Codable {
        case review(Review)
        case test(Test)
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            
            if let record = try? container.decode(Review.self) {
                self = .review(record)
                return
            }
            
            if let record = try? container.decode(Test.self) {
                self = .test(record)
                return
            }
            
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for ReviewRecordJSON")
            throw DecodingError.typeMismatch(ReviewRecord.self, context)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            
            switch self {
            case .review(let record):
                try container.encode(record)
                break
            case .test(let record):
                try container.encode(record)
                break
            }
        }
    }
}

extension Networking {
    typealias Restaurants   = [Restaurant]
    typealias ReviewRecords = [String: ReviewRecord]
}
