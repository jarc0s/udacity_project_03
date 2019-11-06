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
    
    var results: [StudentInformation] = [StudentInformation]()
    
    override func viewDidLoad() {
        self.results = OTMDataSource.getStudentList()
    }
    
    
    @IBAction func reloadAction(_ sender: Any) {
        self.buttonReload.isEnabled = false
        OTMClient.getUsersLocation(completion: handleListStudenResult(success:error:))
    }
    
    private func handleListStudenResult(success: Bool, error: Error?) {
        self.buttonReload.isEnabled = true
        if success {
            self.results = OTMDataSource.getStudentList()
            self.tableView.reloadData()
        }else {
            print("sin datos de los estudiantes")
        }
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let studentInfo = self.results[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInformationCell")!
        
        cell.textLabel?.text = "\(studentInfo.firstName) \(studentInfo.lastName)"
        cell.detailTextLabel?.text = "\(studentInfo.mediaURL)"
        
        return cell
    }
    
}
