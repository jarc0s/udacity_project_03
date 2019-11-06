//
//  FindLocationViewController.swift
//  OnTheMap
//
//  Created by juan on 11/2/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class FindLocationViewController: UIViewController {

    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var urlMedia: UITextField!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueLocationMap" {
            let addLocationVC = segue.destination as! AddLocationViewController
            guard let location = sender as? CLLocation else { return }
            addLocationVC.location = location
            addLocationVC.mediaURL = urlMedia.getText()
            addLocationVC.mapString = locationName.getText()
        }
    }
    
    @IBAction func findAction(_ sender: Any) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationName.getText()) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("location not found")
                    self.showLocationFailure(message: "Location not found")
                    return
            }
            
            // Use your location
            print("Go to map: \(location.coordinate.latitude) - \(location.coordinate.longitude)")
            self.performSegue(withIdentifier: "segueLocationMap", sender: location)
        }
    }
    
    func showLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToTabBarController(segue:UIStoryboardSegue) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
