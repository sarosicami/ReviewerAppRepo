//
//  AddReviewViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class AddReviewViewController : UIViewController, NetworkServiceDelegate {
    
    var loggedUser = User()
    var product = Product()
    @IBOutlet weak var reviewTextView: UITextView!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        self.loggedUser = tbvc.loggedUser
        self.product = tbvc.product
        
        reviewTextView.autocorrectionType = UITextAutocorrectionType.No;
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        tbvc.title = "Add Review"
    }
    
   
    @IBAction func onPostReview(sender: AnyObject) {
        let service = NetworkService ()
        service.delegate = self
        let stringUserId = String(loggedUser.id!)
        print(stringUserId)
        let stringProductId = String(product.id!)
        let addReviewDict = ["user_id":stringUserId, "product_id":stringProductId, "review_text":reviewTextView.text]
        service.addReviewWithDict(addReviewDict)
    }
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForAddReviewWithDict(info:NSDictionary) {
        print(info)
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
}
