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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var findButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.isHidden = true
    }
    
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
        DispatchQueue.main.async {
            self.setFindingIn(true)
        }
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationName.getText()) { (placemarks, error) in
            DispatchQueue.main.async {
                self.setFindingIn(false)
            }
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    self.showLocationFailure(message: "Location not found")
                    return
            }
            
            // Use your location
            self.performSegue(withIdentifier: "segueLocationMap", sender: location)
        }
    }
    
    func showLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func closeView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func unwindToTabBarController(segue:UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    func setFindingIn(_ findingIn: Bool) {
        
        findingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
        activityIndicator.isHidden = !findingIn
        locationName.isEnabled = !findingIn
        urlMedia.isEnabled = !findingIn
        cancelButton.isEnabled = !findingIn
        findButton.isEnabled = !findingIn
    }
    
}

extension FindLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
