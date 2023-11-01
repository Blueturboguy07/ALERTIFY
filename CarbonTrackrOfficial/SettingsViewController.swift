//
//  SettingsViewController.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 9/29/23.
//

import UIKit
import Firebase
import FirebaseAuth

var faceID: Bool = false
var locationAccess: Bool = false

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    @IBOutlet weak var toggleFaceID: UISwitch!
    @IBOutlet weak var toggleLocationAccess: UISwitch!
    
    let database = Firestore.firestore()
    var checkPhone = false
    var checkEmail = false
    
    @IBOutlet weak var addPhone: UIImageView!
    @IBOutlet weak var addEmail: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = false
        signOutButton.layer.cornerRadius = 20
        toggleFaceID.addTarget(self, action: #selector(faceIDValueChange(_:)), for: .valueChanged)
        toggleLocationAccess.addTarget(self, action: #selector(locationValueChange(_:)), for: .valueChanged)
        toggleFaceID.isOn = faceID
        toggleLocationAccess.isOn = locationAccess
        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(addPhoneTapped))
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(addEmailTapped))
        addPhone.addGestureRecognizer(phoneTapGesture)
        addPhone.isUserInteractionEnabled = true
        addEmail.addGestureRecognizer(emailTapGesture)
        addEmail.isUserInteractionEnabled = true
    }
    
    @objc func faceIDValueChange(_ sender:UISwitch!)
    {
        faceID = sender.isOn
    }
    
    @objc func locationValueChange(_ sender:UISwitch!)
    {
        locationAccess = sender.isOn
    }
    
    
    @IBAction func signOutClicked(_ sender: Any) {
        defaults.removeObject(forKey: "uidAlertify")
        studentID = 00000
        uid = "000000"
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        view.addSubview(blurView)
        
        // Add your content on top of the blurred background
        let titleLabel = UILabel()
        titleLabel.text = "Loading..."
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.sizeToFit()
        titleLabel.center = view.center
        view.addSubview(titleLabel)
        UIView.animate(
            withDuration: 0.5,
            delay: 1.0,
            options: .curveEaseInOut,
            animations: {
                blurView.removeFromSuperview()
                titleLabel.removeFromSuperview()
            })
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "startView")
        self.navigationController?.pushViewController(vc!, animated: true)
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
                    emailArray = [inputEmail!]
                    self.checkEmail = true
                } else {
                    emailArray.append(inputEmail!)
                    let emailAdded = UIAlertController(title: "Email added!", message: "", preferredStyle: .alert)
                    emailAdded.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.updateEmail(contactEmail: emailArray)
                    self.present(emailAdded, animated: true, completion:nil)
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
                    phoneList = [inputNumber!]
                    self.checkPhone = true
                } else {
                    phoneList.append(inputNumber!)
                    let phoneAdded = UIAlertController(title: "Phone number added!", message: "", preferredStyle: .alert)
                    phoneAdded.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
                    self.updatePhoneData(contactPhone: phoneList)
                    self.present(phoneAdded, animated: true, completion:nil)
                }
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)

            present(alertController, animated: true, completion:nil)
        }
        
    }
    
    func updatePhoneData(contactPhone: Array<String>, path: String = "Alertify/\(uid)") {
        let docRef = database.document(path)
        let encoder = JSONEncoder()
        let data: [String: Any] = [
            "contactPhone": contactPhone
        ]
        docRef.updateData(data)
    }
    
    func updateEmail(contactEmail: Array<String>, path: String = "Alertify/\(uid)") {
        let docRef = database.document(path)
        let encoder = JSONEncoder()
        let data: [String: Any] = [
            "contactEmail": contactEmail
        ]
        docRef.updateData(data)
    }
    
    

}
