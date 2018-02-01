//
//  mapStyle.swift
//  DingDung
//
//  Additional styles for the Google Maps mapView can be created here
//
//  Created by Stefan Bonestroo on 11-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation

struct mapStyles {
    
    static let basicLayout = "[" +
        "{" +
        "    \"elementType\": \"labels\"," +
        "    \"stylers\": [" +
        "    {" +
        "    \"visibility\": \"off\"" +
        "    }" +
        "    ]" +
        "    }," +
        "{" +
        "    \"featureType\": \"administrative.land_parcel\"," +
        "    \"elementType\": \"labels\"," +
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
    "]"
}
