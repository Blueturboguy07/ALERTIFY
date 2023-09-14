//
//  HomeViewContorller.swift
//  CarbonTrackrOfficial
//
//  Created by Sathvik Yechuri on 8/16/23.
//

import UIKit
import SwiftUI

class HomeViewContorller: UIViewController {
    
    
    @IBOutlet weak var homeButtonBackground: UIButton!
    @IBOutlet weak var alertButtonBackground: UIButton!
    @IBOutlet weak var alertButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertButtonBackground.tintColor = UIColor.lightGray
        self.navigationController!.navigationBar.isHidden = false;
        self.homeButtonBackground.tintColor = UIColor.lightGray
        self.alertButton.tintColor = UIColor(named:"red")
        // Do any additional setup after loading the view.
    }
    
    @IBAction func alertClicked(_ sender: Any) {
        UIView.animate(
            withDuration: 0.1,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.alertButton.frame.origin.y -= 15
                self.alertButtonBackground.tintColor = UIColor.darkGray
                self.alertButton.tintColor = UIColor.systemRed
            },
            completion: { _ in
                UIView.animate(
                    withDuration: 0.05,
                    delay: 0.1,
                    options: .curveEaseInOut,
                    animations: {
                        self.alertButtonBackground.tintColor = UIColor.lightGray
                    },
                    completion: nil)
            }
        )
    }
    
    
    @IBAction func recognizeTapGesture(recognizer:UITapGestureRecognizer) {
        let initialScale: CGFloat = 1.0
            let finalScale: CGFloat = 1.05
            
            // Animate the button's scale up
            UIView.animate(
                withDuration: 0.1,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
//                    self.addButton.transform = CGAffineTransform(scaleX: finalScale, y: finalScale)
                },
                completion: { _ in
                    // Animate the button's scale back down
                    UIView.animate(
                        withDuration: 0.1,
                        delay: 0.0,
                        options: .curveEaseInOut,
                        animations: {
//                            self.addButton.transform = CGAffineTransform(scaleX: initialScale, y: initialScale)
                        },
                        completion: nil
                    )
                }
            )
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
