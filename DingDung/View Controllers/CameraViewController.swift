//
//  CameraViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CameraViewController: UIViewController {
    
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    var imagePicker: UIImagePickerController!
    var taken = false
    
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
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        storeAddressData()
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    // Lets user take a photo and saves that to Firebase database
    // (Source: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift)
    override func viewWillAppear(_ animated: Bool) {
        if !taken {
            
            setUpCamera()
            imagePickerControllerDidCancel(imagePicker)
        } else {
            showAddressScreen()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    // Removes the subview if a picture is taken
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.view!.removeFromSuperview()
        imagePicker.removeFromParentViewController()
        taken = true
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        streetAddressText.resignFirstResponder()
        cityText.resignFirstResponder()
        provinceOrStateText.resignFirstResponder()
        countryText.resignFirstResponder()
        return true
    }
    
    // Stores the street address, city, state, and country that the users entered
    func storeAddressData() {
        
        let userReference = self.ref.child("users").child(userID!)
        
        userReference.child("toiletAddressInfo").setValue(["streetAddress": streetAddressText.text!,
                                                           "city": cityText.text!,
                                                           "provinceOrState": provinceOrStateText.text!,
                                                           "country": countryText.text!])
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
