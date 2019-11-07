//
//  TableStudentLocationViewController.swift
//  OnTheMap
//
//  Created by juan on 11/2/19.
//  Copyright © 2019 Arcos. All rights reserved.
//

import Foundation
import UIKit

class TableStudentLocationViewController: UITableViewController  {
    @IBOutlet weak var buttonReload: UIBarButtonItem!
    
    private var studenInformationListViewModel = StudentInformationModel()
    
    
    @IBAction func reloadAction(_ sender: Any) {
        buttonReload.isEnabled = false
        OTMClient.getUsersLocation(completion: handleListStudenResult(success:error:))
    }
    
    private func handleListStudenResult(success: Bool, error: Error?) {
        self.buttonReload.isEnabled = true
        if success {
            tableView.reloadData()
        }else {
            print("sin datos de los estudiantes")
        }
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
    
    //MARK: UITableViewDelegate
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studenInformationListViewModel.numberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentInfo = studenInformationListViewModel.modelAt(indexPath.row)
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInformationCell")!
        
        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
        cell.detailTextLabel?.text = "\(studentInfo.mediaURL)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = studenInformationListViewModel.modelAt(indexPath.row)
        let app = UIApplication.shared
        if let url = URL(string: studentInfo.mediaURL), app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        }else {
            print("Invalid input URL")
        }
    }
}
