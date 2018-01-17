//
//  UserProfileViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 15-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class UserProfileViewController: UIViewController {

    // Logs the user out on button press
    // Source: https://www.appcoda.com/firebase-login-signup/
    @IBAction func logOutPressed(_ sender: UIButton) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                // Makes sure the Tab Bar will be hidden, and performs segue
                self.navigationController?.hidesBottomBarWhenPushed = true
                self.performSegue(withIdentifier: "succesfulLogOut", sender: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
