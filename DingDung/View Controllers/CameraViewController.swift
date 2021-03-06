//
//  CameraViewController.swift (+ SubmitAddressViewController)
//  DingDung
//
//  CameraViewController() lets the user photograph his/her toilet, as well as
//  input his/her address in 4 textfields.
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class CameraViewController: UIViewController {
    
    @IBOutlet weak var waiting: UIActivityIndicatorView!
    
    @IBOutlet weak var personalInformationTitle: UILabel!
    @IBOutlet weak var streetAddress: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var provinceOrState: UILabel!
    @IBOutlet weak var country: UILabel!
    
    @IBOutlet weak var streetAddressText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var provinceOrStateText: UITextField!
    @IBOutlet weak var countryText: UITextField!
    
    @IBOutlet weak var letsGoButton: UIButton!
    
    // References to current user and database
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser!.uid
    
    // By default, coordinates are not saved/stored
    // Coordinates need to be obtained by geocoding the address
    var succesfulCoordinates = false
    
    // Initiates the camera screen & defaults to a picture 'not being taken'
    var imagePicker: UIImagePickerController!
    var taken = false
    
    // Compression of the image - Range: 0 to 1
    var imageQuality: CGFloat = 0.5
    
    // Makes sure the address info is saved before going to the main application
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let userReference = self.ref.child("users").child(self.userID)
        
        userReference.child("toiletAddressInfo")
            .updateChildValues(["streetAddress": streetAddressText.text!,
                                "city": cityText.text!,
                                "provinceOrState": provinceOrStateText.text!,
                                "country": countryText.text!])
    }

    // Only when the address is succelfully geocoded into coordinates, proceed
    override func shouldPerformSegue(withIdentifier identifier: String,
                                     sender: Any?) -> Bool {
        
        let userReference = self.ref.child("users").child(self.userID)
        saveCoordinates(userReference)
        
        if identifier == "toMap" {
            if self.succesfulCoordinates {
                return true
            }
        }
        return false
    }
    
    // Lets user take a photo and saves that to Firebase database
    // (Source: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift)
    override func viewWillAppear(_ animated: Bool) {
        
        if !taken {
            
            setUpCamera()
            
            self.imagePicker.view!.removeFromSuperview()
            self.imagePicker.removeFromParentViewController()
        } else {
            
            showAddressScreen()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates for keyboard dismissal
        streetAddressText.delegate = self
        cityText.delegate = self
        provinceOrStateText.delegate = self
        countryText.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    // Creates and presents an Image Picker Controller, which is a subview of our current View Controller
    func setUpCamera() {
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.modalPresentationStyle = .fullScreen
        
        self.addChildViewController(imagePicker)
        imagePicker.didMove(toParentViewController: self)
        self.view!.addSubview(imagePicker.view!)
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Makes sure the image is passed on to save when 'Use Photo' is pressed
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        saveImage(chosenImage)
        
        self.taken = true
        dismiss(animated: true, completion: nil)
    }
    
    // Removes the subview if cancel is pressed, however will be presented again.
    // It is not possible to cancel the 'taking of a profile picture'
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        self.dismiss(animated: true)
    }
    
    // Changes the Camera view to a view where addresses are entered
    func showAddressScreen() {
        
        waiting.isHidden = true
        
        personalInformationTitle.isHidden = false
        streetAddress.isHidden = false
        city.isHidden = false
        provinceOrState.isHidden = false
        country.isHidden = false
        letsGoButton.isHidden = false
        
        streetAddressText.isHidden = false
        cityText.isHidden = false
        provinceOrStateText.isHidden = false
        countryText.isHidden = false
        
        letsGoButton.isHidden = false
    }
    
    // If return is pressed, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        streetAddressText.resignFirstResponder()
        cityText.resignFirstResponder()
        provinceOrStateText.resignFirstResponder()
        countryText.resignFirstResponder()
        return true
    }
    
    // Stores image in Firebase storage and saves its reference in the database
    func saveImage(_ image: UIImage) {
        
        let profileRef = Storage.storage().reference().child("profilePictures")
        
        // JPEG, because it takes forever to load a png
        if let uploadData = UIImageJPEGRepresentation(image, imageQuality) {
            
            profileRef.child("\(userID).jpg").putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    
                    self.imagePicker.view!.removeFromSuperview()
                    self.imagePicker.removeFromParentViewController()
                    
                    self.createAlert("Something went wrong uploading your picture. Try retaking it some other time.")
                    return
                }
                // 'downloadURL' is what is being saved to the userInfo in the Firebase database
                let downloadURL = String(describing: metadata!.downloadURL()!)
                let userReference = self.ref.child("users").child(self.userID)
                
                userReference.updateChildValues(["profilePicture": "\(downloadURL)"])
            }.resume()
        }
    }
    
    // Geocodes an address into a set of coordinates and saves those to the database
    // Sources: https://stackoverflow.com/questions/42279252/convert-address-to-coordinates-swift
    func saveCoordinates(_ userReference: DatabaseReference) {
        
        // Makes a readable string of the address
        let addressString = "\(streetAddressText.text!), \(cityText.text!), \(provinceOrStateText.text!), \(countryText.text!)"
        
        let geocoder = CLGeocoder()
        
        // Uses the CLGeocoder() to get the coordinates
        // Presents user with error if something went wrong
        geocoder.geocodeAddressString(addressString) { placemarks, error in
            if error != nil {
                
                self.succesfulCoordinates = false
                self.createAlert("This is not a valid address. Try adjusting it a bit.")
            } else {
            
                let placemark = placemarks?.first
                let lat = placemark?.location?.coordinate.latitude
                let long = placemark?.location?.coordinate.longitude
                
                self.succesfulCoordinates = true
                
                // Saves those to database
                userReference.updateChildValues(["latitude": lat!, "longitude": long!])
            }
        }
    }
    
    // Presents to the user a custom error message
    func createAlert(_ message: String) {
        
        let alert = UIAlertController(title: "Oops!",
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
}

// Makes dismissal of the keyboard/typer possible
extension CameraViewController: UITextFieldDelegate {
}

// Facilitates communication between the current view controller and subviews
extension CameraViewController: UINavigationControllerDelegate {
}

// Facilitates communication between the subview and the ImagePickerViewController
extension CameraViewController: UIImagePickerControllerDelegate {
}
