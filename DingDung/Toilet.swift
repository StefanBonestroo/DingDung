//
//  Toilet.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 17-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation

struct Toilet: Codable {
    
    var username: String
    var toiletName: String
    var toiletDescription: String
    var toiletImageURL: String
    var toiletCoordinates: [String]
    var toiletAddress: [String]
    
    enum CodingKeys: String, CodingKey {
        case username
        case toiletName
        case toiletDescription
        case toiletImageURL
        case toiletCoordinates
        case toiletAddress
    }
}
