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
        map.delegate = self
        map.showsUserLocation = true
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
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
    
    @IBAction func changeMapType(_ sender: Any) {
        print("Button clicked") // Check if the button click is being registered
        switch map.mapType {
        case .standard:
            map.mapType = .satellite
            print("Switched to satellite")
        case .hybrid:
            map.mapType = .standard
            print("Switched to standard")
        case .satellite:
            map.mapType = .hybrid
            print("Switched to hybrid")
        default:
            print("Stupid")
        }
    }
    
    func saveData(location: GeoPoint?, path: String) {
        let docRef = database.document(path)
        let data: [String: Any] = [
            "location": location!,
        ]
        docRef.setData(data)
    }
    
    func convertToGeoPoint(region: MKCoordinateRegion) -> GeoPoint {
        let center = region.center
        let latitude = center.latitude
        let longitude = center.longitude
        
        let geoPoint = GeoPoint(latitude: latitude, longitude: longitude)
        
        return geoPoint
    }
    
}
