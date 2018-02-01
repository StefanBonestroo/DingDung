//
//  Request.swift
//  DingDung
//
//  This model can be used to create an object containing request info.
//  To be used inside the RequestedTableViewController()
//
//  Created by Stefan Bonestroo on 30-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import Foundation

class Request: NSObject {

    var username: String?
    var timestamp: Double?
    var status: String?
    var sender: String?
    
    // Calculates the amount of minutes passed since entry in the database
    func calculateMinutes(_ currentTimestamp: Double?) -> Int {
        
        let minutes = 60.0
        
        let calculated = (currentTimestamp! - timestamp!) / minutes
        
        return Int(calculated)
    }
}
