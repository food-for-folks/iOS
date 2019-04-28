//
//  ViewControllerMaps.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 3/5/19.
//  Copyright © 2019 Cory L. Rooker. All rights reserved.
//

import UIKit
import MapKit
import Firebase
import CoreLocation

class ViewControllerMaps: UIViewController, CLLocationManagerDelegate {
    //database declarations
    var foodDatabase = [Food]()
    var foodNumber:Int?
    var user:UserData?
    var locationOccur: [String?: Int?] = [:]
    var ref: DatabaseReference!
    
    
    //location declarations
    private let locationManager = CLLocationManager();
    var latitudeLabel:Double?
    var longitudeLabel:Double?
    @IBOutlet weak var MapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: Selector("endEditing:")))
        getData()
        translateAddress()
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func getData() {
        self.ref = Database.database().reference()
        self.ref.child("food").observe(.value) { (snapshot) in
            if(snapshot.value != nil) {
                var titleFood = ""
                var quantity = ""
                var postDate = ""
                var itemImage = ""
                var idNumber = 0
                var itemDes = ""
                var owner  = ""
                var location = ""
                var exp = ""
                var uid = ""
                var postUID = ""
                self.foodDatabase.removeAll()
                for child in snapshot.children {
                    let childSnap = child as! DataSnapshot
                    titleFood = (childSnap.childSnapshot(forPath: "title").value as? String)!
                    quantity = (childSnap.childSnapshot(forPath: "quantity").value as? String)!
                    postDate = (childSnap.childSnapshot(forPath: "postDate").value as? String)!
                    itemImage = (childSnap.childSnapshot(forPath: "image").value as? String)!
                    idNumber = (childSnap.childSnapshot(forPath: "idNumber").value as? Int)!
                    itemDes = (childSnap.childSnapshot(forPath: "description").value as? String)!
                    owner = (childSnap.childSnapshot(forPath: "owner").value as? String)!
                    location = (childSnap.childSnapshot(forPath: "location").value as? String)!
                    exp = (childSnap.childSnapshot(forPath: "expiration").value as? String)!
                    uid = childSnap.key
                    postUID = (childSnap.childSnapshot(forPath: "uid").value as? String)!
                    let newFood = Food(itemTitle: titleFood, itemQuanty: quantity, itemPostDate: postDate, itemImage: itemImage, idNumber: idNumber, itemDescription: itemDes, itemOwner: owner, itemLocation: location, itemExpiration: exp, uid: uid)
                    newFood.postUID = postUID
                    newFood.itemLocation = location
                    self.foodDatabase.append(newFood)
                    let keyExists = self.locationOccur[newFood.itemLocation]
                    if let foodExist = self.locationOccur[newFood.itemLocation], var foodItem = foodExist {
                        foodItem = foodItem + 1;
                        self.locationOccur[newFood.itemLocation] = foodItem
                    }
                    else {
                        self.locationOccur[newFood.itemLocation] = 0
                    }
                    
                }
            }
        }
    }
    
    
    func translateAddress() {
        for (address, count) in locationOccur {
            var geocoder = CLGeocoder()
            var lat: CLLocationDegrees?
            var lon: CLLocationDegrees?
            if let addressItem = address {
                geocoder.geocodeAddressString(addressItem) {
                placemarks, error in
                let placemark = placemarks?.first
                    if let latitude = lat, let longitude = lon {
                        lat = placemark?.location?.coordinate.latitude
                        lon = placemark?.location?.coordinate.longitude
                        print("Lat: \(lat), Lon: \(lon)")
                    }
                }
            }
            let point = MKPointAnnotation()
            if let countOfLocation = count {
                point.title = String(countOfLocation) + " items at this location."
            }
            if let latitude = lat, let longitude = lon {
                point.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                MapView.addAnnotation(point)
            }
        }
    }
}
