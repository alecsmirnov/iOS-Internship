//
//  UIImageView+getImage.swift
//  RestaurantReviews
//
//  Created by Admin on 18.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

private let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func getImage(url string: String) {
        if let imageFromCache = imageCache.object(forKey: string as NSString) {
            image = imageFromCache as? UIImage
        }
        else {
            Networking.getData(url: string) { [unowned self] (data) in
                guard let imageToCache = UIImage(data: data) else { return }
                
                imageCache.setObject(imageToCache, forKey: string as NSString)
                
                DispatchQueue.main.async() {
                    self.image = UIImage(data: data)
                }
            }
        }
    }
}
