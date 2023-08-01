//
//  LogInView.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 7/25/23.
//

import UIKit
import Foundation
import FirebaseCore
import GoogleSignIn

class LogInView: UIViewController {
    
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var userNameField: UITextField!
    @IBOutlet weak var greetingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logInButton.layer.cornerRadius = 30
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
        
        userNameField.placeholder = "example@gmail.com"
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "password"
        
        userNameField.layer.cornerRadius = 15
        userNameField.layer.masksToBounds = true
        passwordField.layer.cornerRadius = 15
        passwordField.layer.masksToBounds = true
        
    }
    
    
    @IBAction func googleSignIn(_ sender: Any) {
//        GIDSignIn.sharedInstance.signIn(withPresenting: self) { signInResult, error in
//            guard error == nil else { return }
//
//            guard let signInResult = signInResult else { return }
//            let user = signInResult.user
//          }
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let signinConfig = GIDConfiguration(clientID: clientID)
        // Create Google Sign In configuration object.

        GIDSignIn.sharedInstance.configuration = signinConfig
            let scenes = UIApplication.shared.connectedScenes
            let windowScenes = scenes.first as? UIWindowScene
            let window = windowScenes?.windows.first
            guard let rootViewController = window?.rootViewController else { return }

            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
                // ...
        }
        
        
    }
    
    
    // Called when 'return' key pressed
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
        
        // Called when the user clicks on the view outside of the UITextField

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}
