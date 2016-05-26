//
//  ReviewsListTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsListTableViewController : UITableViewController {
    
    @IBOutlet var reviewsListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.reviewsListTableView.layoutMargins = UIEdgeInsetsZero
        self.reviewsListTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.reviewsListTableView.tableFooterView = UIView()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ReviewsCell", forIndexPath: indexPath)
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
    }
}
