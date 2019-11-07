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
        userPassword.text = "crhonojp"
        userName.text = "jp.ragnarok@gmail.com"
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.setLoggingIn(true)
        }
        OTMClient.login(userName: userName.getText(), password: userPassword.getText(), completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func openURL(_ sender: UIButton) {
        if let url = URL(string: OTMClient.Endpoints.signUp) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    private func handleLoginResponse(success: Bool, error: Error?) {
        
        if success {
            //Go to next view
            OTMClient.getUserData(completion: handleUserResponse(success:error:))
        }else {
            DispatchQueue.main.async {
                self.setLoggingIn(false)
            }
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    
    private func handleUserResponse(success: Bool, error: Error?) {
        DispatchQueue.main.async {
            self.setLoggingIn(false)
        }
        if success {
            performSegue(withIdentifier: "segueToMainView", sender: nil)
        }else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    
    func setLoggingIn(_ loggingIn: Bool) {
        
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        
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
    
    @IBAction func unwindToLoginView(segue:UIStoryboardSegue) {
        print("delete session")
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
