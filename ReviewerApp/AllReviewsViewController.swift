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
    
    // MARK: properties declaration
    var reviewsList = [Review]()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        tbvc.title = "All Reviews"
        self.reviewsList = tbvc.reviewsList
        
        // remove white padding on the left side of separator lines
        allReviewsTableView.layoutMargins = UIEdgeInsetsZero
        allReviewsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        allReviewsTableView.tableFooterView = UIView()
        
        // configure table view to have cells with dynamic height
        allReviewsTableView.rowHeight = UITableViewAutomaticDimension
        allReviewsTableView.estimatedRowHeight = 44.0
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        tbvc.title = "All Reviews"
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
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
}

