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

class HomeViewContorller: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var homeButtonBackground: UIButton!
    let database = Firestore.firestore()
    var firstName = name
    var school = campus
    
    
    @IBOutlet weak var schoolImg: UIImageView!
    @IBOutlet weak var userNameDisplay: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = true
        self.homeButtonBackground.tintColor = UIColor.lightGray
        
        let fullName = self.extractFirstAndLastWords(from: self.firstName!)
        self.userNameDisplay.text = fullName.lastWord! + " " + fullName.firstWord! // Do any additional setup after loading the view.
        if((self.school!.range(of: "Liberty")) != nil) {
            self.schoolImg.image = UIImage(named: "Liberty")
        } else if((self.school!.range(of: "Wakeland")) != nil) {
            self.schoolImg.image = UIImage(named: "Wakeland")
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
    }
    
    func extractFirstAndLastWords(from inputString: String) -> (firstWord: String?, lastWord: String?) {
        // Split the input string into an array of words
        let words = inputString.components(separatedBy: CharacterSet.whitespacesAndNewlines).filter { !$0.isEmpty }
        
        // Check if there are any words
        guard !words.isEmpty else {
            return (nil, nil)
        }
        
        // Extract the first and last words
        var firstWord = words.first
        var lastWord = words.last
        
        // Remove the last character from lastWord if it's not empty
        if var first = firstWord, !first.isEmpty {
            first.removeLast()
            firstWord = first
        }
        
        return (firstWord, lastWord)
    }
    
//    @IBAction func alertClicked(_ sender: Any) {
//        UIView.animate(
//            withDuration: 0.1,
//            delay: 0.0,
//            options: .curveEaseInOut,
//            animations: {
//                self.alertButton.frame.origin.y -= 15
//                self.alertButtonBackground.tintColor = UIColor.darkGray
//                self.alertButton.tintColor = UIColor.systemRed
//            },
//            completion: { _ in
//                UIView.animate(
//                    withDuration: 0.05,
//                    delay: 0.1,
//                    options: .curveEaseInOut,
//                    animations: {
//                        self.alertButtonBackground.tintColor = UIColor.lightGray
//                    },
//                    completion: nil)
//            }
//        )
//    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
