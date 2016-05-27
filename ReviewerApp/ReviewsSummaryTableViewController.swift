//
//  ReviewsSummaryTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsSummaryTableViewController: UITableViewController {
    
    // MARK: properties declaration
    var product = Product()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        tableView.tableFooterView = UIView()
    }
    
    
    // MARK: TableView delegate & datasource methods
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
                cellIdentifier = "PolarityCell"
            } else {
                cellIdentifier = "AspectCell"
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            
            cell.layoutMargins = UIEdgeInsetsZero
            
            return cell
    }
}
