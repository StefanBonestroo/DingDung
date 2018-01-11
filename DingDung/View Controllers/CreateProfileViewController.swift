//
//  CreateProfileViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit

class CreateProfileViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var toiletnameTextField: UITextField!
    @IBOutlet weak var toiletDescriptionTextField: UITextView!
    
    
    // Initiates the camera
    // (Source: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift)
    @IBAction func takePicture(_ sender: UIButton) {
        
        func createProfileAlert (message: String) {
            let alertController = UIAlertController(title: "Oops!", message: message, preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            present(alertController, animated: true, completion: nil)
        }
        
        if usernameTextField.text == "" || toiletnameTextField.text! == "" || toiletDescriptionTextField.text! == "" {
            createProfileAlert(message: "A field was left empty.")
        } else if (usernameTextField.text!.count < 5 && usernameTextField.text!.count > 21) ||
            (toiletnameTextField.text!.count < 5 && toiletnameTextField.text!.count > 21) {
            createProfileAlert(message: "Username and Toilet Name should be between 6 and 20 characters long")
        } else if toiletDescriptionTextField.text!.count > 19 && toiletDescriptionTextField.text!.count < 201 {
            createProfileAlert(message: "Your Toilet Description should be between 20 and 200 characters long")
        } else {
            performSegue(withIdentifier: "toCamera", sender: nil)
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // If enter is pressed, close editing
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange,
                  replacementText text: String) -> Bool {
        if(text == "\n") {
            toiletDescriptionTextField.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        usernameTextField.resignFirstResponder()
        toiletnameTextField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        toiletnameTextField.delegate = self
        toiletDescriptionTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
