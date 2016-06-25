//
//  AddReviewViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class AddReviewViewController : UIViewController, NetworkServiceDelegate {
    
    @IBOutlet weak var addReviewTableView: UITableView!
    @IBOutlet weak var arrowImageView: UIImageView!
    var loggedUser = User()
    var product = Product()
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.addReviewTableView.layoutMargins = UIEdgeInsetsZero
        self.addReviewTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.addReviewTableView.tableFooterView = UIView()
        
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
    
    @IBAction func onDisplaySummary(sender: AnyObject) {
        arrowImageView.image = UIImage(named: "arrow_up")
        let service = NetworkService ()
        service.delegate = self
        let stringUserId = String(loggedUser.id!)
        let stringProductId = String(product.id!)
        let reviewSummaryDict = ["user_id":stringUserId, "product_id":stringProductId, "review_text":reviewTextView.text]
        service.getReviewSummaryWithDict(reviewSummaryDict)
    }
    
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForAddReviewWithDict(info:NSDictionary) {
        print(info)
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
    
    func didReceiveResponseForNewAddedReviewSummaryWithDict(info:NSDictionary) {
        
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
