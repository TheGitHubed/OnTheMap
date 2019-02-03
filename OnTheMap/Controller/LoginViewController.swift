//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Ahmed Sengab on 1/7/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController{
    
    
    @IBOutlet weak var eMailTextField: UITextField!
    @IBOutlet weak var PassWordTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eMailTextField.delegate = self
        PassWordTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    @IBAction func LoginAction(_ sender: UIButton) {
        guard let email = eMailTextField.text,!email.isEmpty, let passsword = PassWordTextField.text ,!passsword.isEmpty else{
            super.ShowAlertMessage(title: "Attention", message: "Please Enter Email and Password")
            return
        }
        let aiv = super.showActivityIndicatory(uiViewController: self)
        Client.Login(username: email, password: passsword){error in
            if let error = error
            {
                super.ShowAlertMessage(title: "Error", message: error )
                aiv.stopAnimating()
            }
            else
            {
                aiv.stopAnimating()
                self.performSegue(withIdentifier: "loginSegue", sender: nil)}
        }
    }
    
    @IBAction func SingUpAction(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
    
    
}
