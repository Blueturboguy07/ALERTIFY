//
//  ViewController.swift
//  Carbon Tracker
//
//  Created by Sathvik Yechuri on 7/18/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var moto1: UILabel!
    @IBOutlet weak var moto2: UILabel!
    @IBOutlet weak var logoText2: UILabel!
    @IBOutlet weak var logoDivider: UIImageView!
    @IBOutlet weak var logoText: UILabel!
    @IBOutlet weak var getStartedButtonLabel: UILabel!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var getStartedButtonAnimaton: UIButton!
    @IBOutlet weak var logo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getStartedButton.layer.cornerRadius = 30
        getStartedButton.layer.masksToBounds = true
        getStartedButtonAnimaton.layer.cornerRadius = 30
        getStartedButtonAnimaton.layer.masksToBounds = true
        logo.isHidden = false
        logoText.isHidden = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.logo.alpha = 1.0
        self.logoDivider.alpha = 0.0
        self.moto1.alpha = 0.0
        self.moto2.alpha = 0.0
        self.getStartedButton.alpha = 0.0
        self.getStartedButtonLabel.alpha = 0.0
        self.getStartedButtonAnimaton.alpha = 0.0
        self.logoText2.alpha = 0.0
        self.logoText2.frame.origin.y += self.view.bounds.height/4

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
                self.logoText2.frame.origin.y -= self.view.bounds.height/4
                self.logoText2.alpha = 1.0
            },
            completion: {_ in
                UIView.animate(
                    withDuration: 1.5,
                    delay: 0.0,
                    options: .curveEaseInOut,
                    animations: {
                        self.moto1.alpha = 1.0
                        self.moto2.alpha = 1.0
                    }, completion: {_ in
                        UIView.animate(
                            withDuration: 1,
                            delay: 0.0,
                            options: .curveEaseInOut,
                            animations: {
                                self.getStartedButton.alpha = 1.0
                                self.getStartedButtonLabel.alpha = 1.0
                                self.getStartedButtonAnimaton.alpha = 1.0
                            },
                            completion: {_ in
                                UIView.animate(
                                    withDuration: 1,
                                    delay: 0.0,
                                    options: [.curveEaseInOut, .repeat],
                                    animations: {
                                        self.getStartedButtonAnimaton.alpha = 0.0
                                        self.getStartedButtonAnimaton.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                                        //TODO
                                    })
                            })
                    })
            }
        )

        UIView.animate(
            withDuration: 0.3,
            delay: 2.5,
            options: .curveEaseOut,
            animations: {
                self.logoDivider.alpha = 1.0
            }
        )
    }
    
}

