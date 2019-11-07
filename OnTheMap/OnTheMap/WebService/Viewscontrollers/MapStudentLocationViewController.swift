//
//  MapStudentLocationViewController.swift
//  OnTheMap
//
//  Created by juan on 11/2/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapStudentLocationViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var buttonReload: UIBarButtonItem!
    
    var results: [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad() {
        taskForGetUserLocation()
    }
    
    private func taskForGetUserLocation() {
        print("\(#function)")
        self.buttonReload.isEnabled = false
        OTMClient.getUsersLocation(completion: handleListStudenResult(success:error:))
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        taskForGetUserLocation()
    }
    
    private func handleListStudenResult(success: Bool, error: Error?) {
        self.buttonReload.isEnabled = true
        if success {
            self.results = OTMDataSource.getStudentList()
            self.addPoints()
        }else {
            showUpdateFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    private func addPoints() {
        self.mapView.removeAnnotations(self.mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for dictionary in results {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        self.mapView.addAnnotations(annotations)
    }
    
    func showUpdateFailure(message: String) {
        let alertVC = UIAlertController(title: "Get Student Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        OTMClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            //self.performSegue(withIdentifier: "segueToLogin", sender: nil)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MapStudentLocationViewController: MKMapViewDelegate {
    
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
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
