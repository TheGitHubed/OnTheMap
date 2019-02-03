//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/8/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BaseViewController,MKMapViewDelegate  {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        Client.GetLocations(){error in
            if let error = error
            {
                self.ShowAlertMessage(title: "Error", message: error )
                return
            }
            self.SetMapPins()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.SetMapPins()
    }
    
    
    func SetMapPins(){
        let studentLocations =  LocationFactory.shared.studentLocations
        var annotations = [MKPointAnnotation]()
        
        for location in studentLocations {
            guard let latitude = location.latitude, let longitude = location.longitude else { continue }
            let lat = CLLocationDegrees(latitude)
            let long = CLLocationDegrees(longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(location.firstName ?? "") \(location.lastName ?? "")"
            annotation.subtitle = location.mediaURL
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
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
            if var toOpen = view.annotation?.subtitle!{
                if !toOpen.contains("http")
                {
                    toOpen = "http://" + toOpen
                }
                if  let url = URL(string: toOpen), app.canOpenURL(url){
                    app.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
}
