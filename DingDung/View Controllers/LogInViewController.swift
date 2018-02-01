//
//  LogInViewController.swift
//  DingDung
//
//  The LogInViewController manages the authentication of a user.
//  It will check whether a users profile is complete with profile picture & address
//
//  Created by Stefan Bonestroo on 15-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit

import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // If Submit is pressed, run checks. If successful, go to Tab Bar menu.
    // Source: https://www.appcoda.com/firebase-login-signup/
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        
        if emailTextField.text == "" || passwordTextField.text == "" {
            
            signUpAlert("A field was left empty.")
        } else {
            
            // A user will be logged in succesfully if no errors are thrown
            Auth.auth().signIn(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    
                    // References to the user and a tree in the database
                    let userID = Auth.auth().currentUser?.uid
                    let userReference = Database.database().reference()
                        .child("users").child(userID!)
                    
                    // A users' database table is checked for a profile picture and address
                    userReference.observeSingleEvent(of: .value, with: { (snapshot) in
                        if snapshot.hasChild("profilePicture") && snapshot.hasChild("toiletAddressInfo") {
                            
                            // If present, a profile is complete and a user can be logged in
                            self.performSegue(withIdentifier: "succesfulLogIn", sender: nil)
                        } else {
                            // Else, redo the entering of that data
                            self.performSegue(withIdentifier: "redoPicture", sender: nil)
                        }
                    })
                } else {
                    
                    // These messages are passed from Firebase (username exists etc.)
                    self.signUpAlert(error!.localizedDescription)
                }
            }
        }
    }
    
    // Presents the user with cumstom error message
    func signUpAlert (_ message: String) {
        
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Dismisses the keyboard when it is done editing
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // When return is pressed, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Delegates necessary for the the keyboard dismissals
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // Facilitates the unwind 
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {
        
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// Makes dismissal of the keyboard/typer possible
extension LogInViewController: UITextFieldDelegate {
}
