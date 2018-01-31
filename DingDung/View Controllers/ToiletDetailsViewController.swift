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
    var alreadyRequested = false
    
    let storage = Storage.storage()
    let userInfoReference = Database.database().reference().child("users")
    let requestReference = Database.database().reference().child("requests")
    let userID = Auth.auth().currentUser?.uid
    
    @IBAction func requestButtonPressed(_ sender: UIButton) {
        
        lookForTheSender()
        
        let tooManyRequestsAlert = UIAlertController(title: "Info",
                                          message: "You already have a request that is pending...",
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        let alert = UIAlertController(title: "Info",
                                      message: "Are you sure you want to send \(self.toiletInfo.username!) a request?",
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let requestOneselfAlert = UIAlertController(title: "Info",
                                          message: "You don't have do a request for your own toilet, you know that right?",
                                          preferredStyle: UIAlertControllerStyle.alert)
        
        let pressCancel = UIAlertAction(title:"Cancel",
                                        style: UIAlertActionStyle.destructive,
                                        handler: { action in
        })
        
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
    
    func sendRequest() {
    
            self.requestReference.child("current").childByAutoId()
                .updateChildValues(["sender": self.userID!,
                                    "receiver": self.toiletInfo.owner!,
                                    "status": "pending",
                                    "timestamp": NSDate().timeIntervalSince1970]) {_,_ in
                                        self.performSegue(withIdentifier: "toMyRequest", sender: nil)
        }
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
