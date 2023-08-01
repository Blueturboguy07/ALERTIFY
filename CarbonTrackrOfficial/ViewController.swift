//
//  ViewController.swift
//  Carbon Tracker
//
//  Created by Sathvik Yechuri on 7/18/23.
//

import UIKit
import FirebaseCore
import GoogleSignIn

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
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
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

