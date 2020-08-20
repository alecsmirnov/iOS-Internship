//
//  UIImageView+getImage.swift
//  RestaurantReviews
//
//  Created by Admin on 18.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, AnyObject>()
private var sessionTasks: [ObjectIdentifier: URLSessionTask] = [:]

extension UIImageView {
    private var sessionTask: URLSessionTask? {
        get { return sessionTasks[ObjectIdentifier(self)] }
        set { sessionTasks[ObjectIdentifier(self)] = newValue }
    }
    
    func loadImage(url string: String) {
        image = nil
        
        if let imageFromCache = imageCache.object(forKey: string as NSString) {
            image = imageFromCache as? UIImage
        }
        else {
            if Networking.isConnectedToNetwork() {
                sessionTask = Networking.getData(url: string) { [unowned self] (data) in
                    guard let imageToCache = UIImage(data: data) else { return }
                    
                    imageCache.setObject(imageToCache, forKey: string as NSString)
                    
                    DispatchQueue.main.async() {
                        self.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    func stopLoading() {
        if let sessionTask = sessionTask {
            sessionTask.cancel()
        }
    }
}
