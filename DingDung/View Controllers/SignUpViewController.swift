//
//  SignUpViewController.swift
//  DingDung
//
//  Handles the creation of a Firebase user account.
//  It will check several requirements.
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    
    // Triggers if 'submit' is pressed
    @IBAction func createNewAccount(_ sender: UIButton) {
        
        // A bunch of checks before passing data to Firebase
        if emailTextField.text == "" ||
            passwordTextField.text == "" ||
            confirmationTextField.text == "" {
            
            signUpAlert("A field was left empty.")
        } else if passwordTextField.text!.count < 6 {
            
            signUpAlert("Your password should be 6 characters or longer.")
        } else if passwordTextField.text != confirmationTextField.text {
            
            signUpAlert("Passwords must match.")
        } else {
    
            makeNewUser()
        }
    }
    
    // Presents the user with a custom error message
    func signUpAlert (_ message: String) {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // Handles the creation of a new user
    func makeNewUser() {
        
        Auth.auth().createUser(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { (user, error) in
            if error == nil {
                
                self.performSegue(withIdentifier: "succesfulSignUp", sender: nil)
            } else {
                
                // Firebase errors
                self.signUpAlert(error!.localizedDescription)
            }
        }
    }

    // Dismisses keyboard when done editing
    func dismissKeyboard() {
        
        view.endEditing(true)
    }
    
    // If retrun is pressed, dismiss keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmationTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Delegates needed for keyboard dismissal
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmationTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}

// Makes dismissal of the keyboard/typer possible
extension SignUpViewController: UITextFieldDelegate {
}

