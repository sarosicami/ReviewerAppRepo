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
        let service = NetworkService ()
        service.delegate = self
        let userDict = ["username":usernameTextField.text!, "password":passwordTextField.text!]
        service.loginWithDict(userDict)
    }
    
    func didReceiveResponseForLogInWithDict(userDict:NSDictionary) {
        let user = User(dict:userDict)
        if user.id > 0 {
            dispatch_async(dispatch_get_main_queue(), {
                self.resetTextFieldsData()
                let productsViewControllerObj = self.storyboard?.instantiateViewControllerWithIdentifier("ProductsID") as? ProductsViewController
                self.navigationController?.pushViewController(productsViewControllerObj!, animated: true)
            })
        }
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
}
