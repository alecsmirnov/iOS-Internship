//
//  MapViewController.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MapKit

enum InitialLocation {
    static let lat: Float = 55.0415
    static let lon: Float = 82.9346
    static let radius: CLLocationDistance = 1000
}

class MapViewController: UIViewController {
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationCenter()
    }

    private func locationCenter() {
        let location = CLLocation(latitude: CLLocationDegrees(InitialLocation.lat),
                                  longitude: CLLocationDegrees(InitialLocation.lon))
        
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: InitialLocation.radius,
                                                  longitudinalMeters: InitialLocation.radius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

