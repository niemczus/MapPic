//
//  ViewController.swift
//  MapPic
//
//  Created by Kamil Niemczyk on 25/02/2022.
//

import UIKit
import MapKit
import CoreLocation
import Cluster

class ViewController: UIViewController, CLLocationManagerDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UICollectionViewDataSource, MKMapViewDelegate, UICollectionViewDelegate {
    

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var showImagesButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    @IBOutlet weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraButtonBottomConstraint: NSLayoutConstraint!
    
    let logo: UIImage? = UIImage(named: "logo")
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
    
    
    let picker = UIImagePickerController()
    
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    let clusterManager = ClusterManager()
    
    
    var goingToShowCollectionView = true
    var images = [UIImage]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = logo
        navigationItem.titleView = imageView
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
    
    func addAnnotation(with image: UIImage) {
        guard let currentLocation = currentLocation else { return }
        let annotation = PhotoAnnotation(image: image)
        annotation.coordinate = currentLocation.coordinate
        clusterManager.add(annotation)
        clusterManager.reload(mapView: mapView)
    }
    
    //MARK: - Location Manager Delegates
    
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
    
    //MARK: - Image Picker Delegates

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        images.append(image)
        
        addAnnotation(with: image)
        
        imageCollectionView.reloadData()
    }
    
    //MARK: - Collection View Data Sources Delegates
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let image = images[indexPath.item]
        
        cell.populate(with: image)
        
        return cell
    }
    
    //MARK: - Collection View Delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.item]
        performSegue(withIdentifier: "segue.Main.mapToImageViewer", sender: image)
    }
    
    //MARK: - Map View Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let clusterAnnotation = annotation as? ClusterAnnotation {
            let identifier = "cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if let clusterAnnotationView = view as? ClusterAnnotationView {
                clusterAnnotationView.annotation = clusterAnnotation
                
            } else {

                let clusterAnnotationView = ClusterAnnotationView(annotation: clusterAnnotation, reuseIdentifier: identifier)
//                clusterAnnotationView.tintColor = .purple
//                clusterAnnotationView.countLabel.text = String(clusterAnnotation.annotations.count)
                view = clusterAnnotationView
            }
            return view
            
        } else if let photoAnnotation = annotation as? PhotoAnnotation {
            let identifier = "photo"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if let annotationView = view {
                annotationView.annotation = photoAnnotation
            } else {
                let annotationView = MKAnnotationView(annotation: photoAnnotation, reuseIdentifier: identifier)
                view = annotationView
            }
            
            view?.image = photoAnnotation.resizedImage
            
            return view
            
        }
        return nil
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let imageViewerVC = segue.destination as? ImageViewerVC, let image = sender as? UIImage {
            imageViewerVC.image = image
        }
    }
    
}

