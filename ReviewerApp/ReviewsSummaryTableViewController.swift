//
//  ReviewsSummaryTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsSummaryTableViewController: UITableViewController, NetworkServiceDelegate {
    
    // MARK: properties declaration
    var reviewsList = [Review]()
    var opinionsList = [Opinion]()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        let service = NetworkService ()
        service.delegate = self
        
        for review in self.reviewsList {
            service.getReviewOpinionsWithId(review.id!)
        }
        
//        service.getReviewOpinionsWithId(self.reviewsList[0].id!)
        
        
        // hide separator lines for empty cells
        tableView.tableFooterView = UIView()
    }
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForGetReviewOpinionsWithID(opinionsDict:NSDictionary) {
        print("Info dictionary:\( opinionsDict )")
        
        if let opinions = opinionsDict.valueForKey("opinions") as? [NSDictionary] {
            for opinionDict in opinions {
                let opinion = Opinion(dict:opinionDict)
                self.opinionsList.append(opinion)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })

    }
    
    // MARK: TableView delegate & datasource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.opinionsList.count + 1
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
            
            if self.opinionsList.count > 0 && indexPath.row > 0 {
                let opinion = self.opinionsList[indexPath.row - 1]
                
                cell.textLabel?.text = opinion.aspect
                cell.detailTextLabel?.text = opinion.category
            }
            
            cell.layoutMargins = UIEdgeInsetsZero
            
            return cell
    }
}
