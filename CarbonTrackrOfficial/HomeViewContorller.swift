//
//  HomeViewContorller.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 8/16/23.
//

import UIKit
import SwiftUI
import MapKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import MessageUI
import FirebaseDatabase

class HomeViewContorller: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIScrollViewDelegate {
    @IBOutlet weak var homeButtonBackground: UIButton!
    let database = Firestore.firestore()
    var firstName = name
    var school = campus
    
    @IBOutlet weak var map: MKMapView!
    var locationManager: CLLocationManager?
    let databasePath = "Alertify/\(uid)"
    
    @IBOutlet weak var alertButton: UIButton!
    @IBOutlet weak var spotlight: UIView!
    
    @IBOutlet weak var schoolExitImage: UIImageView!
    @IBOutlet weak var schoolImg: UIImageView!
    @IBOutlet weak var userNameDisplay: UILabel!
    
    @IBOutlet weak var alertLogo: UIImageView!
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var call911: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var schoolExitAlertView: UIView!
    @IBOutlet weak var schoolImageWhileAlert: UIImageView!
    @IBOutlet weak var schoolImageScrollView: UIScrollView!
    @IBOutlet weak var callEmergency: UIButton!
    
    let alertBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    let schoolImageBlurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        
        self.navigationController!.navigationBar.isHidden = true
        self.homeButtonBackground.tintColor = UIColor.lightGray
        alertButton.layer.cornerRadius = 77
        alertButton.layer.masksToBounds = true
        
        spotlight.layer.cornerRadius = 80
        spotlight.layer.masksToBounds = true
        
        let gradientLayerLeft = CAGradientLayer()
        let gradientLayerRight = CAGradientLayer()
        let gradientLayerUp = CAGradientLayer()
        let gradientLayerDown = CAGradientLayer()
        gradientLayerLeft.frame = spotlight.bounds
        gradientLayerRight.frame = spotlight.bounds
        gradientLayerUp.frame = spotlight.bounds
        gradientLayerDown.frame = spotlight.bounds
        
        // Define the colors for the gradient
        gradientLayerLeft.colors = [UIColor.white.cgColor, UIColor.clear.cgColor, UIColor(named: "backgroundColor")?.cgColor]
        gradientLayerRight.colors = [UIColor.white.cgColor, UIColor.clear.cgColor, UIColor(named: "backgroundColor")?.cgColor]
        gradientLayerUp.colors = [UIColor.white.cgColor, UIColor.clear.cgColor, UIColor(named: "backgroundColor")?.cgColor]
        gradientLayerDown.colors = [UIColor.white.cgColor, UIColor.clear.cgColor, UIColor(named: "backgroundColor")?.cgColor]
        
        
        // Define the locations for the colors
        gradientLayerDown.locations = [0.0, 0.5, 1.0]
        gradientLayerRight.locations = [0.0, 0.5, 1.0]
        gradientLayerUp.locations = [0.0, 0.5, 1.0]
        gradientLayerLeft.locations = [0.0, 0.5, 1.0]
        
        // Set the start and end points to create a circular gradient
        gradientLayerDown.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayerDown.endPoint = CGPoint(x: 0.5, y: 1.0)
        
        gradientLayerRight.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayerRight.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        gradientLayerUp.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayerUp.endPoint = CGPoint(x: 0.0, y: 0.0)
        //
        gradientLayerLeft.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradientLayerLeft.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        // Add the gradient layer to the view's layer
        spotlight.layer.insertSublayer(gradientLayerDown, at: 0)
        spotlight.layer.insertSublayer(gradientLayerRight, at: 1)
        spotlight.layer.insertSublayer(gradientLayerUp, at: 2)
        spotlight.layer.insertSublayer(gradientLayerLeft, at: 0)
        
        schoolExitAlertView.layer.cornerRadius = 40
        
        let fullName = self.extractFirstAndLastWords(from: self.firstName!)
        self.userNameDisplay.text = fullName.lastWord! + " " + fullName.firstWord! // Do any additional setup after loading the view.
        if((self.school!.range(of: "Liberty")) != nil) {
            self.schoolImg.image = UIImage(named: "Liberty")
            schoolExitImage.image = UIImage(named: "LibertyExits")
            schoolImageWhileAlert.image = UIImage(named: "LibertyZoomExits")
        } else if((self.school!.range(of: "Wakeland")) != nil) {
            self.schoolImg.image = UIImage(named: "Wakeland")
            schoolExitImage.image = UIImage(named: "WakelandZoomExits")
            schoolImageWhileAlert.image = UIImage(named: "WakelandExits")
        } else if((self.school!.range(of: "Cent")) != nil) {
            self.schoolImg.image = UIImage(named: "Centennial")
        } else if((self.school!.range(of: "Emerson")) != nil) {
            self.schoolImg.image = UIImage(named: "Emerson")
        } else if((self.school!.range(of: "Frisco")) != nil) {
            self.schoolImg.image = UIImage(named: "FriscoHS")
        } else if((self.school!.range(of: "Heritage")) != nil) {
            self.schoolImg.image = UIImage(named: "Heritage")
        } else if((self.school!.range(of: "Independence")) != nil) {
            self.schoolImg.image = UIImage(named: "Independence")
        } else if((self.school!.range(of: "Lebanon")) != nil) {
            self.schoolImg.image = UIImage(named: "LebenonTrail")
        } else if((self.school!.range(of: "Lone")) != nil) {
            self.schoolImg.image = UIImage(named: "LoneStar")
        } else if((self.school!.range(of: "Memorial")) != nil) {
            self.schoolImg.image = UIImage(named: "Memorial")
        } else if((self.school!.range(of: "Panther")) != nil) {
            self.schoolImg.image = UIImage(named: "PantherCreek")
        } else if((self.school!.range(of: "Reedy")) != nil) {
            self.schoolImg.image = UIImage(named: "Reedy")
        }// All properties are safely unwrapped and not nil
        
        schoolImageWhileAlert.alpha = 0.0
        
        map.delegate = self
        map.showsUserLocation = true
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()

        alertView.layer.cornerRadius = 20
        self.alertView.isHidden = false
        self.alertView.alpha = 0.0
        alertView.layer.borderColor = UIColor.white.cgColor // Set the border color to red
        alertView.layer.borderWidth = 2.0 // Set the border width
        
        blink()
        
        
    }
    
    func blink() {
        UIView.animate(withDuration: 0.5, // Adjust the duration as needed
                       animations: {
            // Set the alpha to 0 (invisible)
            self.alertLogo.alpha = 0.0
        },
                       completion: { _ in
            UIView.animate(withDuration: 0.5, // Adjust the duration as needed
                           animations: {
                // Set the alpha back to 1 (visible)
                self.alertLogo.alpha = 1.0
            },
                           completion: { _ in
                // Call the blink function again to create a continuous blink effect
                self.blink()
            }
            )
        }
        )
    }
    
    func checkForAlert() -> Bool{
        let ref = Database.database().reference().child("Alertify/currentAlert")
        var alerted: Bool = false
        ref.observeSingleEvent(of: .value) { (snapshot, error) in
            if let error = error {
                print("Error fetching data!")
                return
            }

            if let alert = snapshot.value as? [Any] {
                alerted = (alert as? Bool)!
            }
        }
        return alerted
    }
    
    
    
    @IBOutlet weak var buttonAlreadyPressed: UILabel!
    @IBAction func alertButtonClicked(_ sender: Any) {
        let docRef = database.document("Alertify/currentAlert")
        let docRef2 = database.document("Alertify/\(uid)")
        let data: [String: Any] = [
            "alert": true
        ]
        let data2: [String: Any] = [
            "alertNotification": true
        ]
        docRef.updateData(data)
        docRef2.updateData(data2)
        callEmergency.layer.cornerRadius = 30
        call911.layer.cornerRadius = 30
        self.alertView.isHidden = false
        UIView.animate(
            withDuration: 0.05,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alertBlurView.frame = self.mainView.frame
                self.mainView.addSubview(self.alertBlurView)
            }
        )
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alertView.alpha = 1.0
                self.mainView.bringSubviewToFront(self.alertView)
            }
        )
        saveLocation()
        alertButton.isEnabled = false
        buttonAlreadyPressed.isHidden = false
        
    }
    
    func saveLocation() {
        if let userLocation = map.userLocation.location {
            let center = userLocation.coordinate
            let NSdistance = 2000.0 //meters
            let EWdistance = 2000.0 //meters
            let region = MKCoordinateRegion(center: center, latitudinalMeters: NSdistance, longitudinalMeters: EWdistance)
            saveData(location: MapControllerViewController().convertToGeoPoint(region: region))
            map.mapType = .satellite
            map.setRegion(region, animated: true)
        } else {
            // Handle the case where userLocation.location is nil
            print("User location is not available")
        }
    }


    
    func saveData(location: GeoPoint?, path: String = "Alertify/currentAlert") {
        // Reference to the current document
        let currentDocument = database.document(path)
        
        let currentDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let historyPath = "Alertify/alertHistory"
        let historyDocument = database.document(historyPath)
        let timestamp = Timestamp(date: currentDate)
        let currentData: [String: Any] = [
            "alert": true,
            "information": [location!, timestamp]
        ]
        
        let historyData: [String: Any] = [
            "alert": true,
            "information": [location!, timestamp]
        ]
        
        // Use a background queue for Firestore stuff
        DispatchQueue.global().async {
            currentDocument.setData(currentData) { error in
                if let error = error {
                    print("Error writing data to current document: \(error)")
                } else {
                    print("Data written to current document successfully.")
                }
            }
            let newCollection = historyDocument.collection("\(components.year ?? 0)_\(components.month ?? 0)_\(components.day ?? 0)") // Replace with the desired collection name
            let newDocument = newCollection.addDocument(data: historyData) { error in
                if let error = error {
                    print("Error writing data to the new document: \(error)")
                } else {
                    print("Data written to the new document successfully.")
                }
            }
        }
    }
    
    @IBAction func closeAlert(_ sender: Any) {
        UIView.animate(
            withDuration: 0.05,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alertBlurView.removeFromSuperview()
            }
        )
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.alertView.alpha = 0.0
                self.alertView.isHidden = true
            }
        )
    }
    
    @IBAction func call911(_ sender: Any) {
        phoneCallButtonAction(phoneNumbers: ["911"])
    }
    
    @IBAction func callEmergencyContacts(_ sender: Any) {
        let usersCollection = self.database.collection("Alertify").document("\(uid)")
        var contacts: Array<String> = []
        print("uid: \(uid)")
        // Check if the user with the given UID exists in the database
        usersCollection.getDocument { (document, error) in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                return
            }

            if let document = document, document.exists {
                if let arrayData = document.get("contactPhone") as? [String] {
                    contacts = arrayData
                    print("Contacts: \(contacts)")
                    // Call your function here, passing the 'contacts' array
                    self.phoneCallButtonAction(phoneNumbers: contacts)
                } else {
                    print("Data is not an array of strings.")
                }
            } else {
                print("Document does not exist for UID: \(uid)")
            }
        }
    }
    
    func phoneCallButtonAction(phoneNumbers: [String]) {
        let alertController = UIAlertController(title: "Choose a phone number to call", message: nil, preferredStyle: .actionSheet)
        
        for phoneNumber in phoneNumbers {
            let callAction = UIAlertAction(title: phoneNumber, style: .default) { (action) in
                if let url = URL(string: "tel://" + phoneNumber) {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
            alertController.addAction(callAction)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // On iPad, popover presentation is required
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func schoolMapView(_ sender: Any) {
        self.schoolImageBlurView.frame = self.mainView.frame
        self.mainView.addSubview(self.schoolImageBlurView)
        self.schoolExitAlertView.isHidden = false
        schoolImageScrollView.contentSize = schoolImageWhileAlert.bounds.size
        schoolImageScrollView.delegate = self
        schoolImageScrollView.contentOffset = CGPoint(x:0, y:0)
        schoolImageScrollView.minimumZoomScale = 0.5 //smallest zoom
        schoolImageScrollView.maximumZoomScale = 10.0 //biggest zoom
        schoolImageScrollView.zoomScale = 1.0 //starting zoom
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.schoolExitAlertView.alpha = 1.0
                self.schoolImageBlurView.alpha = 1.0
            }
        )
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.schoolImageWhileAlert.alpha = 1.0
                self.mainView.bringSubviewToFront(self.schoolExitAlertView)
            }
        )
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return schoolImageWhileAlert
    }
    
    @IBAction func closeSchoolMapView(_ sender: Any) {
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            options: .curveEaseInOut,
            animations: {
                self.schoolExitAlertView.alpha = 0.0
                self.schoolImageBlurView.alpha = 0.0
            }
        )
        self.schoolExitAlertView.isHidden = true
        
    }
    
    
    func extractFirstAndLastWords(from inputString: String) -> (firstWord: String?, lastWord: String?) {
        // Split the input string into an array of words
        var words = inputString.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        
        // Check if there are any words
        guard !words.isEmpty else {
            return (nil, nil)
        }
        // Extract the first and last words
        if(words.count == 3) {
            words.removeLast()
        }
        var firstWord = words.first
        var lastWord = words.last
        
        // Remove the last character from lastWord if it's not empty
        if var first = firstWord, !first.isEmpty {
            first.removeLast()
            firstWord = first
        }
        
        return (firstWord, lastWord)
    }
    
    
    
    func sendTextMessage() {
        
    }
    
    
}
