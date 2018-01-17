//
//  User.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 17-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation

struct User: Codable {
    
    var username: String
    var emailAddress: String
    
    enum CodingKeys: String, CodingKey {
        
        case username
        case emailAddress
    }
}
