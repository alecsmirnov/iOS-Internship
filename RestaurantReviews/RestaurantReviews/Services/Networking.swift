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

extension Networking {
    struct Location: Decodable {
        var lat: Float
        var lon: Float
    }

    struct Restaurant: Decodable {
        var id: Int
        var name: String
        var description: String
        var address: String
        var location: Location
        var imagePaths: [String]
        var rating: Float
    }

    struct Review: Decodable {
        var restaurantId: Int
        var author: String
        var reviewText: String
        var date: String
    }
}
