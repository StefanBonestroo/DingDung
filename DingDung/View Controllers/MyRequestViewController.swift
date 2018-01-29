//
//  MyRequestViewController.swift
//  DingDung
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
    
    var image: UIImage?
    
    var greenColor = UIColor.init(red: 0, green: 204/255, blue: 102/255, alpha: 1)
    
    var status: String?
    var receiver: String?
    var message = ""
    
    override func viewWillAppear(_ animated: Bool) {
        loadCurrentRequest()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func iWentButtonPressed(_ sender: UIButton) {
        
        requestReference.observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                if request["sender"] as? String == self.userID! &&
                    request["receiver"] as? String == self.receiver {
                    
                    self.requestReference.child(snapshot.key).updateChildValues(["status": "completed",
                                                                                 "load": "history"])
                }
            }
            self.loadCurrentRequest()
        })
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        
        requestReference.observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                if request["sender"] as? String == self.userID! &&
                    request["receiver"] as? String == self.receiver! {
                    
                    self.requestReference.child(snapshot.key).updateChildValues(["status": "cancelled", "load": "history"])
                    
                }
            }
            self.loadCurrentRequest()
        })
    }
    
    func loadCurrentRequest() {
        
        requestReference.observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                self.status = request["status"] as? String
                self.receiver = request["receiver"] as? String
                
                if request["sender"] as? String == self.userID! && request["load"] as? String != "history" {
                    
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
                        self.showPendingPage()
                    default:
                        
                        self.showEmptyPage()
                        self.extraStatusInfo.text = "There is no request to show!"
                    }
                }
            }
        })
    }
    
    func getAddressInfo() {
    self.userInfoReference.child(self.receiver!).child("toiletAddressInfo").observe(.value) { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                let streetAddress = request["streetAddress"] as! String
                let city = request["city"] as! String
                let stateOrProvince = request["provinceOrState"] as! String
                let country = request["country"] as! String
                
                self.message = "Your request has been accepted, and you can \'utilize the facilities\' on the following address: \n \n \(streetAddress) \n \(city) \n \(stateOrProvince) \n \(country)"
            }
        self.extraStatusInfo.text = self.message
        }
    }
    
    func hidePendingRelatedStuff() {
        
        self.acceptedOrDenied.isHidden = false
        self.extraStatusInfo.isHidden = false
        
        self.profilePicture.isHidden = true
        self.toiletName.isHidden = true
        self.toiletDescription.isHidden = true
        self.loadingImage.isHidden = true
        self.pendingLabel.isHidden = true
    }
    
    func showEmptyPage() {
        
        self.extraStatusInfo.isHidden = false
        
        self.profilePicture.isHidden = true
        self.toiletName.isHidden = true
        self.toiletDescription.isHidden = true
        self.loadingImage.isHidden = true
        self.pendingLabel.isHidden = true
        self.cancelButton.isHidden = true
        self.acceptedOrDenied.isHidden = true
    }
    
    func showPendingPage() {
        
        self.acceptedOrDenied.isHidden = true
        self.extraStatusInfo.isHidden = true
        
        self.profilePicture.isHidden = false
        self.toiletName.isHidden = false
        self.toiletDescription.isHidden = false
        self.pendingLabel.isHidden = false
    }
    
    func getToiletInfo() {
        
        self.userInfoReference.child(self.receiver!).observe(.value, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {
                
                self.toiletName.text = request["toiletName"] as? String
                self.toiletDescription.text = request["toiletDescription"] as? String
                
                self.getImage()
            }
        })
    }
    
    func getImage() {
        
        userInfoReference.child(receiver!).child("profilePicture")
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
