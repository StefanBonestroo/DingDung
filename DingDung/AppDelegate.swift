//
//  AppDelegate.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 08-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import GooglePlacePicker

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let myMapsAPI = "AIzaSyCtc0MBHtrnlVcneVVTxKo0_zNPSJryncw"
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            FirebaseApp.configure()
            GMSServices.provideAPIKey(myMapsAPI)
            GMSPlacesClient.provideAPIKey(myMapsAPI)
            return true
    }
}
