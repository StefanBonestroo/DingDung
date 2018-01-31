//
//  SignUpViewController.swift
//  DingDung
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
    
    @IBAction func createNewAccount(_ sender: UIButton) {
        
        if emailTextField.text == "" || passwordTextField.text == "" ||
            confirmationTextField.text == "" {
            signUpAlert(message: "A field was left empty.")
        } else if passwordTextField.text!.count < 6 {
            signUpAlert(message: "Your password should be 6 characters or longer.")
        } else if passwordTextField.text != confirmationTextField.text {
            signUpAlert(message: "Passwords must match.")
        } else {
            makeNewUser()
        }
    }
    
    func signUpAlert (message: String) {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func makeNewUser() {
        Auth.auth().createUser(withEmail: emailTextField.text!,
                               password: passwordTextField.text!) { (user, error) in
            if error == nil {
                self.performSegue(withIdentifier: "succesfulSignUp", sender: nil)
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK",
                                                  style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
            }
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmationTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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

