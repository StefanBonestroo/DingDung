//
//  CameraViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var imagePicker: UIImagePickerController!
    var taken = false
    
    @IBOutlet weak var waiting: UIActivityIndicatorView!
    
    @IBOutlet weak var letsGoButton: UIButton!
    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Lets user take a photo and saves that to Firebase database
    // (Source: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift)
    override func viewWillAppear(_ animated: Bool) {
        if !taken {
            setUpCamera()
            imagePickerControllerDidCancel(imagePicker)
        } else {
            waiting.isHidden = true
            letsGoButton.isHidden = false
        }
    }
    
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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.view!.removeFromSuperview()
        imagePicker.removeFromParentViewController()
        taken = true
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
