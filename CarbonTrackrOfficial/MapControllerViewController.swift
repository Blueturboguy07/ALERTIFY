//
//  MapControllerViewController.swift
//  CarbonTrackrOfficial
//
//  Created by Mann Bellani on 9/16/23.
//

import UIKit
import MapKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class MapControllerViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var map: MKMapView!
    let database = Firestore.firestore()
    var locationManager: CLLocationManager?
    
    let databasePath = "Alertify/\(uid)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        self.navigationController!.navigationBar.isHidden = false;
        self.map.delegate = self
        map.showsUserLocation = true
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        
        let historyPath = "Alertify/alertHistory"
        let historyDocument = database.document(historyPath)
//        
//        
//        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Replace with your desired coordinates
//        annotation.subtitle = ""
//        
//        // Add the annotation to the map view
//        map.addAnnotation(annotation)
        // Do any additional setup after loading the view.
    }
    @IBAction func zoomIn(_ sender: Any) {
        let userLocation = map.userLocation
        let center = userLocation.location!.coordinate
        let NSdistance = 2000.0 //meters
        let EWdistance = 2000.0 //meters
        let region = MKCoordinateRegion(center: center, latitudinalMeters: NSdistance, longitudinalMeters: EWdistance)
        saveData(location: convertToGeoPoint(region: region), path: databasePath)
        map.mapType = .satellite
        map.setRegion(region, animated: true)
    }
    
    func saveData(location: GeoPoint?, path: String) {
        let docRef = database.document(path)
        let data: [String: Any] = [
            "location": location!
        ]
        
        docRef.updateData(data) { (error) in
            if let error = error {
                print("Error updating document: \(error)")
            }
        }
    }
    
    func getAndSetLocations() -> [MKCoordinateRegion] {
        var locations: [MKCoordinateRegion]?
        
        return locations!
    }
    
    func convertToGeoPoint(region: MKCoordinateRegion) -> GeoPoint {
        let center = region.center
        let latitude = center.latitude
        let longitude = center.longitude
        
        let geoPoint = GeoPoint(latitude: latitude, longitude: longitude)
        
        return geoPoint
    }
    
}
