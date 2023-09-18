//
//  MapControllerViewController.swift
//  CarbonTrackrOfficial
//
//  Created by Mann Bellani on 9/16/23.
//

import UIKit
import MapKit

class MapControllerViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        map.showsUserLocation = true
        map.mapType = .satellite
        // Do any additional setup after loading the view.
    }
    
    @IBAction func zoomIn(_ sender: Any) {
        let userLocation = map.userLocation
        let center = userLocation.location!.coordinate
        let NSdistance = 2000.0 //meters
        let EWdistance = 2000.0 //meters
        let region = MKCoordinateRegion(center: center, latitudinalMeters: NSdistance, longitudinalMeters: EWdistance)
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
    
}
