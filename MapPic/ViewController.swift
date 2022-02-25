//
//  ViewController.swift
//  MapPic
//
//  Created by Kamil Niemczyk on 25/02/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MapPic🗺"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.userTrackingMode = .follow
    }

    @IBAction func didTapCamera(_ sender: UIButton) {
        print("selected camera")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: manager.startUpdatingLocation()
        default: break
        }
    }
    
}

