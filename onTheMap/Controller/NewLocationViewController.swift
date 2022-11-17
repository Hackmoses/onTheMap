//
//  NewLocationViewController.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//

import UIKit
import MapKit

class NewLocationViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var submitLocationButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    var studentInformation: StudentInformation?
    
    override func viewDidLoad() {
        self.activityIndicator.isHidden = true
        super.viewDidLoad()
        mapView.delegate = self

        if let studentLocation = studentInformation {
            let studentLocation = Location(
                objectId: studentLocation.objectId ?? "",
                uniqueKey: studentLocation.uniqueKey,
                firstName: studentLocation.firstName,
                lastName: studentLocation.lastName,
                mapString: studentLocation.mapString,
                mediaURL: studentLocation.mediaURL,
                latitude: studentLocation.latitude,
                longitude: studentLocation.longitude,
                createdAt: studentLocation.createdAt ?? "",
                updatedAt: studentLocation.updatedAt ?? ""
            )
            showLocations(location: studentLocation)
        }
    }
    
    private func showLocations(location: Location) {
        mapView.removeAnnotations(mapView.annotations)
        if let coordinate = extractCoordinate(location: location) {
            let annotation = MKPointAnnotation()
            annotation.title = location.firstName
            annotation.subtitle = location.mediaURL ?? ""
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    private func extractCoordinate(location: Location) -> CLLocationCoordinate2D? {
        if let lat = location.latitude, let long = location.longitude {
            return CLLocationCoordinate2DMake(lat, long)
        }
        return nil
    }
    
    @IBAction func SubmitButtonPressed(_ sender: Any) {
        if let studentLocation = studentInformation {
            if UdacityClientNetwork.Auth.objectId == "" {
                UdacityClientNetwork.addStudentLocation(information: studentLocation) { (success, error) in
                    if success {
                        DispatchQueue.main.async {
                            self.dismiss(animated: true, completion: nil)
                            print("successfully updated")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                            print("data not correctly parsed")
                        }
                    }
                }
                
            } else {
                let alertVC = UIAlertController(title: "", message: "This student has already posted a location. Would you like to overwrite this location?", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (action: UIAlertAction) in
                    UdacityClientNetwork.updateStudentLocation(information: studentLocation) { (success, error) in
                        if success {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.showAlert(message: error?.localizedDescription ?? "", title: "Error")
                            }
                        }
                    }
                }))
                
                alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
                    DispatchQueue.main.async {
                        alertVC.dismiss(animated: true, completion: nil)
                    }
                }))
                
                self.present(alertVC, animated: true)
            }
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
}
