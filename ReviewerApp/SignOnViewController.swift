//
//  SignOnViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/11/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit
import QuartzCore

class SignOnViewController: UIViewController, UITextFieldDelegate, NetworkServiceDelegate  {
    
    // MARK: properties declaration
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set textfields delegate
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        // customize textfields
        usernameTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        usernameTextField.layer.borderWidth = 0.3;
        
        passwordTextField.layer.borderColor = UIColor(red:215.0/255.0, green:215.0/255.0, blue:215.0/255.0, alpha:1.0).CGColor
        passwordTextField.layer.borderWidth = 0.3;
        
        usernameTextField.autocorrectionType = UITextAutocorrectionType.No
        passwordTextField.autocorrectionType = UITextAutocorrectionType.No
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
    
    // MARK: Utils methods
    func resetTextFieldsData() {
        usernameTextField.text = ""
        passwordTextField.text = ""
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    @IBAction func onLogIn(sender: AnyObject) {
        // log into app
        if loginInfoProvided() {
            self.showActivityIndicator()
            let service = NetworkService ()
            service.delegate = self
            let userDict = ["username":usernameTextField.text!, "password":passwordTextField.text!]
            service.loginWithDict(userDict)
        }
    }
    
    func didReceiveResponseForLogInWithDict(userDict:NSDictionary) {
        let errorMessage = userDict.valueForKey("error") as? String
        if !errorMessage!.isEmpty {
            dispatch_async(dispatch_get_main_queue(), {
            self.stopActivityIndicator()
            let alertMessage = UIAlertController(title: "", message:errorMessage, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            self.presentViewController(alertMessage, animated: true, completion: nil)
            })
        } else {
            let user = User(dict:userDict)
            if user.id > 0 {
                dispatch_async(dispatch_get_main_queue(), {
                    self.stopActivityIndicator()
                    self.resetTextFieldsData()
                    let productsViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("ProductsID") as? ProductsViewController
                    productsViewControllerObj!.loggedUser = user
                    self.navigationController?.pushViewController(productsViewControllerObj!, animated: true)
                })
            }
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
        if usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty{
            let alertMessage = UIAlertController(title: "", message: "Please provide a username and a password", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if usernameTextField.text!.isEmpty && !passwordTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please provide a username", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            presentViewController(alertMessage, animated: true, completion: nil)
            return false
        } else if !usernameTextField.text!.isEmpty && passwordTextField.text!.isEmpty {
            let alertMessage = UIAlertController(title: "", message: "Please provide a password", preferredStyle: .Alert)
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
