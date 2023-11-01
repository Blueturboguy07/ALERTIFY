//
//  LogInView.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 7/25/23.
//

import UIKit
import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore
import CryptoKit
import MapKit


struct StudentInfo: Codable {
    let birthdate: String
    let campus: String
    let grade: String
    let id: String
    let name: String
    let counselor: String
}

var name: String?
var campus: String?

class LogInView: UIViewController {
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var signInWithGoogleButton: UIButton!
    @IBOutlet weak var invalid1: UILabel!
    @IBOutlet weak var invalid2: UILabel!
    @IBOutlet weak var circularActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loggingIn: UILabel!

    
    let database = Firestore.firestore()
    var accCreated = false
    var phoneList: Array<String>?
    var emailList: Array<String>?
    var createdUser: String?
    var createdPass: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.isHidden = false
        
        logInButton.layer.cornerRadius = 25
        logInButton.layer.masksToBounds = true
        // Do any additional setup after loading the view.
        let currentDate = Date() // Get the current date and time
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH" // Define the desired date format
        let formattedTime = Int(dateFormatter.string(from: currentDate)) // Format the current date as per the specified format
        if formattedTime! < 11 {
            greetingLabel.text = "Good Morning!"
        } else if formattedTime! > 14 {
            greetingLabel.text = "Good Evening!"
        } else {
            greetingLabel.text = "Good Afternoon!"
        }
        
        userNameField.placeholder = "012345"
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "MMDDYYYY"
        
        userNameField.layer.cornerRadius = 10
        userNameField.layer.masksToBounds = true
        userNameField.textColor = UIColor.black
        userNameField.backgroundColor = UIColor.white
        passwordField.layer.cornerRadius = 10
        passwordField.layer.masksToBounds = true
        passwordField.textColor = UIColor.black
        passwordField.backgroundColor = UIColor.white
        
        signInWithGoogleButton.layer.cornerRadius = 20
        signInWithGoogleButton.layer.masksToBounds = true
        
        circularActivityIndicator.isHidden = true
        circularActivityIndicator.startAnimating()
        loggingIn.isHidden = true
        
        if(accCreated) {
            userNameField.text = createdUser
            passwordField.text = createdPass
        }
    }
    
    func startLoading() {
        self.invalid1.isHidden = true
        self.invalid2.isHidden = true
        circularActivityIndicator.isHidden = false
        loggingIn.isHidden = false
        // You can also show the loading view if you haven't already.
    }
    
    func stopLoading() {
        circularActivityIndicator.isHidden = true
        loggingIn.isHidden = true
        // You can also hide or remove the loading view if needed.
    }
    
    
    @IBAction func logInButtonClicked(_ sender: Any) {
        //HAC Student account checker
        startLoading()
        var text = self.userNameField.text!
        let password = self.passwordField.text!
        logIn(text: text, password: password)
    }

    func logIn(text: String?, password: String!) {
        let getStarted = self.storyboard?.instantiateViewController(withIdentifier: "getStartedView") as? GetStartedViewController
        var components = URLComponents()
        components.scheme = "https"
        components.host = "friscoisdhacapi.vercel.app"
        components.path = "/api/info"
        components.queryItems = [
            URLQueryItem(name: "username", value: text!),
            URLQueryItem(name: "password", value: password!)
        ]
        
        if let url = components.url {
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                guard let self = self else { return }
                guard let data = data, error == nil else {
                    //print("Something went wrong")
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.invalid1.isHidden = false
                        self.invalid2.isHidden = false
                        self.createVibrationAnimation()
                        if(self.accCreated) {
                            self.navigationController?.pushViewController(getStarted!, animated: true)
                            getStarted!.error2IsHidden = false
                        }
                    }
                    return
                }
                
                var result: StudentInfo?
                do {
                    result = try JSONDecoder().decode(StudentInfo.self, from: data)
                    name = result!.name
                    campus = result!.campus
                    // All properties are safely unwrapped and not nil
                } catch {
                    //print("Failed to convert because \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.invalid1.isHidden = false
                        self.invalid2.isHidden = false
                        self.createVibrationAnimation()
                        if(self.accCreated) {
                            self.navigationController?.pushViewController(getStarted!, animated: true)
                            getStarted!.error2IsHidden = false
                        }
                    }
                    return
                }
                
                if let student = result {
                    DispatchQueue.main.async {
                        self.invalid1.isHidden = true
                        self.invalid2.isHidden = true
                    }
                    if(defaults.valueExists(forKey: "uidAlertify") && defaults.string(forKey: "uidAlertify")?.count == 12) {
                        uid = defaults.string(forKey: "uidAlertify")!
                    } else {
                        let collectionReference = Firestore.firestore().collection("Alertify") // Replace "YourCollectionName" with the actual name of your collection
                        let query = collectionReference.whereField("userName", isEqualTo: text) // Replace "fieldName" and "desiredValue" with the field name and value you're looking for

                        query.getDocuments { (querySnapshot, error) in
                            if let error = error {
                                print("Error getting documents: \(error)")
                            } else {
                                for document in querySnapshot!.documents {
                                    // Access the document data
                                    let documentData = document.data()
                                    
                                    // Access specific fields
                                    if let fieldValue = documentData["userName"] as? String {
                                        // Do something with the matching document
                                        uid = documentData["uid"] as! String
                                    }
                                }
                            }
                        }
                    }
                    if(accCreated) {
                        setData(userName: text, password: password, contactPhone: phoneList!, contactEmail: emailList!)
                    } else {
                        saveData(userName: text, password: password)
                    }
                    let databasePath = "Alertify/\(uid)"
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeView") as? HomeViewContorller
                    DispatchQueue.main.async {
                        self.navigationController?.pushViewController(vc!, animated: true)
                        self.stopLoading()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.invalid1.isHidden = false
                        self.invalid2.isHidden = false
                        self.createVibrationAnimation()
                        if(self.accCreated) {
                            self.navigationController?.pushViewController(getStarted!, animated: true)
                            getStarted!.error2IsHidden = false
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func setData(userName: String?, password: String?, contactPhone: Array<String>, contactEmail: Array<String>, path: String = "Alertify/\(uid)") {
        let docRef = database.document(path)
        let encoder = JSONEncoder()
//        var user: Int?
//        var pass: Int?
//        if (try? encoder.encode(userName)) != nil {
//            user = userName
//        }
//        if (try? encoder.encode(password)) != nil {
//            pass = password
//        }
        let data: [String: Any] = [
            "userName": userName!,
            "location": GeoPoint(latitude: 0.0, longitude: 0.0),
            "uid": "\(uid)",
            "password": password!,
            "alertNotification": false,
            "contactEmail": contactEmail,
            "contactPhone": contactPhone
        ]
        docRef.setData(data)
    }
    
    func saveData(userName: String?, password: String?, path: String = "Alertify/\(uid)") {
        let docRef = database.document(path)
        let encoder = JSONEncoder()
//        var user: Int?
//        var pass: Int?
//        if (try? encoder.encode(userName)) != nil {
//            user = userName
//        }
//        if (try? encoder.encode(password)) != nil {
//            pass = password
//        }
        let data: [String: Any] = [
            "userName": userName!,
            "location": GeoPoint(latitude: 0.0, longitude: 0.0),
            "uid": "\(uid)",
            "password": password!,
            "alertNotification": false,
        ]
        docRef.updateData(data)
    }
    
    
    
    func generateUserID() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+"
        var userID = ""

        for _ in 0..<12 {
            let randomIndex = Int(arc4random_uniform(UInt32(characters.count)))
            let randomCharacter = characters[characters.index(characters.startIndex, offsetBy: randomIndex)]
            userID.append(randomCharacter)
        }

        return userID
    }
    
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        logInButton.sendActions(for: .touchUpInside)
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func createVibrationAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07 // Duration for each vibration step
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: invalid1.center.x - 5, y: invalid1.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: invalid1.center.x + 5, y: invalid1.center.y))
        invalid1.layer.add(animation, forKey: "position")
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: invalid2.center.x - 5, y: invalid2.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: invalid2.center.x + 5, y: invalid2.center.y))
        invalid2.layer.add(animation, forKey: "position")
    }
}

extension UserDefaults {

    func valueExists(forKey key: String) -> Bool {
        return object(forKey: key) != nil
    }

}



/**  Friebase Accoutn checker
 var allow: Bool = false
 var text = self.userNameField.text
 let password = self.passwordField.text! //encodePassword(self.passwordField.text!)!
 var type: String = ""
 if((text?.contains(".com")) == false) {
 type = "userName"
 } else {
 type = "email"
 }
 let usersCollection = self.database.collection("CarbonTrackr")
 
 // Check if the user with the given UID exists in the database
 usersCollection.whereField("\(type)", isEqualTo: text!).getDocuments { snapshot, error in
 if let error = error {
 print("Error checking user existence: \(error.localizedDescription)")
 // Handle the error, such as showing an alert to the user
 return
 }
 
 if let documents = snapshot?.documents, !documents.isEmpty {
 // User exists in the database
 usersCollection.whereField("pwd", isEqualTo: password).getDocuments { snapshot2, error in
 if let documents = snapshot2?.documents, !documents.isEmpty {
 print("User exists!")
 allow = true
 UIView.animate(
 withDuration: 1,
 delay: 0.0,
 options: .curveEaseInOut,
 animations: {
 self.invalid1.isHidden = true
 self.invalid2.isHidden = true
 })
 let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeView")
 self.navigationController?.pushViewController(vc!, animated: true)
 } else {
 allow = false
 UIView.animate(
 withDuration: 1,
 delay: 0.0,
 options: .curveEaseInOut,
 animations: {
 self.invalid1.isHidden = false
 self.invalid2.isHidden = false
 self.createVibrationAnimation()
 })
 }
 }
 
 
 // Perform any actions you want if the user exists, such as navigating to a different screen
 } else {
 // User does not exist in the database
 print("User does not exist.")
 allow = false
 UIView.animate(
 withDuration: 1,
 delay: 0.0,
 options: .curveEaseInOut,
 animations: {
 self.invalid1.isHidden = false
 self.invalid2.isHidden = false
 self.createVibrationAnimation()
 })
 // Perform any actions you want if the user does not exist, such as showing a sign-up screen
 }
 }
 **/


//    @IBAction func googleButtonPressed(_ sender: Any) {
//        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
//        // Create Google Sign In configuration object.
//        let config = GIDConfiguration(clientID: clientID)
//        GIDSignIn.sharedInstance.configuration = config
//        // Start the sign in flow!
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
//            guard error == nil else {
//                return
//            }
//            guard let user = result?.user,
//                  let idToken = user.idToken?.tokenString
//            else {
//                return
//            }
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
//                                                           accessToken: user.accessToken.tokenString)
//            // ...
//            Auth.auth().signIn(with: credential) { result, error in
//
//            } // At this point, our user is signed in
//
//        }
//    }
    
    //    func encodePassword(_ password: String) -> String? {
    //        // Generate a random salt
    //        var saltData = Data(count: 16)
    //        let _ = saltData.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, 16, $0.baseAddress!) }
    //        // Convert password and salt to Data
    //        guard let passwordData = password.data(using: .utf8) else {
    //            return nil // Failed to convert password to data
    //        }
    //        // Combine the password and salt
    //        let combinedData = passwordData + saltData
    //        // Hash the combined data using SHA-256
    //        let hashedData = SHA256.hash(data: combinedData)
    //        // Convert the hashed data to a hexadecimal string
    //        let hashedPassword = hashedData.compactMap { String(format: "%02x", $0) }.joined()
    //        return hashedPassword
    //    }
