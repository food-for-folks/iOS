//
//  ViewControllerMaps.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import MapKit

class ViewControllerMaps: UIViewController, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager();
    var latitudeLabel:Double?
    var longitudeLabel:Double?
    @IBOutlet weak var MapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
            // Request when-in-use authorization initially
                locationManager.requestWhenInUseAuthorization()
                super.viewDidLoad()
                break
            
            case .restricted, .denied:
                // Disable location features
                return
            
            case .authorizedWhenInUse, .authorizedAlways:
            // Enable location features
                locationManager.requestLocation()
                break
        }
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("Found user's location: \(location.coordinate.latitude)")
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            // 2
            let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            let region = MKCoordinateRegion(center: location, span: span)
            MapView.setRegion(region, animated: true)
            
            //3
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            
            MapView.addAnnotation(annotation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
            locationManager.requestLocation()
        }
    }
}
