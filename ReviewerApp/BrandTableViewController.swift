//
//  BrandTableViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class BrandTableViewController: UITableViewController {
    
    @IBOutlet var brandTableView: UITableView!
    var productsList = [Product]()
    var brands = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.brandTableView.layoutMargins = UIEdgeInsetsZero
        self.brandTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.brandTableView.tableFooterView = UIView()
        
        // populate brands list
        for product in productsList {
            brands.append(product.brand!)
        }
        
        brands = Array(Set(brands))
        
    }

    
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
            return cell
    }
}