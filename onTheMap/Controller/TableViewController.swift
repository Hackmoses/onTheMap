//
//  TableViewController.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/16/22.
//

import Foundation
import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet var studentTableView: UITableView!
    
    var students = StudentsData().students
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudentsList()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return students.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentviewcell", for: indexPath) as! StudentTableViewCell
        let student = students[indexPath.row]
        cell.firstName.text = student.firstName
        cell.lastName.text = student.lastName
        cell.detailTextLabel?.text = student.mediaURL
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = students[indexPath.row]
        openLink(student.mediaURL ?? "")
    }

    @IBAction func logout(_ sender: UIBarButtonItem) {
        
        UdacityClientNetwork.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                
            }
        }
    }
    
    
    @IBAction func refreshList(_ sender: UIBarButtonItem) {
        getStudentsList()
    }
    
    @IBAction func addLocation(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: sender)
    }
    
    func getStudentsList() {
        
        UdacityClientNetwork.getStudentLocations() {students, error in
            self.students = students ?? []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
    }
    
}
