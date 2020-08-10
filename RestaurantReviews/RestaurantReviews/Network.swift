//
//  Network.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

typealias CompletionHandler<T: AnyObject> = (T) -> ()

struct LocationJSON: Decodable {
    var lat: Float
    var lon: Float
}

struct RestaurantJSON: Decodable {
    var id: Int
    var name: String
    var description: String
    var address: String
    var location: LocationJSON
    var imagePaths: [String]
    var rating: Float
}

enum Network {
    func getRequest<T: Decodable>(urlString: String, completionHandler: @escaping CompletionHandler<T>) {
        let url = URL(string: urlString)!

        let session = URLSession.shared

        let sessionTask = session.dataTask(with: url) { data, response, error in
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let data = data else {
                return
            }

            guard response != nil else {
                print("Server error!")
                return
            }
            
            do {
                let data = try JSONDecoder().decode(T.self, from: data)
                
                completionHandler(data)
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }

        sessionTask.resume()
    }
}
