//
//  CreateProfileViewController.swift
//  DingDung
//
//  Handles the creation of a custom user profile with:
//
//  Username, Toilet Name, and a Toilet Description
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase

class CreateProfileViewController: UIViewController {

    // References to database tree and the user
    let currentUser = Auth.auth().currentUser
    let ref = Database.database().reference()
    let userID = Auth.auth().currentUser?.uid
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var toiletnameTextField: UITextField!
    @IBOutlet weak var toiletDescriptionTextField: UITextView!
    
    // Initiates the camera (only if checks are ok)
    // (Source: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toCamera" {
            
            if usernameTextField.text == "" ||
                toiletnameTextField.text! == "" ||
                    toiletDescriptionTextField.text! == "" {
                
                createProfileAlert("A field was left empty.")
                
            } else if (usernameTextField.text!.count < 5 &&
                        usernameTextField.text!.count > 21) ||
                        (toiletnameTextField.text!.count < 5 &&
                            toiletnameTextField.text!.count > 21) {
                
                createProfileAlert("Username and Toilet Name should be between 6 and 20 characters long")
                
            } else if toiletDescriptionTextField.text!.count < 19 &&
                        toiletDescriptionTextField.text!.count > 201 {
                
                createProfileAlert("Your Toilet Description should be between 20 and 200 characters long")
                
            } else {
                storeData()
            }
        }
    }
    
    // Presents the user with a custom error message
    func createProfileAlert (_ message: String) {
        
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Dismisses keyboard when done editing
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // If enter is pressed, close editing for textView
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        
        if text == "\n" {
            
            toiletDescriptionTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    // Same, but for textFields
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        toiletnameTextField.resignFirstResponder()
        return true
    }
    
    // Stores userdata in the database
    func storeData() {
        
        let userReference = self.ref.child("users").child(userID!)
        
        userReference.updateChildValues(["username": usernameTextField.text!,
                                         "userID": self.userID!,
                                         "email": currentUser!.email!,
                                         "toiletStatus": "false"])
        
        userReference.updateChildValues(["toiletName": toiletnameTextField.text!,
                                         "toiletDescription": toiletDescriptionTextField.text!])
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates for keyboard dismissal
        usernameTextField.delegate = self
        toiletnameTextField.delegate = self
        toiletDescriptionTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Communicates between the keyboard and the textFields
extension CreateProfileViewController: UITextFieldDelegate {
}

// Communicates between the keyboard and the textViews
extension CreateProfileViewController: UITextViewDelegate {
}
