//
//  ProductDetailsViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/27/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ProductDetailsViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate, NetworkServiceDelegate {
    
    // MARK: properties declaration
    var product = Product()
    var reviewsList = [Review]()
    var loggedUser = User()
    
    @IBOutlet weak var productDetailsTableView: UITableView!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.productDetailsTableView.layoutMargins = UIEdgeInsetsZero
        self.productDetailsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.productDetailsTableView.tableFooterView = UIView()
        
        // get data from server
        let service = NetworkService ()
        service.delegate = self
        service.getProductReviewsWithId(self.product.id!)
        
        // configure table view to have cells with dynamic height
        self.productDetailsTableView.rowHeight = UITableViewAutomaticDimension
        self.productDetailsTableView.estimatedRowHeight = 44.0
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
            self.productDetailsTableView.reloadData()
        })

    }
    
    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 14
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductDetailCell", forIndexPath: indexPath)
            
            cell.layoutMargins = UIEdgeInsetsZero
            
            if indexPath.row == 0 {
                cell.textLabel?.text = "Brand:"
                cell.detailTextLabel?.text = self.product.brand
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 1 {
                cell.textLabel?.text = "Model:"
                cell.detailTextLabel?.text = self.product.model
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Processor:"
                cell.detailTextLabel?.text = self.product.processor
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Display:"
                cell.detailTextLabel?.text = self.product.display
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 4 {
                cell.textLabel?.text = "RAM memory:"
                cell.detailTextLabel?.text = self.product.RAMMemory
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 5 {
                cell.textLabel?.text = "Memory speed:"
                cell.detailTextLabel?.text = self.product.memorySpeed
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 6 {
                cell.textLabel?.text = "Hard Drive:"
                cell.detailTextLabel?.text = self.product.hardDrive
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 7 {
                cell.textLabel?.text = "Video Card:"
                cell.detailTextLabel?.text = self.product.videoCard
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 8 {
                cell.textLabel?.text = "Card Description:"
                cell.detailTextLabel?.text = self.product.cardDescription
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 9 {
                cell.textLabel?.text = "Battery Life:"
                cell.detailTextLabel?.text = self.product.batteryLife
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 10 {
                cell.textLabel?.text = "Weight:"
                cell.detailTextLabel?.text = self.product.weight
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 11 {
                cell.textLabel?.text = "Housing Material:"
                cell.detailTextLabel?.text = self.product.housingMaterial
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 12 {
                cell.textLabel?.text = "Color:"
                cell.detailTextLabel?.text = self.product.color
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            } else if indexPath.row == 13 {
                cell.textLabel?.text = "Operating System:"
                cell.detailTextLabel?.text = self.product.operatingSystem
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            
            return cell
    }
    
    
    // MARK: Controllers Navigation methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "ReviewsSegue") {
            let destinationVC = segue.destinationViewController as! ReviewsTabBarController
            destinationVC.reviewsList =  self.reviewsList
            destinationVC.loggedUser = self.loggedUser
            destinationVC.product = self.product
        }
    }
}

