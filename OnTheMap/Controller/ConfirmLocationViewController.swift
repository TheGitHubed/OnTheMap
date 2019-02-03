//
//  ConfirmLocationViewController.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class ConfirmLocationViewController: BaseViewController ,MKMapViewDelegate {
    
    var location: StudentLocation?
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        SetMapPin()
    }
    @IBAction func FinishAction(_ sender: Any) {
        location!.uniqueKey = LocationFactory.shared.userSession.UserID
        location!.firstName = LocationFactory.shared.userSession.firstName
        location!.lastName = LocationFactory.shared.userSession.lastName
        
        Client.SaveLocation(self.location!) { err  in
            guard err == nil else {
                super.ShowAlertMessage(title: "Error", message: err!)
                return
            }
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func SetMapPin(){
        guard let location = location else { return }
        let lat = CLLocationDegrees(location.latitude!)
        let long = CLLocationDegrees(location.longitude!)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle!,
                let url = URL(string: toOpen), app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
