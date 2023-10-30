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
    
    @IBOutlet weak var alertsStack: UIStackView!
    @IBOutlet weak var noAlerts: UILabel!
    let databasePath = "Alertify/\(uid)"
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        self.navigationController!.navigationBar.isHidden = false;
        map.showsUserLocation = true
        
        
        let historyPath = "Alertify/alertHistory/alerts"
        let historyCollection = database.collection(historyPath)
        
        historyCollection.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error reading documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let documentData = document.data() // This is a dictionary of field names and their values
                    var label = UILabel()
                    var button = UIButton(type: .infoDark)
                    print("Document data: \(documentData)")
                    if let fieldValue = documentData["information"] as? [Any] {
                        var coordinate: CLLocationCoordinate2D?
                        var time: String?
                        let annotation = MKPointAnnotation()
                        for item in fieldValue {
                            if let geoPoint = item as? GeoPoint {
                                // Handle GeoPoint
                                coordinate = self.convertGeoPointToCLLocationCoordinate(geoPoint: (fieldValue[0] as? GeoPoint)!)
                                label = UILabel()
                                self.getLocationNameFromCoordinates(coordinate!) { locationName in
                                    if let locationName = locationName {
                                        label.text = locationName
                                    }
                                }
                                let horizontalStackView = UIStackView()
                                horizontalStackView.axis = .horizontal
                                label.textColor = UIColor.white
                                label.font = UIFont(name: "ArialRoundedMT", size: 20.0)
                                button = UIButton(type: .infoDark)
                                button.tintColor = UIColor(named: "red")
                                button.coordinate = coordinate
                                button.time = time
                                button.addTarget(self, action: #selector(self.buttonTapped(_:)), for: .touchUpInside)
                                horizontalStackView.addArrangedSubview(label)
                                horizontalStackView.addArrangedSubview(button)
                                self.alertsStack.addArrangedSubview(horizontalStackView)
                                horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
                                NSLayoutConstraint.activate([
                                    horizontalStackView.leadingAnchor.constraint(equalTo: self.alertsStack.leadingAnchor),
                                    horizontalStackView.trailingAnchor.constraint(equalTo: self.alertsStack.trailingAnchor)
                                ])
                                
                               
                            }
                            if let timestamp = item as? Timestamp {
                                // Handle Timestamp
                                let date = timestamp.dateValue()
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "MMMM d, yyyy h:mm a"
                                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                                let dateString = dateFormatter.string(from: date)
                                time = dateString
                                annotation.title = time
                            }
                        }
                        self.noAlerts.removeFromSuperview()
                        annotation.coordinate = coordinate!
                        self.map.addAnnotation(annotation)
                    }
                }
            }
            // Do any additional setup after loading the view.
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        let region = MKCoordinateRegion(center: sender.coordinate!, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.setRegion(region, animated: true)
    }
    
    func getLocationNameFromCoordinates(_ coordinates: CLLocationCoordinate2D, completion: @escaping (String?) -> Void) {
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                completion(nil) // Return nil in case of an error
            }

            if let placemark = placemarks?.first {
                if let name = placemark.name,
                   let locality = placemark.locality,
                   let administrativeArea = placemark.administrativeArea,
                   let country = placemark.country {
                    let locationName = "\(name), \(locality), \(administrativeArea), \(country)"
                    completion(locationName) // Return the location name
                } else {
                    completion(nil) // Location information not available
                }
            } else {
                completion(nil) // No placemarks found
            }
        }
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
    
    func convertGeoPointToCLLocationCoordinate(geoPoint: GeoPoint) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: geoPoint.latitude, longitude: geoPoint.longitude)
    }
    
}

import ObjectiveC

private var AssociatedCoordinateKey: UInt8 = 0
private var AssociatedTimeKey: UInt8 = 0

extension UIButton {
    var coordinate: CLLocationCoordinate2D? {
        get {
            return objc_getAssociatedObject(self, &AssociatedCoordinateKey) as? CLLocationCoordinate2D
        }
        set {
            objc_setAssociatedObject(self, &AssociatedCoordinateKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var time: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedTimeKey) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedTimeKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}
