//
//  ReviewsListTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsListTableViewController : UITableViewController, NetworkServiceDelegate {
    
    // MARK: properties declaration
    var product = Product()
    var reviewsList = [Review]()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        tableView.tableFooterView = UIView()
        
        // get data from server
        let service = NetworkService ()
        service.delegate = self
        service.getProductReviewsWithId(self.product.id!)
        
        // configure table view to have cells with dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
    }
    
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForGetProductReviewsWithID(reviewsDict:NSDictionary) {
        print("Info dictionary:\( reviewsDict )")
        
        if let reviews = reviewsDict.valueForKey("reviews") as? [NSDictionary] {
            for reviewDict in reviews {
                let review = Review(dict:reviewDict)
                self.reviewsList.append(review)
            }
        }

        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })

    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
    
    
    // MARK: TableView delegate & datasource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.reviewsList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReviewsCell", forIndexPath: indexPath)
            
            cell.layoutMargins = UIEdgeInsetsZero
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            
            let review = self.reviewsList[indexPath.row]
            cell.textLabel?.text = review.body
            
            return cell
    }
}
