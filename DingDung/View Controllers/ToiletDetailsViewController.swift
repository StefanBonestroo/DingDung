//
//  ToiletDetailsViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 24-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Foundation

import Firebase
import FirebaseStorage

class ToiletDetailsViewController: UIViewController {

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var toiletName: UILabel!
    @IBOutlet weak var toiletDescription: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    
    var toiletInfo: Toilet = Toilet()
    
    let storage = Storage.storage()
    let userInfoReference = Database.database().reference().child("users")
    let requestReference = Database.database().reference().child("requests")
    let userID = Auth.auth().currentUser?.uid
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Info",
                                      message: "Are you sure you want to send \(toiletInfo.username!) a request?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let dumbAlert = UIAlertController(title: "Info",
                                      message: "You don't have do a request for your own toilet, you know that right?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let pressOK = UIAlertAction(title:"Yes",
                                    style: UIAlertActionStyle.default,
                                    handler: { action in
                                        
                                        self.sendRequest()
                                        self.performSegue(withIdentifier: "toMyRequest", sender: nil)
        })
        
        let pressCancel = UIAlertAction(title:"No",
                                        style: UIAlertActionStyle.destructive,
                                        handler: { action in
        })
        
        if toiletInfo.owner! == userID! {
            
            dumbAlert.addAction(pressCancel)
            self.present(dumbAlert, animated: true, completion: nil)
        } else {
            
            alert.addAction(pressOK)
            alert.addAction(pressCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        username.text = toiletInfo.username
        toiletName.text = toiletInfo.toiletName
        toiletDescription.text = toiletInfo.toiletDescription
        
        getImage()
    }
    
    func sendRequest() {
        
        self.requestReference.childByAutoId()
            .updateChildValues(["sender": self.userID!,
                                "receiver": self.toiletInfo.owner!,
                                "status": "pending",
                                "timestamp": NSDate().timeIntervalSince1970])
        
    }
    
    func getImage() {
        
        let toiletOwnerID = toiletInfo.owner
        
        userInfoReference.child(toiletOwnerID!).child("profilePicture")
            .observeSingleEvent(of: .value) { (snapshot) in
            
            let imageURL = snapshot.value as? String ?? ""
            let storageRef = self.storage.reference(forURL: imageURL)
            
            storageRef.getData(maxSize: 5 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                    self.profilePicture.image = UIImage(data: data!)
                    self.loadingImage.isHidden = true
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
}
