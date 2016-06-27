//
//  AllReviewsViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class AllReviewsViewController : UIViewController, NetworkServiceDelegate {
    @IBOutlet weak var allReviewsTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: properties declaration
    var product = Product()
    var reviewsList = [Review]()
    
    let service = NetworkService ()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        product = tbvc.product
//        reviewsList = tbvc.reviewsList
        
        // remove white padding on the left side of separator lines
        allReviewsTableView.layoutMargins = UIEdgeInsetsZero
        allReviewsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        allReviewsTableView.tableFooterView = UIView()
        
        // configure table view to have cells with dynamic height
        allReviewsTableView.rowHeight = UITableViewAutomaticDimension
        allReviewsTableView.estimatedRowHeight = 44.0
        
        service.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        // get data from server
        self.showActivityIndicator()
        reviewsList = [Review]()
        service.getProductReviewsWithId(self.product.id!)
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = tabBarController  as! ReviewsTabBarController
        tbvc.title = "All Reviews"
    }
    
    func didReceiveResponseForGetProductReviewsWithID(reviewsDict:NSDictionary) {
        print("Info dictionary:\( reviewsDict )")
        
        if let reviews = reviewsDict.valueForKey("reviews") as? [NSDictionary] {
            for reviewDict in reviews {
                let review = Review(dict:reviewDict)
                self.reviewsList.append(review)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.stopActivityIndicator()
            self.allReviewsTableView.reloadData()
        })
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
    
    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReviewsCell", forIndexPath: indexPath)
            
            cell.layoutMargins = UIEdgeInsetsZero
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let review = self.reviewsList[indexPath.row]
            cell.textLabel?.text = review.body
            
            return cell
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

