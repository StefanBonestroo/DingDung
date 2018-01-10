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

let mapLayout = "[" +
    "{" +
    "    \"elementType\": \"labels\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"administrative\"," +
    "    \"elementType\": \"geometry\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"administrative.land_parcel\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"administrative.neighborhood\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"landscape.man_made\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"color\": \"#804000\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"landscape.natural\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"color\": \"#9d5700\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"poi\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"road\"," +
    "    \"elementType\": \"labels.icon\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"transit\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"visibility\": \"off\"" +
    "    }" +
    "    ]" +
    "    }," +
    "{" +
    "    \"featureType\": \"water\"," +
    "    \"stylers\": [" +
    "    {" +
    "    \"color\": \"#fffabc\"" +
    "    }" +
    "    ]" +
    "    }" +
"]"

class ToiletMapViewController: UIViewController {
    
    var zoomLevel: Float = 15.0
    
    /// A default location to use when location permission is not granted.
    let defaultLocation = CLLocation(latitude: 52.35445147, longitude: 4.95559573)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the camera to fix to the current location
        let camera = GMSCameraPosition.camera(withLatitude: defaultLocation.coordinate.latitude,
                                              longitude: defaultLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        let mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        
        do {
            // Set the map style by passing a valid JSON string.
            mapView.mapStyle = try GMSMapStyle(jsonString: mapLayout)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        view = mapView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
