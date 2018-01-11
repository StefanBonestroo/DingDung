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

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmationTextField: UITextField!
    
    @IBAction func createNewAccount(_ sender: UIButton) {
        let lengthTotal = (emailTextField.text! + passwordTextField.text! + confirmationTextField.text!).count
        
        func signUpAlert (message: String) {
            let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        if emailTextField.text == "" || passwordTextField.text == "" || confirmationTextField.text == "" {
            signUpAlert(message: "A field was left empty.")
        } else if  lengthTotal <= 24 && emailTextField.text!.count >= 20 {
            signUpAlert(message: "Both usernames and password must be more than 8 characters long. Also, usernames can't be longer than 20 characters.")
        } else if passwordTextField.text != confirmationTextField.text {
            signUpAlert(message: "Passwords must match.")
        } else {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    print("You have successfully signed up")
                    self.performSegue(withIdentifier: "succesfulSignUp", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                }
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
        // Dispose of any resources that can be recreated.
    }
}
