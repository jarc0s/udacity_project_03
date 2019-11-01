//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by juan on 10/30/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation
import UIKit


class LoginViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var singupButton: UIButton!
    
    
    override func viewDidLoad() {
        activityIndicator.isHidden = true
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        setLoggingIn(true)
        OTMClient.login(userName: userName.getText(), password: userPassword.getText(), completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func openURL(_ sender: UIButton) {
        
    }
    
    private func handleLoginResponse(success: Bool, error: Error?) {
        setLoggingIn(false)
        if success {
            //Go to next view
            print("Succes")
            self.performSegue(withIdentifier: "segueToMainView", sender: nil)
        }else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        activityIndicator.isHidden = !loggingIn
        userName.isEnabled = !loggingIn
        userPassword.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        singupButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
}
