//
//  SettingsViewController.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 9/29/23.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var signOutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.isHidden = false
        signOutButton.layer.cornerRadius = 15
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
