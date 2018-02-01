//
//  Toilet.swift
//  DingDung
//
//  This model can be used to create a object containing the toilet information.
//  To be used in the ToiletMapViewController()
//
//  Created by Stefan Bonestroo on 17-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Toilet: NSObject {
    
    var username: String?
    var owner: String?
    var toiletName: String?
    var toiletDescription: String?
    var profilePicture: String?
    var location: CLLocationCoordinate2D?
}
