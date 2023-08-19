//
//  ViewController.swift
//  Carbon Tracker
//
//  Created by Sathvik Yechuri on 7/18/23.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import FirebaseFirestore

class ViewController: UIViewController {

    @IBOutlet weak var logo2: UIImageView!
    @IBOutlet weak var moto: UILabel!
    @IBOutlet weak var logoText2: UILabel!
    @IBOutlet weak var logoDivider: UIImageView!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var googleLogo: UIImageView!
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    
    let database = Firestore.firestore()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 25
        getStartedButton.layer.masksToBounds = true
        googleButton.layer.cornerRadius = 25
        googleButton.layer.masksToBounds = true
        signInButton.layer.cornerRadius = 25
        signInButton.layer.masksToBounds = true
        logo.isHidden = false
        logoText.isHidden = false
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(defaults.bool(forKey: "launchScreenAnimation"))
        if !defaults.bool(forKey: "launchScreenAnimation") {
            self.logo.alpha = 1.0
            self.logoDivider.alpha = 0.0
            self.getStartedButton.alpha = 0.0
            self.logoText2.alpha = 0.0
            self.logoText2.frame.origin.y += self.view.bounds.height/6
            self.googleLogo.alpha = 0.0
            self.googleButton.alpha = 0.0
            self.signInButton.alpha = 0.0
            self.moto.alpha = 0.0
            self.logo2.alpha = 0.0
            
            UIView.animate(
                withDuration: 0.2,
                delay: 2.0,
                options: .curveEaseInOut,
                animations: {
                    self.logoText.alpha = 0.0
                })
            
            UIView.animate(
                withDuration: 0.7,
                delay: 2.0,
                options: .curveEaseInOut,
                animations: {
                    self.logo.alpha = 0.0
                    self.logoText.frame.origin.y -= self.view.bounds.height/4
                    self.logoText2.frame.origin.y -= self.view.bounds.height/6
                    self.logoText2.alpha = 1.0
                },
                completion: {_ in
                    UIView.animate(
                        withDuration: 0.7,
                        delay: 0.0,
                        options: .curveEaseInOut,
                        animations: {
                            self.logo2.alpha = 1.0
                            self.moto.alpha = 1.0
                        }, completion: {_ in
                            UIView.animate(
                                withDuration: 0.3,
                                delay: 0.5,
                                options: .curveEaseInOut,
                                animations: {
                                    self.getStartedButton.alpha = 1.0
                                },
                                completion: {_ in
                                    UIView.animate(
                                        withDuration: 0.3,
                                        delay: 0.0,
                                        options: .curveEaseInOut,
                                        animations: {
                                            self.googleLogo.alpha = 1.0
                                            self.googleButton.alpha = 1.0
                                        },
                                        completion: {_ in
                                            UIView.animate(
                                                withDuration: 0.3,
                                                delay: 0.0,
                                                options: .curveEaseInOut,
                                                animations: {
                                                    self.signInButton.alpha = 1.0
                                                })
                                        })
                                })
                        })
                }
            )
            
            UIView.animate(
                withDuration: 0.4,
                delay: 3.0,
                options: .curveEaseInOut,
                animations: {
                    self.logoDivider.alpha = 1.0
                })
            defaults.set(true, forKey: "launchScreenAnimation")
        }
    }
    
    func saveData(email: String, userName: String, uid: String, pwd: String = "password", path: String = "CarbonTrackr/CarbonTrackr-user1") {
        let docRef = database.document(path)
        docRef.setData(["email": email, "userName": userName, "uid": uid, "pwd": pwd])
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
            
            var exists: Bool = false
            
            if let currentUser = Auth.auth().currentUser {
                let uid = currentUser.uid
                let usersCollection = self.database.collection("CarbonTrackr")
                
                // Check if the user with the given UID exists in the database
                usersCollection.whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error checking user existence: \(error.localizedDescription)")
                        // Handle the error, such as showing an alert to the user
                        return
                    }
                    
                    if let documents = snapshot?.documents, !documents.isEmpty {
                        // User exists in the database
                        print("User exists!")
                        exists = true
                        // Perform any actions you want if the user exists, such as navigating to a different screen
                    } else {
                        // User does not exist in the database
                        print("User does not exist.")
                        exists = false
                        // Perform any actions you want if the user does not exist, such as showing a sign-up screen
                    }
                }
            } else {
                // User is not authenticated, they may need to sign in or sign up
                print("User not authenticated.")
            }
            
            Auth.auth().signIn(with: credential) { result, error in
                var displayName: String = ""
                if let ogName = result?.user.displayName {
                    for i in ogName {
                        if i != " " {
                            displayName.append(i)
                        }
                    }
                }
                var email = result?.user.email
                let usersCollection = self.database.collection("CarbonTrackr")
                
                // Check if the user with the given UID exists in the database
                usersCollection.whereField("email", isEqualTo: email!).getDocuments { snapshot, error in
                    if let error = error {
                        print("Error checking user existence: \(error.localizedDescription)")
                        // Handle the error, such as showing an alert to the user
                        return
                    }
                    
                    if let documents = snapshot?.documents, !documents.isEmpty {
                        // User exists in the database
                        
                        // Perform any actions you want if the user exists, such as navigating to a different screen
                    } else {
                        // User does not exist in the database
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "createAcc")
                        self.present(vc!, animated: true)
                        // Perform any actions you want if the user does not exist, such as showing a sign-up screen
                    }
                }
//                self.saveData(email: (result?.user.email)!, userName: displayName, uid: (result?.user.uid)!)
            } // At this point, our user is signed in

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

