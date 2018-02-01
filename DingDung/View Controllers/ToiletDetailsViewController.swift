//
//  ToiletDetailsViewController.swift
//  DingDung
//
//  Handles the presentation of a detailed view of a user's available toilet anywhere.
//  This includes: the owner's Username, Toilet name, Toilet Description, Toilet Picture
//  In this view, a 'utilization request' can be sent to the owner.
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
    @IBOutlet weak var bigProfilePicture: UIImageView!
    
    @IBOutlet weak var littlePictureButton: UIButton!
    @IBOutlet weak var bigPictureButton: UIButton!
    
    @IBOutlet weak var toiletName: UILabel!
    @IBOutlet weak var toiletDescription: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    
    var toiletInfo: Toilet = Toilet()
    
    // By default, a users doesn't already have a pending request
    var alreadyRequested = false
    
    let storage = Storage.storage()
    let userInfoReference = Database.database().reference().child("users")
    let requestReference = Database.database().reference().child("requests")
    let userID = Auth.auth().currentUser?.uid
    
    // Triggers if the user wants to request
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        
        lookForTheSender()
        
        // The user can only have a single request pending at one time
        let tooManyRequestsAlert = UIAlertController(title: "Info",
                                          message: "You already have a request that is pending...",
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        let alert = UIAlertController(title: "Info",
                                      message: "Are you sure you want to send \(self.toiletInfo.username!) a request?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        // You can't request your own toilet
        let requestOneselfAlert = UIAlertController(title: "Info",
                                          message: "You don't have do a request for your own toilet, you know that right?",
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        let pressCancel = UIAlertAction(title:"Cancel",
                                        style: UIAlertActionStyle.destructive,
                                        handler: { action in
        })
        
        // If OK is pressed on the 'Are you sure?' this runs additional checks before sending it
        let pressOK = UIAlertAction(title:"Yes",
                                    style: UIAlertActionStyle.default,
                                    handler: { action in
                                        
            if self.alreadyRequested {

                tooManyRequestsAlert.addAction(pressCancel)
                self.present(tooManyRequestsAlert, animated: true, completion: nil)
            } else {
                
                self.sendRequest()
            }
        })
        
        if self.toiletInfo.owner! == self.userID! {
            
            requestOneselfAlert.addAction(pressCancel)
            self.present(requestOneselfAlert, animated: true, completion: nil)
        } else {
            
            alert.addAction(pressOK)
            alert.addAction(pressCancel)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // Looks in the current requests if the sender already has a 'pending' one
    func lookForTheSender() {
        
        requestReference.child("current").observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                if request["sender"] as? String ==  self.userID! {
                    self.alreadyRequested = true
                }
            }
        })
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        username.text = toiletInfo.username
        toiletName.text = toiletInfo.toiletName
        toiletDescription.text = toiletInfo.toiletDescription
        
        toiletDescription.adjustsFontSizeToFitWidth = true
        
        getImage()
    }
    
    // Stores the request and segues to it
    func sendRequest() {
    
            self.requestReference.child("current").childByAutoId()
                .updateChildValues(["sender": self.userID!,
                                    "receiver": self.toiletInfo.owner!,
                                    "status": "pending",
                                    "timestamp": NSDate().timeIntervalSince1970]) {_,_ in
                                        self.performSegue(withIdentifier: "toMyRequest", sender: nil)
        }
    }
    
    // Retrieves the image of the toilet from the owner's userInfo
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
                    
                    self.profilePicture.clipsToBounds = true
                    self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.height / 4
                    self.profilePicture.image = UIImage(data: data!)
                    self.bigProfilePicture.image = UIImage(data: data!)
                    self.loadingImage.isHidden = true
                }
            }
        }
    }
    
    // Enlarges the picture to fullscreen
    @IBAction func littlePictureTapped(_ sender: UIButton) {
        
        bigPictureButton.isHidden = false
        bigProfilePicture.isHidden = false
    }
    
    // Makes smaller again
    @IBAction func bigPictureTapped(_ sender: UIButton) {
        
        bigPictureButton.isHidden = true
        bigProfilePicture.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
