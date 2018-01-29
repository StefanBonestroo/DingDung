//
//  ToiletMapViewController.swift
//  DingDung
//
//  Created by Stefan Bonestroo on 09-01-18.
//  Copyright © 2018 Stefan Bonestroo. All rights reserved.
//

import Foundation
import UIKit

import Firebase
import GoogleMaps
import GooglePlaces

class ToiletMapViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let zoomLevel: Float = 15.0
    var locked = true
    
    var mapView = GMSMapView()
    var currentLocation: CLLocation?
    var placesClient: GMSPlacesClient!
    
    var userInfoReference = Database.database().reference().child("users")
    let userID = Auth.auth().currentUser?.uid
    
    var availableToilets: [Toilet] = []
    var toiletClicked: Toilet = Toilet()
    var markerIcon = UIImage(named: "markericon.png")!.withRenderingMode(.alwaysTemplate)
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewDidAppear(animated)
        self.locationManager.startUpdatingLocation()
        
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.delegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        self.locationManager.stopUpdatingLocation()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        locationManager.delegate = self

        // Sets the camera to fix to a basic location
        let camera = GMSCameraPosition.camera(withLatitude: 52.35445147,
                                              longitude: 4.95559573,
                                              zoom: zoomLevel)
        
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.setMinZoom(zoomLevel, maxZoom: zoomLevel)

        
        do {
            // Styles the map
            mapView.mapStyle = try GMSMapStyle(jsonString: mapStyles.basicLayout)
        } catch {
            NSLog("One or more of the map styles failed to load. \(error)")
        }
        
        self.locationManager.startUpdatingLocation()
        self.view = mapView
        
        getToilets()
    }
    
    // Displays toilets within view as markers
    func showToiletsOnMap() {
        
        let toilets = self.availableToilets
        
        for toilet in toilets {
            
            let marker = GMSMarker(position: toilet.location!)
            
            marker.map = mapView
            marker.icon = self.markerIcon
            marker.title = "\(toilet.toiletName!)"
            marker.snippet = "\(toilet.username!)"
            marker.tracksInfoWindowChanges = true
        }
    }
    
    // Requests the database for some basic info on the toilets that are open for use
    func getToilets() {
        
        userInfoReference.observe(.childAdded, with: { (snapshot) in
            if let request = snapshot.value as? [String: AnyObject] {

                let toilet = Toilet()

                // If a toilet is available, store some basic info for display on map
                if request["toiletStatus"] as? String == "true" {

                    var coordinates: CLLocationCoordinate2D {
                        return CLLocationCoordinate2D (latitude: request["latitude"]! as! Double,
                                                       longitude: request["longitude"] as! Double)
                    }

                    toilet.username = request["username"] as? String
                    toilet.owner = request["userID"] as? String
                    toilet.toiletName = request["toiletName"] as? String
                    toilet.toiletDescription = request["toiletDescription"] as? String
                    toilet.profilePicture = request["profilePicture"] as? String
                    toilet.location = coordinates
                    
                    self.availableToilets.append(toilet)
                }
            }
            self.showToiletsOnMap()
            self.locked = false
        })
    }
    
    @ IBAction func closeDetails(segue: UIStoryboardSegue) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ToiletMapViewController: CLLocationManagerDelegate {
    
    // Handles proper location authorization and completion
    // Source: https://stackoverflow.com/questions/37412581/cant-get-current-location-gps-on-google-maps-ios-sdk
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            if locked {
                
                let newPosition = GMSCameraPosition(target: location.coordinate,
                                                    zoom: 15,
                                                    bearing: 0,
                                                    viewingAngle: 0)
                mapView.animate(to: newPosition)
            }
        }
    }
}

extension ToiletMapViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        
        for toilet in availableToilets {
            if toilet.username == marker.snippet {
                self.toiletClicked = toilet
                self.performSegue(withIdentifier: "toDetails", sender: nil)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ToiletDetailsViewController {
            destination.toiletInfo = self.toiletClicked
        }
    }
}
