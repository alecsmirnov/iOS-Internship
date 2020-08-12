//
//  MapViewController.swift
//  RestaurantReviews
//
//  Created by Admin on 10.08.2020.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

private enum LocationSettings {
    static let defaultLat = 55.0415
    static let defaultLon = 82.9346
    
    static let regionMeters: CLLocationDistance = 5000
}

class MapViewController: UIViewController {
    var mapViewModel: MapViewModel!
    
    private let locationManager = CLLocationManager()
    
    @IBOutlet private var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        let annotation = MKPointAnnotation()
        annotation.title = "Test title"
        annotation.subtitle = "shoop da whoop"
        annotation.coordinate = CLLocationCoordinate2D(latitude: LocationSettings.defaultLat, longitude: LocationSettings.defaultLon)
        
        mapView.addAnnotation(annotation)
        
        if CLLocationManager.locationServicesEnabled() {
            //locationManager.delegate = self
            
            //locationManager.desiredAccuracy = kCLLocationAccuracyBest
            //locationManager.startUpdatingLocation()
            
            //centerViewOnUserLocation()
            centerViewOnDefaultLocation()
        }
        else {
            showAlertMessage()
        }
    }
    private func centerViewOnUserLocation() {
        if let location = locationManager.location {
            let region = MKCoordinateRegion(center: location.coordinate,
                                            latitudinalMeters: LocationSettings.regionMeters,
                                            longitudinalMeters: LocationSettings.regionMeters)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    private func centerViewOnDefaultLocation() {
        let location = CLLocation(latitude: LocationSettings.defaultLat, longitude: LocationSettings.defaultLon)
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: LocationSettings.regionMeters,
                                        longitudinalMeters: LocationSettings.regionMeters)
        
        mapView.setRegion(region, animated: true)
    }
    
    private func showAlertMessage() {
        let alert = UIAlertController(title: "Location services are disabled!", message: "Turn them ON", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))

        self.present(alert, animated: true)
    }
}

extension MapViewController: MKMapViewDelegate {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        
//    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
    }
}

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let coorinates = lastLocation.coordinate
            let center = CLLocationCoordinate2D(latitude: coorinates.latitude, longitude: coorinates.longitude)
            let region = MKCoordinateRegion(center: center,
                                            latitudinalMeters: LocationSettings.regionMeters,
                                            longitudinalMeters: LocationSettings.regionMeters)
            
            mapView.setRegion(region, animated: true)
        }
    }
}
