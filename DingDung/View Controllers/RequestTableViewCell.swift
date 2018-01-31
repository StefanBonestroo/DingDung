//
//  RequestTableViewCell.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 30-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Foundation

import Firebase

// Source: https://medium.com/@aapierce0/swift-using-protocols-to-add-custom-behavior-to-a-uitableviewcell-2c1f09610aa1
protocol RequestTableViewDelegate {
    func requestWasAccepted(_ sender: RequestTableViewCell)
    func requestWasDenied(_ sender: RequestTableViewCell)
}

class RequestTableViewCell: UITableViewCell {

    @IBOutlet weak var someMinutesAgo: UILabel!
    @IBOutlet weak var username: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    var delegate: RequestTableViewDelegate?
    
    @IBAction func yesPressed(_ sender: UIButton) {
        delegate?.requestWasAccepted(self)
    }
    
    @IBAction func noPressed(_ sender: UIButton) {
        delegate?.requestWasDenied(self)
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        username.adjustsFontSizeToFitWidth = true
    }
}
