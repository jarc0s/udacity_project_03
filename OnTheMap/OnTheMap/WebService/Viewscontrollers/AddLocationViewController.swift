//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by juan on 11/3/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location: CLLocation?
    var mediaURL: String?
    var mapString: String?
    
    override func viewDidLoad() {
        //Center map on location
        if let location = location {
            mapView.setCenter(location.coordinate, animated: true)
            addAnnotation(location: location.coordinate)
            let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: CLLocationDistance(exactly: 10000)!, longitudinalMeters: CLLocationDistance(exactly: 10000)!)
            mapView.setRegion(mapView.regionThatFits(region), animated: true)
        }
    }
    
    private func addAnnotation(location: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = mapString ?? ""
        mapView.addAnnotation(annotation)
    }
    
    @IBAction func addLocationAction(_ sender: Any) {
        if let location = location {
            OTMClient.postUserLocation(location: location.coordinate, mediaUrl: mediaURL ?? "", mapString: mapString ?? "", completion: handleUpdateUserResponse(success:error:))
        }
    }
    
    private func handleUpdateUserResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            if success {
                //Go to map
                self.performSegue(withIdentifier: "segueTotabBarController", sender: nil)
            }else {
                self.showUpdateFailure(message: error?.localizedDescription ?? "")
            }
        }
    }
    
    func showUpdateFailure(message: String) {
        let alertVC = UIAlertController(title: "Update Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}

// MARK: - MKMapViewDelegate
extension AddLocationViewController: MKMapViewDelegate {
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView?.rightCalloutAccessoryView?.isHidden = true
            //pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
}
