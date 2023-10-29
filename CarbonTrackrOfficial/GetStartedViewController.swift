//
//  GetStartedViewController.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 10/13/23.
//

import UIKit
import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore
import CryptoKit
import MapKit


class GetStartedViewController: UIViewController {

    @IBOutlet weak var loadingImg: UIActivityIndicatorView!
    @IBOutlet weak var emailList: UILabel!
    @IBOutlet weak var phoneNumberList: UILabel!
    @IBOutlet weak var phoneStack: UIStackView!
    @IBOutlet weak var emailStack: UIStackView!
    @IBOutlet weak var addPhone: UIImageView!
    @IBOutlet weak var addEmail: UIImageView!
    
    @IBOutlet weak var error2: UILabel!
    
    @IBOutlet weak var loggingIn: UILabel!
    @IBOutlet weak var circularActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    var phoneList = Array<String>()
    var emailArray = Array<String>()
    var checkPhone = false
    var checkEmail = false
    let database = Firestore.firestore()
    var error2IsHidden = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = false
        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoneTapped))
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(addEmailTapped))
        addPhone.addGestureRecognizer(phoneTapGesture)
        addPhone.isUserInteractionEnabled = true
        addEmail.addGestureRecognizer(emailTapGesture)
        addEmail.isUserInteractionEnabled = true
        loadingImg.isHidden = true
        
        if(!error2IsHidden) {
            error2.isHidden = false
            createVibrationAnimation()
        }
        // Do any additional setup after loading the view.
    }
    
    @objc func addEmailTapped() {
        if let imageView = addEmail {
            let alertController = UIAlertController(title: "New Email", message: "Enter a valid email", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                // configure the properties of the text field
                textField.placeholder = "iLoveRadicubs@gmail.com"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                let inputEmail = alertController.textFields![0].text
                let label = UILabel()
                label.textColor = .white
                label.font = UIFont(name: "Helvetica Neue Light Italic", size: 15)
                if(!self.checkEmail) {
                    self.emailList.text = inputEmail
                    self.emailArray = [inputEmail!]
                    self.checkEmail = true
                } else {
                    self.emailArray.append(inputEmail!)
                    label.text = inputEmail
                    self.emailStack.addArrangedSubview(label)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)

            present(alertController, animated: true, completion:nil)
        }
        
    }
    
    @objc func addPhoneTapped() {
        if let imageView = addPhone {
            let alertController = UIAlertController(title: "New Phone", message: "Enter a valid phone number", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                // configure the properties of the text field
                textField.placeholder = "000-000-0000"
                textField.keyboardType = .asciiCapableNumberPad
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
                let inputNumber = alertController.textFields![0].text
                let label = UILabel()
                label.textColor = .white
                label.font = UIFont(name: "Helvetica Neue Light Italic", size: 15)
                if(!self.checkPhone) {
                    self.phoneNumberList.text = inputNumber
                    self.phoneList = [inputNumber!]
                    self.checkPhone = true
                } else {
                    self.phoneList.append(inputNumber!)
                    label.text = inputNumber
                    self.phoneStack.addArrangedSubview(label)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)

            present(alertController, animated: true, completion:nil)
        }
        
    }
    
    
    @IBAction func createAccount(_ sender: Any) {
        error2.isHidden = true
        circularActivityIndicator.isHidden = false
        loggingIn.isHidden = false
        self.startLoading()
        uid = generateUserID()
        defaults.set(uid, forKey: "uidAlertify")
        
        if(!isNumeric(username.text!)) {
            error2.isHidden = false
            circularActivityIndicator.isHidden = true
            loggingIn.isHidden = true
            createVibrationAnimation()
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "logInView") as? LogInView
        vc!.accCreated = true
        vc!.createdUser = username.text!
        vc!.createdPass = password.text!
        vc!.emailList = emailArray
        vc!.phoneList = phoneList
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func isNumeric(_ input: String) -> Bool {
        let characterSet = CharacterSet.decimalDigits.inverted
        return input.rangeOfCharacter(from: characterSet) == nil
    }
    
    func saveData(userName: String?, password: String?, contactPhone: Array<String>, contactEmail: Array<String>, path: String = "Alertify/\(uid)") {
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
    
    func createVibrationAnimation() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07 // Duration for each vibration step
        animation.repeatCount = 3
        animation.autoreverses = true
        
        animation.fromValue = NSValue(cgPoint: CGPoint(x: error2.center.x - 5, y: error2.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: error2.center.x + 5, y: error2.center.y))
        error2.layer.add(animation, forKey: "position")
    }
    
    func startLoading() {
        circularActivityIndicator.isHidden = false
        loggingIn.isHidden = false
        // You can also show the loading view if you haven't already.
    }
    
    func stopLoading() {
        circularActivityIndicator.isHidden = true
        loggingIn.isHidden = true
        // You can also hide or remove the loading view if needed.
    }

    // Called when 'return' key pressed
    func textFieldShouldReturn(_ textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user clicks on the view outside of the UITextField
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
