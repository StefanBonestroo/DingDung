//
//  MyRequestViewController.swift
//  DingDung
//
//  Handles the presentation of the current request: pending, accepted, or denied.
//  Here, this request can be canceled and/or put in the the request history.
//  An accepted request will be coupled with the presentation of the toilet's address
//
//  Created by Stefan Bonestroo on 25-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Foundation

import Firebase
import FirebaseStorage

class MyRequestViewController: UIViewController {

    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var bigProfilePicture: UIImageView!
    
    @IBOutlet weak var littlePictureButton: UIButton!
    @IBOutlet weak var bigPictureButton: UIButton!
    
    @IBOutlet weak var toiletName: UILabel!
    @IBOutlet weak var toiletDescription: UILabel!
    @IBOutlet weak var loadingImage: UIActivityIndicatorView!
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var iWentButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var acceptedOrDenied: UILabel!
    @IBOutlet weak var extraStatusInfo: UILabel!
    
    let storage = Storage.storage()
    
    let databaseReference = Database.database().reference()
    let requestReference = Database.database().reference().child("requests")
    let userInfoReference = Database.database().reference().child("users")
    let userID = Auth.auth().currentUser?.uid
    
    // Firebase's .observe method should be shut off at some point
    var cancelHandler: DatabaseHandle?
    var iWentHandler: DatabaseHandle?
    
    var image: UIImage?
    
    var greenColor = UIColor.init(red: 0, green: 204/255, blue: 102/255, alpha: 1)
    
    var status: String?
    var receiver: String?
    var message = ""
    
    // A request is updated everytime the view appears
    override func viewWillAppear(_ animated: Bool) {
        
        loadCurrentRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Triggers the completion of a request when it was accepted
    @IBAction func iWentButtonPressed(_ sender: UIButton) {
            
        self.iWentHandler = requestReference.child("current").observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                if request["sender"] as? String == self.userID! &&
                    request["receiver"] as? String == self.receiver {
                    
                    self.moveToHistory(snapshot.key, status: "completed")
                    self.loadCurrentRequest()
                }
            }
        })
        // A observer should be shut off
        self.requestReference.child("current").removeObserver(withHandle: self.iWentHandler!)
    }
    
    // Triggers the cancellation of a request, no matter the status
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        self.cancelHandler = requestReference.child("current").observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                if request["sender"] as? String == self.userID! &&
                    request["receiver"] as? String == self.receiver {
                    
                    self.moveToHistory(snapshot.key, status: "cancelled")
                    self.loadCurrentRequest()
                }
            }
        })
        // Exit observer
        self.requestReference.child("current").removeObserver(withHandle: self.cancelHandler!)
    }
    
    // Removes a request from the 'current' tree and moves it to the user's 'history'
    func moveToHistory(_ key: String?, status: String) {
        
        self.requestReference.child("history").child(self.userID!)
            .childByAutoId().updateChildValues(["sender": self.userID!,
                                                "receiver": self.receiver!,
                                                "status": status,
                                                "timestamp": NSDate().timeIntervalSince1970])
        
        self.requestReference.child("current")
            .child(key!).removeValue()
    }
    
    // Retrieves request data and presents them according to their status
    func loadCurrentRequest() {
        
        self.showEmptyPage()
        
        requestReference.child("current").observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                if request["sender"] as? String == self.userID! {
                    
                    self.receiver = request["receiver"] as? String
                    self.status = request["status"] as? String
                    
                    switch self.status! {
                    case "accepted":
                        
                        self.acceptedOrDenied.text = "Accepted"
                        self.acceptedOrDenied.textColor = self.greenColor
                        self.iWentButton.isHidden = false
                        
                        self.hidePendingRelatedStuff()
                        
                        self.getAddressInfo()
                        
                    case "denied":
                        
                        self.acceptedOrDenied.text = "Denied"
                        self.acceptedOrDenied.textColor = UIColor.red
                        
                        self.hidePendingRelatedStuff()
                        
                        self.extraStatusInfo.text =
                        "Your request was denied by the owner.\n Please, try another toilet!"
                        
                    case "pending":
                        
                        self.getToiletInfo()
                        
                    default:
                        
                        self.showEmptyPage()
                    }
                }
            }
        })
        self.loadingImage.isHidden = true
    }
    
    // If a request was accepted, the user is presented with the toilet address
    func getAddressInfo() {
        
        self.userInfoReference.child(self.receiver!)
            .child("toiletAddressInfo").observe(.value) { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                let streetAddress = request["streetAddress"] as! String
                let city = request["city"] as! String
                let stateOrProvince = request["provinceOrState"] as! String
                let country = request["country"] as! String
                
                self.message = "Your request has been accepted, and you can \'utilize the facilities\' on the following address: \n \n\(streetAddress) \n \(city) \n \(stateOrProvince) \n \(country)"
            }
                
        self.extraStatusInfo.text = self.message
        }
    }
    
    // Every page has its own componements to be shown
    func hidePendingRelatedStuff() {
        
        self.acceptedOrDenied.isHidden = false
        self.extraStatusInfo.isHidden = false
        self.cancelButton.isHidden = false
        
        self.profilePicture.isHidden = true
        self.toiletName.isHidden = true
        self.toiletDescription.isHidden = true
        self.pendingLabel.isHidden = true
        
    }
    
    func showEmptyPage() {
        
        self.extraStatusInfo.isHidden = false
        self.extraStatusInfo.text = "There are no requests to show!"
        
        self.profilePicture.isHidden = true
        self.toiletName.isHidden = true
        self.toiletDescription.isHidden = true
        self.loadingImage.isHidden = true
        self.pendingLabel.isHidden = true
        self.iWentButton.isHidden = true
        self.cancelButton.isHidden = true
        self.acceptedOrDenied.isHidden = true
    }
    
    func showPendingPage() {
        
        self.loadingImage.isHidden = false
        self.profilePicture.isHidden = false
        self.toiletName.isHidden = false
        self.toiletDescription.isHidden = false
        self.pendingLabel.isHidden = false
        self.cancelButton.isHidden = false
        
        self.acceptedOrDenied.isHidden = true
        self.extraStatusInfo.isHidden = true
        
    }
    
    // This loads the toilet information of a request
    func getToiletInfo() {
        
        self.userInfoReference.child(self.receiver!).observe(.value, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                self.toiletName.text = request["toiletName"] as? String
                self.toiletDescription.text = request["toiletDescription"] as? String
                
                self.getImage()
                self.showPendingPage()
            }
        })
    }
    
    // Retrieves the requested toilet's profile picture
    func getImage() {
        
        if receiver == nil {
            return
        }
        userInfoReference.child(receiver!).child("profilePicture")
            .observeSingleEvent(of: .value) { (snapshot) in
                
            let imageURL = snapshot.value as! String
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
    
    // Enlarges the image view to fullscreen
    @IBAction func littlePicturePressed(_ sender: UIButton) {
        
        bigPictureButton.isHidden = false
        bigProfilePicture.isHidden = false
    }
    
    // This hides that again
    @IBAction func bigPicturePressed(_ sender: UIButton) {
        
        bigPictureButton.isHidden = true
        bigProfilePicture.isHidden = true
    }
    
    
    

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
