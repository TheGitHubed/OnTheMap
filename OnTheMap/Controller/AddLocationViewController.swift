//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/9/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit
import UIKit
import CoreLocation

class AddLocationViewController: BaseViewController {
    
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var mediaLinkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        mediaLinkTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func FindLocationAction(_ sender: Any) {
        guard let location = locationTextField.text,
            let mediaLink = mediaLinkTextField.text,
            location != "", mediaLink != "" else {
                super.ShowAlertMessage(title: "Missing information", message: "Please fill both fields and try again")
                return
        }
        let studentLocation = StudentLocation(mapString: location, mediaURL: mediaLink)
        geocodeCoordinates(studentLocation)
    }
    
    private func geocodeCoordinates(_ studentLocation: StudentLocation) {
        let aiv = super.showActivityIndicatory(uiViewController: self)
        CLGeocoder().geocodeAddressString(studentLocation.mapString!) { (placeMarks, err) in
            guard let firstLocation = placeMarks?.first?.location else {
                super.ShowAlertMessage(title: "Message", message: "Location not found")
                aiv.stopAnimating()
                return }
            studentLocation.latitude = firstLocation.coordinate.latitude
            studentLocation.longitude = firstLocation.coordinate.longitude
            aiv.stopAnimating()
            self.performSegue(withIdentifier: "onMapSegue", sender: studentLocation)
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "onMapSegue", let vc = segue.destination as? ConfirmLocationViewController {
            vc.location = (sender as! StudentLocation)
        }
    }
    
    @IBAction func CancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
