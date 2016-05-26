//
//  ReviewsSummaryTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsSummaryTableViewController: UITableViewController {
    
    @IBOutlet var reviewsSummaryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.reviewsSummaryTableView.layoutMargins = UIEdgeInsetsZero
        self.reviewsSummaryTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.reviewsSummaryTableView.tableFooterView = UIView()
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            var cellIdentifier = ""
            if indexPath.row == 0 {
                cellIdentifier = "SeeReviewsListCell"
            } else if indexPath.row == 1 {
                cellIdentifier = "PolarityCell"
            } else {
                cellIdentifier = "AspectCell"
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
    }
    
    @IBAction func cancelOnSeeingReviewsList(unwindSegue:UIStoryboardSegue) {
        
    }
}
