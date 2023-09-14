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

struct StudentInfo: Codable {
    let birthdate: String
    let campus: String
    let grade: String
    let id: String
    let name: String
    let counselor: String
}

class LogInView: UIViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    @IBOutlet weak var signInWithGoogleButton: UIButton!
    @IBOutlet weak var invalid1: UILabel!
    @IBOutlet weak var invalid2: UILabel!
    @IBOutlet weak var circularActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loggingIn: UILabel!
    
    
    //    let database = Firestore.firestore()
    var student: StudentInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        passwordField.layer.cornerRadius = 10
        passwordField.layer.masksToBounds = true
        
        signInWithGoogleButton.layer.cornerRadius = 20
        signInWithGoogleButton.layer.masksToBounds = true
        
        circularActivityIndicator.isHidden = true
        circularActivityIndicator.startAnimating()
        loggingIn.isHidden = true
        
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
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "friscoisdhacapi.vercel.app"
        components.path = "/api/info"
        components.queryItems = [
            URLQueryItem(name: "username", value: text),
            URLQueryItem(name: "password", value: password)
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
                    }
                    return
                }
                
                var result: StudentInfo?
                do {
                    result = try JSONDecoder().decode(StudentInfo.self, from: data)
                } catch {
                    //print("Failed to convert because \(error.localizedDescription)")
                    DispatchQueue.main.async {
                        self.stopLoading()
                        self.invalid1.isHidden = false
                        self.invalid2.isHidden = false
                        self.createVibrationAnimation()
                    }
                    return
                }
                
                if let _ = result {
                    DispatchQueue.main.async {
                        self.invalid1.isHidden = true
                        self.invalid2.isHidden = true
                    }
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "homeView")
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
                    }
                }
            }
            task.resume()
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
        
    }
    
    
    @IBAction func googleButtonPressed(_ sender: Any) {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            // ...
            Auth.auth().signIn(with: credential) { result, error in
                
            } // At this point, our user is signed in
            
        }
    }
    
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
