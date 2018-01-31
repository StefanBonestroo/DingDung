//
//  Request.swift
//  DingDung
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
    
    func calculateMinutes(_ currentTimestamp: Double?) -> Int {
        
        let minutes = 60.0
        
        let calculated = (currentTimestamp! - timestamp!) / minutes
        
        return Int(calculated)
    }
}
