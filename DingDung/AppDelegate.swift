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
    
    // This is my Google Maps API key
    let myMapsAPI = "AIzaSyCtc0MBHtrnlVcneVVTxKo0_zNPSJryncw"

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
        -> Bool {
            
            // Configures the Firebase app for use in classes
            FirebaseApp.configure()
            
            // Passes key to the Google API's
            GMSServices.provideAPIKey(self.myMapsAPI)
            GMSPlacesClient.provideAPIKey(self.myMapsAPI)
            return true
    }
}
