//
//  ViewController.swift
//  MapPic
//
//  Created by Kamil Niemczyk on 25/02/2022.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var showImagesButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    
    let picker = UIImagePickerController()
    
    let locationManager = CLLocationManager()
    
    var currentLocation: CLLocation?
    
    var goingToShowCollectionView = true
    
    var images = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "MapPic🗺"
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.userTrackingMode = .follow
        
        picker.delegate = self
        picker.sourceType = .photoLibrary
        
        showImagesButton.layer.cornerRadius = showImagesButton.frame.height / 2
        collectionViewTopConstraint.constant = 65
        cameraButtonBottomConstraint.constant = 20
    }

    @IBAction func didTapCurrentLocation(_ sender: UIButton) {
        print("tapped")
        
        guard let currentLocation = currentLocation else { return }
        mapView.camera.centerCoordinate = currentLocation.coordinate

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
        present(picker, animated: true, completion: nil)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse: manager.startUpdatingLocation()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        self.currentLocation = currentLocation
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        images.append(image)
        imageCollectionView.reloadData()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let image = images[indexPath.item]
        
        cell.populate(with: image)
        
        return cell
    }
    
}

