//
//  AddLocationViewController.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//

import Foundation
import MapKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var addLocationTextField: UITextField!
    
    
    @IBOutlet weak var addMoreDetailTextField: UITextField!
    
    
    @IBOutlet weak var findOnMapButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var objectId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLocationTextField.delegate = self
        addMoreDetailTextField.delegate = self
        activityIndicator.hidesWhenStopped = true
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findNewLocation(_ sender: Any) {
        let newAddedLocation = addLocationTextField.text
        
        guard let url = URL(string: self.addMoreDetailTextField.text!), UIApplication.shared.canOpenURL(url) else {
            self.showAlert(message: "Please include 'http://' in your website adddress", title: "URL NOT VALID")
            return
        }

        geoCodePosition(newLocation: newAddedLocation ?? "")
    }
    
    private func geoCodePosition(newLocation: String) {
        self.activityIndicator.startAnimating()
        CLGeocoder().geocodeAddressString(newLocation) { (newMarker, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription, title: "Location Not Found")
                self.setLoading(false)
                print("Location not found.")
            } else {
                var location: CLLocation?
                
                if let marker = newMarker, marker.count > 0 {
                    location = marker.first?.location
                }
                
                if let location = location {
                    self.loadNewLocation(location.coordinate)
                } else {
                    self.showAlert(message: "Please try again later.", title: "Error")
                    self.setLoading(false)
                    print("Error")
                }
            }
        }
    }
    
    // Push to Final Add Location screen
    
    private func loadNewLocation(_ coordinate: CLLocationCoordinate2D) {
        let controller = storyboard?.instantiateViewController(withIdentifier: "NewLocationViewController") as! NewLocationViewController
        controller.studentInformation = buildStudentInfo(coordinate)
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    // Student info to be displayed on Final Add Location screen
    
    private func buildStudentInfo(_ coordinate: CLLocationCoordinate2D) -> StudentInformation {
        
        var studentInfo = [
            "uniqueKey": UdacityClientNetwork.Auth.key,
            "firstName": UdacityClientNetwork.Auth.firstName,
            "lastName": UdacityClientNetwork.Auth.lastName,
            "mapString": addLocationTextField.text!,
            "mediaURL": addMoreDetailTextField.text!,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude,
            ] as [String: AnyObject]
        
        if let objectId = objectId {
            studentInfo["objectId"] = objectId as AnyObject
            print(objectId)
        }

        return StudentInformation(studentInfo)

    }
    
    // handles activityView and Button actions
    func setLoading(_ loading: Bool) {
        if loading {
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.buttonEnabled(false, button: self.findOnMapButton)
            }
        } else {
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.buttonEnabled(true, button: self.findOnMapButton)
            }
        }
        DispatchQueue.main.async {
            self.addLocationTextField.isEnabled = !loading
            self.addMoreDetailTextField.isEnabled = !loading
            self.findOnMapButton.isEnabled = !loading
        }
    }
    
    
    // text field delegates
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == addLocationTextField {
            let currentText = addLocationTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            _ = currentText.replacingCharacters(in: stringRange, with: string)
        }
        
        if textField == addMoreDetailTextField {
            let currentText = addMoreDetailTextField.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            _ = currentText.replacingCharacters(in: stringRange, with: string)
        }
        
        return true
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        buttonEnabled(false, button: findOnMapButton)
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            
        }
        return true
    }
    
}
