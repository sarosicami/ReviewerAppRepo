//
//  ReviewsSummaryViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ReviewsSummaryViewController: UIViewController, NetworkServiceDelegate {
    @IBOutlet weak var reviewsSummaryTableView: UITableView!
    
    // MARK: properties declaration
    var reviewsList = [Review]()
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var opinionsList = [Opinion]()
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        self.reviewsList = tbvc.reviewsList
        
        // remove white padding on the left side of separator lines
        reviewsSummaryTableView.layoutMargins = UIEdgeInsetsZero
        reviewsSummaryTableView.separatorInset = UIEdgeInsetsZero
        
        let service = NetworkService ()
        service.delegate = self
        
        for review in self.reviewsList {
            service.getReviewOpinionsWithId(review.id!)
        }
        
        //        service.getReviewOpinionsWithId(self.reviewsList[0].id!)
        
        
        // hide separator lines for empty cells
        reviewsSummaryTableView.tableFooterView = UIView()
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        tbvc.title = "Summary"
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
            self.reviewsSummaryTableView.reloadData()
        })
        
    }
    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.opinionsList.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
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

