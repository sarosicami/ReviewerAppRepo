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
        let service = NetworkService ()
        service.delegate = self
        let addUserDict = ["username":usernameTextField.text!, "password":passwordTextField.text!, "email":emailTextField.text!, "country":countryTextField.text!]
        service.addUserWithDict(addUserDict)
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
        dispatch_async(dispatch_get_main_queue(), {
             self.resetTextFieldsData()
        })
    }
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
}

