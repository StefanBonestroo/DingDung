//
//  ToiletMapViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 09-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class ToiletMapViewController: UIViewController {
    
    func initiateMapView() {
        let zoomLevel: Float = 15.0
        
        /// A default location (Amsterdam Science Park) to use when location permission is not granted.
        let defaultLocation = CLLocation(latitude: 52.35445147, longitude: 4.95559573)
        
        // Sets the camera to fix to the current location
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        let mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        do {
            // Styles the map
            mapView.mapStyle = try GMSMapStyle(jsonString: mapStyles.basicLayout)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        view = mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initiateMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
