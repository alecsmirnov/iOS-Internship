//
//  NetworkService.swift
//  RestaurantReviews
//
//  Created by Admin on 11.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import Foundation

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

struct ReviewJSON: Decodable {
    var restaurantId: Int
    var author: String
    var reviewText: String
    var date: String
}

func getRestaurantsFrom(url string: String, completionHandler: @escaping ([RestaurantJSON]) -> ()) {
    guard let url = URL(string: string) else { return }
    
    let session = URLSession.shared

    let sessionTask = session.dataTask(with: url) { (data, response, error) in
        if error != nil { return }
        guard let data = data else { return }
        guard response != nil else { return }

        do {
            let data = try JSONDecoder().decode([RestaurantJSON].self, from: data)
            
            completionHandler(data)
        } catch {
            fatalError("JSON error: \(error.localizedDescription)")
        }
    }

    sessionTask.resume()
}

func getImageFrom(url string: String, completionHandler: @escaping (Data) -> ()) {
    guard let url = URL(string: string) else { return }
    
    let session = URLSession.shared
    
    let sessionTask = session.dataTask(with: url) { (data, response, error) in
        if error != nil { return }
        guard let data = data else { return }
        guard response != nil else { return }
        
        completionHandler(data)
    }

    sessionTask.resume()
}
