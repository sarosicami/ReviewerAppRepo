//
//  ProductDetailsTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ProductDetailsTableViewController: UITableViewController {
    
    @IBOutlet var productDetailsTableView: UITableView!
    var product = Product()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.productDetailsTableView.layoutMargins = UIEdgeInsetsZero
        self.productDetailsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.productDetailsTableView.tableFooterView = UIView()
    }

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            var cellIdentifier = ""
            if indexPath.row == 0 {
                cellIdentifier = "SeeReviewsSummaryCell"
            } else {
                cellIdentifier = "ProductDetailCell"
            }
            let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
            cell.layoutMargins = UIEdgeInsetsZero
            if indexPath.row == 1 {
                cell.textLabel?.text = "Brand:"
                cell.detailTextLabel?.text = self.product.brand
            } else if indexPath.row == 2 {
                cell.textLabel?.text = "Model:"
                cell.detailTextLabel?.text = self.product.model
            } else if indexPath.row == 3 {
                cell.textLabel?.text = "Processor:"
                cell.detailTextLabel?.text = self.product.processor
            } else if indexPath.row == 4 {
                cell.textLabel?.text = "Display:"
                cell.detailTextLabel?.text = self.product.display
            } else if indexPath.row == 5 {
                cell.textLabel?.text = "RAM memory:"
                cell.detailTextLabel?.text = self.product.RAMMemory
            } else if indexPath.row == 6 {
                cell.textLabel?.text = "Memory speed:"
                cell.detailTextLabel?.text = String(self.product.memorySpeed!)
            } else if indexPath.row == 7 {
                cell.textLabel?.text = "Hard Drive:"
                cell.detailTextLabel?.text = String(self.product.hardDrive!)
            } else if indexPath.row == 8 {
                cell.textLabel?.text = "Video Card:"
                cell.detailTextLabel?.text = self.product.videoCard
            } else if indexPath.row == 9 {
                cell.textLabel?.text = "Card Description:"
                cell.detailTextLabel?.text = self.product.cardDescription
            } else if indexPath.row == 10 {
                cell.textLabel?.text = "Battery Life:"
                cell.detailTextLabel?.text = String(self.product.batteryLife!)
            } else if indexPath.row == 11 {
                cell.textLabel?.text = "Weight:"
                cell.detailTextLabel?.text = String(self.product.weight!)
            } else if indexPath.row == 12 {
                cell.textLabel?.text = "Housing Material:"
                cell.detailTextLabel?.text = self.product.housingMaterial
            } else if indexPath.row == 13 {
                cell.textLabel?.text = "Color:"
                cell.detailTextLabel?.text = self.product.color
            } else if indexPath.row == 14 {
                cell.textLabel?.text = "Operating System:"
                cell.detailTextLabel?.text = self.product.operatingSystem
            }
            return cell
    }
    
    @IBAction func cancelOnSeeingReviewsSummary(unwindSegue:UIStoryboardSegue) {
        
    }
}
