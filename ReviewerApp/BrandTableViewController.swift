//
//  BrandTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class BrandTableViewController: UITableViewController {
    
    // MARK: properties declaration
    var productsList = [Product]()
    var brands = [String]()
    var selectedBrand = String()
    
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        tableView.layoutMargins = UIEdgeInsetsZero
        tableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        tableView.tableFooterView = UIView()
        
        brands.append("All Brands")
        
        var uniqueBrands = [String]()
        
        // populate brands list
        for product in productsList {
            uniqueBrands.append(product.brand!)
        }
        
        uniqueBrands = Array(Set(uniqueBrands))
        brands.appendContentsOf(uniqueBrands)
    }
    
    
    // MARK: TableView delegate & datasource methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brands.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("BrandCell", forIndexPath: indexPath)
            
            cell.layoutMargins = UIEdgeInsetsZero
            
            cell.textLabel?.text = brands[indexPath.row]
            
            let brand = brands[indexPath.row]
            
            if brand == self.selectedBrand {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            } else {
                cell.accessoryType = UITableViewCellAccessoryType.None
            }
            
            return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
        self.selectedBrand = brands[indexPath.row]
        dispatch_async(dispatch_get_main_queue(), {
            self.performSegueWithIdentifier("CancelBrandScreen", sender: self)
        })
    }
}