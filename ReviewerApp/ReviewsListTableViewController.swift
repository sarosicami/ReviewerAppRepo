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
    var reviewsList = [Review]()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        tableView.tableFooterView = UIView()
        
        // configure table view to have cells with dynamic height
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44.0
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
