//
//  MapsViewController.swift
//  FoodForFolks
//
//  Created by Cory L. Rooker on 4/2/19.
//  Copyright © 2019 Cory Rooker, Thomas Obarowski, Weston Harmon, Yuliya Pinchuk, Zeenat Sabakada. All rights reserved.
//
import UIKit
import MapKit
import Firebase
import CoreLocation

class MapsViewController: UIViewController, CLLocationManagerDelegate {
    //database declarations
    var foodDatabase = [Food]()
    var foodNumber:Int?
    var user:UserData?
    var locationOccur: [String: Int] = [:]
    var locationCoor: [CoordinateData] = []
    var itemAnnotations: [ItemAnnotation] = []
    
    
    //location declarations
    private let locationManager = CLLocationManager();
    var latitudeLabel:Double?
    var longitudeLabel:Double?
    @IBOutlet weak var MapView: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(foodDatabase[0].itemTitle)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        locationManager.delegate = self
        getAddresses()
        translateAddress()
        MapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
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
            let span = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
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
        if(status == .authorizedWhenInUse){
            locationManager.requestLocation()
        }
    }
    
    
    func getAddresses() {
        for item in self.foodDatabase {
            if self.locationOccur.count == 0 {
                if let itemLocation = item.itemLocation {
                    self.locationOccur[itemLocation] = 1
                }
            }
            else {
                if let itemLocation = item.itemLocation {
                    for (address, _) in self.locationOccur {
                        if address == itemLocation, let itemCount = self.locationOccur[itemLocation] {
                            self.locationOccur[itemLocation] = itemCount + 1;
                        }
                    }
                }
            }
        }
    }
    
    func translateAddress() {
        let geoCoder = CLGeocoder()
        for (address, occurence) in self.locationOccur {
            geoCoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if(error != nil)
                {
                    print("Error", error!)
                }
                    
                else if let placemark = placemarks?[0]
                {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    let itemCoordinateInfo = CoordinateData(point: coordinates,address: address,count: occurence)
                    self.createAnnotations(itemInfo: itemCoordinateInfo)
                }
            })
        }
        
    }
    
    //this function creates annotations using our custom ItemAnnonation class that conforms to MKAnnotations interface
    func createAnnotations(itemInfo: CoordinateData) {
        self.addAnnotations(annotation: (ItemAnnotation(coordinate: itemInfo.point, title: ("\(itemInfo.count) items"), subtitle: ("\(itemInfo.count) items are listed at this location"))))
    }
    
    //this func adds annotations to the mapview
    func addAnnotations(annotation: ItemAnnotation) {
        self.MapView.addAnnotation(annotation)
    }
}
extension MapsViewController: MKMapViewDelegate {
    func mapView(_ MapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let itemAnnotationView = MapView.dequeueReusableAnnotationView(withIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier) as? MKMarkerAnnotationView {
            itemAnnotationView.animatesWhenAdded = true
            itemAnnotationView.titleVisibility = .adaptive
            return itemAnnotationView
        }
        return nil;
    }
}

//This class is used to create our custom annonations
final class ItemAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        super.init()
    }
}
