//
//  BaseViewController.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/8/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController ,UITextFieldDelegate {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func AddLocationAction(_ sender: Any) {
        let navController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddLocationNavigation") as! UINavigationController
        present(navController, animated: true, completion: nil)
    }
    
  
    @IBAction func RefreshLocationsAction(_ sender: UIBarButtonItem) {
        Client.GetLocations(){error in
            if let error = error
            {
                self.ShowAlertMessage(title: "Error", message: error )
                return
            }
            if  sender.tag == 1 {
                (self as! MapViewController).SetMapPins()
            }
            else  {
                
                (self as! TableViewController).locationsTableView.reloadData()
            }
        }
    }
    
    @IBAction func LogOutAction(_ sender: Any) {
        Client.Logout(){error in
            if let error = error
            {
                self.ShowAlertMessage(title: "Error", message: error )
            }
            else
            {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    public func ShowAlertMessage(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    
   
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Keyboard Move
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        guard let textField = UIResponder.currentFirstResponder as? UITextField else { return }
        let keyboardHeight = getKeyboardHeight(notification)

        // kbMinY is minY of the keyboard rect
        let kbMinY = (view.frame.height-keyboardHeight)
        
        // Check if the current textfield is covered by the keyboard
        var bottomCenter = textField.center
        bottomCenter.y += textField.frame.height/2
        let textFieldMaxY = textField.convert(bottomCenter, to: self.view).y
        if textFieldMaxY - kbMinY > 0 {
            // Displace the view's origin by the difference between kb's minY and textfield's maxY
            view.frame.origin.y = -(textFieldMaxY - kbMinY)
        }
  
    }
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

extension UIResponder {
    private static weak var _currentFirstResponder: UIResponder?
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    @objc func findFirstResponder(_ sender: Any) {
        UIResponder._currentFirstResponder = self
    }
    
    func showActivityIndicatory(uiViewController: UIViewController)-> UIActivityIndicatorView {
        let ai = UIActivityIndicatorView(style: .gray)
        uiViewController.view.addSubview(ai)
        uiViewController.view.bringSubviewToFront(ai)
        ai.center = uiViewController.view.center
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }
}
