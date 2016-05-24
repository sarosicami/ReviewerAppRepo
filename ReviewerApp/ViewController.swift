//
//  ViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/7/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkServiceDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let service = NetworkService ()
        service.delegate = self
//        service.getProductsList()
//        service.getProductWithId(2)
        service.getProductReviewsWithId(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponseForGetProductsList(info:NSDictionary) {
        print("Info dictionary:\( info )")
    }
    
    func didReceiveResponseForGetProductWithID(info:NSDictionary) {
        print("Info dictionary:\( info )")
    }
    
    func didReceiveResponseForGetProductReviewsWithID(info:NSDictionary) {
        print("Info dictionary:\( info )")
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }

}

