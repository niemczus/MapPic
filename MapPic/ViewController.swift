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
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var showImagesButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    
    
    let locationManager = CLLocationManager()
    var goingToShowCollectionView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MapPic🗺"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.userTrackingMode = .follow
        showImagesButton.layer.cornerRadius = showImagesButton.frame.height / 2
        collectionViewTopConstraint.constant = 65
    }

    @IBAction func didTapCurrentLocation(_ sender: UIButton) {
    }
    @IBAction func didTapToggleImages(_ sender: UIButton) {
        if goingToShowCollectionView == true {
            sender.setTitle("Hide Images", for: .normal)
            collectionViewTopConstraint.constant = 8
            collectionViewBottomConstraint.constant = 34
            cameraButtonBottomConstraint.constant = -134
        } else {
            sender.setTitle("Show Images", for: .normal)
            collectionViewTopConstraint.constant = 65
            collectionViewBottomConstraint.constant = -134
            cameraButtonBottomConstraint.constant = 20
        }
        UIView.animate(withDuration: 0.3) {
            self.cameraButton.alpha = self.goingToShowCollectionView ? 0 : 1
            self.imageCollectionView.alpha = self.goingToShowCollectionView ? 1 : 0
            
            self.view.layoutIfNeeded()
        }
        goingToShowCollectionView = !goingToShowCollectionView
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

