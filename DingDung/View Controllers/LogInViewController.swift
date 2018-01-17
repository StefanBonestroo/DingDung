//
//  LogInViewController.swift
//  DingDung
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
            signUpAlert(message: "A field was left empty.")
            
        } else {
            Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                if error == nil {
                    self.performSegue(withIdentifier: "succesfulLogIn", sender: nil)
                } else {
                    let alertController = UIAlertController(title: "Oops!", message: error?.localizedDescription, preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                }
            }
        }
    }
    
    // Presents the user with a error message
    func signUpAlert (message: String) {
        let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(defaultAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
