//
//  UserProfileViewController.swift
//  DingDung
//
//  In the view managed by this controller, a user can log out,
//  and can edit the availability of his/her toilet.
//
//  Created by Stefan Bonestroo on 15-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage

class UserProfileViewController: UIViewController {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var openSwitch: UISwitch!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    
    let storage = Storage.storage()
    let userID = Auth.auth().currentUser?.uid
    let userInfoReference = Database.database().reference().child("users")
    
    var picture: UIImage?
    
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

    // Updates the availability of the toilet in the database
    @IBAction func toiletStatusChanged(_ sender: UISwitch) {
        
        if openSwitch.isOn {
            
            userInfoReference.child(self.userID!)
                .updateChildValues(["toiletStatus": "true"])
        } else {
            
            userInfoReference.child(self.userID!)
                .updateChildValues(["toiletStatus": "false"])
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        updateUserInfo()
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
    }
    
    // Updates the toiletname, toilet status
    func updateUserInfo() {
        
        userInfoReference.child(userID!).observeSingleEvent(of: .value) { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                self.navigationBar.title = request["username"] as? String
                
                if request["toiletStatus"] as? String == "false" {
                    
                    self.openSwitch.isOn = false
                }
            }
            self.getImage()
        }
    }
    
    // Retrieves the the profile picture (until completion presents a activity indicator)
    func getImage() {
        
        userInfoReference.child(userID!).child("profilePicture")
            .observeSingleEvent(of: .value) { (snapshot) in

            let imageURL = snapshot.value as? String ?? ""
            let storageRef = self.storage.reference(forURL: imageURL)

            storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    
                    print(error)
                } else {
                    
                    self.profilePicture.clipsToBounds = true
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 4
                    self.profilePicture.image = UIImage(data: data!)
                    self.loadingImage.isHidden = true
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
