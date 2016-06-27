//
//  CreateAccountViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/11/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController, UITextFieldDelegate, NetworkServiceDelegate  {
    
    // MARK: properties declaration
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set textfields delegate
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        countryTextField.delegate = self
        
        // customize textfields
        usernameTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        usernameTextField.layer.borderWidth = 0.3;
        
        passwordTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        passwordTextField.layer.borderWidth = 0.3;
        
        confirmPasswordTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        confirmPasswordTextField.layer.borderWidth = 0.3;
        
        emailTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        emailTextField.layer.borderWidth = 0.3;
        
        countryTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        countryTextField.layer.borderWidth = 0.3;
        
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No
        confirmPasswordTextField.autocorrectionType = UITextAutocorrectionType.No
        emailTextField.autocorrectionType = UITextAutocorrectionType.No
        countryTextField.autocorrectionType = UITextAutocorrectionType.No
    }
    
    // MARK: UITextField Delegates
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 {
            if range.length == 0 {
                textField.font = UIFont (name: "HelveticaNeue", size: 15)
            } else if range.length == 1 {
                textField.font = UIFont (name: "HelveticaNeue-Italic", size: 15)
            }
        }
        return true;
    }
    
    // MARK: Action methods
    @IBAction func onCreateAccount(sender: AnyObject) {
        // send data to server
        if loginInfoProvided() {
            self.showActivityIndicator()
            let service = NetworkService ()
            service.delegate = self
            let addUserDict = ["username":usernameTextField.text!, "password":passwordTextField.text!, "email":emailTextField.text!, "country":countryTextField.text!]
            service.addUserWithDict(addUserDict)
        }
    }
    
    // MARK: Utils methods
    func resetTextFieldsData() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        confirmPasswordTextField.text = ""
        emailTextField.text = ""
        countryTextField.text = ""
    }
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForAddUserWithDict(info:NSDictionary) {
        let errorMessage = info.valueForKey("error") as? String
        if !errorMessage!.isEmpty {
            dispatch_async(dispatch_get_main_queue(), {
                self.stopActivityIndicator()
                let alertMessage = UIAlertController(title: "", message:errorMessage, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertMessage.addAction(defaultAction)
                self.presentViewController(alertMessage, animated: true, completion: nil)
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.stopActivityIndicator()
                let alertMessage = UIAlertController(title: "Your account has been successfully created!", message:errorMessage, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertMessage.addAction(defaultAction)
                self.presentViewController(alertMessage, animated: true, completion: nil)
                self.resetTextFieldsData()
            })
        }
    }
    func didFailToReceiveResponseWithMessage(failureMessage:NSString) {
        dispatch_async(dispatch_get_main_queue(), {
            self.stopActivityIndicator()
            let alertMessage = UIAlertController(title: "", message:failureMessage as String, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
    }
    
    func loginInfoProvided()->Bool {
        if usernameTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please provide a username", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if passwordTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please provide a password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if confirmPasswordTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please confirm your password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if passwordTextField.text != confirmPasswordTextField.text {
            let alertMessage = UIAlertController(title: "", message: "Password and confirmation password do not match", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if emailTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please provide an eMail address", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if countryTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please provide your country", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        }
        
        return true
    }
    
    func showActivityIndicator() {
        activityIndicator.hidden = false;
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidden = true;
    }

}

