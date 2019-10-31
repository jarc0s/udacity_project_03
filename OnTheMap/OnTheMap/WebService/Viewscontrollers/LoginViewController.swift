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
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        OTMClient.login(userName: userName.getText(), password: userPassword.getText(), completion: handleLoginResponse(success:error:))
    }
    
    @IBAction func openURL(_ sender: UIButton) {
        
    }
    
    private func handleLoginResponse(success: Bool, error: Error?) {
        
    }
}
