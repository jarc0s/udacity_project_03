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
    
    private var studenInformationListViewModel = StudentInformationModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskForGetUserLocation()
    }
    
    private func taskForGetUserLocation() {
        buttonReload.isEnabled = false
        OTMClient.getUsersLocation(completion: handleListStudenResult(success:error:))
    }
    
    @IBAction func reloadAction(_ sender: Any) {
        taskForGetUserLocation()
    }
    
    private func handleListStudenResult(success: Bool, error: Error?) {
        buttonReload.isEnabled = true
        if success {
            addPoints()
        }else {
            showUpdateFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    private func addPoints() {
        mapView.removeAnnotations(mapView.annotations)
        var annotations = [MKPointAnnotation]()
        for dictionary in studenInformationListViewModel.studentInformations {
            
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
        
        mapView.addAnnotations(annotations)
    }
    
    func showUpdateFailure(message: String) {
        let alertVC = UIAlertController(title: "Get Student Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutAction(_ sender: UIBarButtonItem) {
        OTMClient.logout(completion: handleLogoutResponse(success:error:))
    }
    
    func handleLogoutResponse(success: Bool, error: Error?) {
        if success {
            dismiss(animated: true, completion: nil)
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
            if let mediaUrl = view.annotation?.subtitle, let url = URL(string: mediaUrl ?? ""), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
