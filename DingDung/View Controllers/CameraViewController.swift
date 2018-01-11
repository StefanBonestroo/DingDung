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

    @IBAction func nicePressed(_ sender: UIButton) {
        performSegue(withIdentifier: "toMap", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool = false) {
        if !taken {
            imagePicker =  UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.modalPresentationStyle = .overCurrentContext
            
            present(imagePicker, animated: true, completion: nil)
            self.taken = true
        }
    }
    
    // Lets user take a photo and saves that to Firebase database
    // (Source: https://www.ioscreator.com/tutorials/take-photo-tutorial-ios8-swift)
    private func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismiss(animated: false, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
