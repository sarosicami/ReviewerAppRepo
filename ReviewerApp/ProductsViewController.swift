//
//  ProductsViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/7/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, NetworkServiceDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var productsTableView: UITableView!
    
    var productsList = [Product]()
    
    var product = Product()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.productsTableView.layoutMargins = UIEdgeInsetsZero
        self.productsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.productsTableView.tableFooterView = UIView()
        
        let service = NetworkService ()
        service.delegate = self
        service.getProductsList()
//        service.getProductWithId(2)
//        service.getProductReviewsWithId(2)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didReceiveResponseForGetProductsList(productsDict:NSDictionary) {
        print("Info dictionary:\( productsDict )")
        if let products = productsDict.valueForKey("products") as? [NSDictionary] {
            for productDict in products {
                let product = Product(dict:productDict)
                self.productsList.append(product)
            }
        }
        print(self.productsList.count)
        dispatch_async(dispatch_get_main_queue(), {
            self.productsTableView.reloadData()
        })
    }
    
    func didReceiveResponseForGetProductWithID(info:NSDictionary) {
        print("Info dictionary:\( info )")
    }
    
    func didReceiveResponseForGetProductReviewsWithID(info:NSDictionary) {
        print("Info dictionary:\( info )")
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! ProductCell
            cell.layoutMargins = UIEdgeInsetsZero
            
            let product = self.productsList[indexPath.row]
            cell.modelLabel.text = product.model
            cell.descriptionLabel.text = product.processor
            cell.tag = indexPath.row
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let nc = segue.destinationViewController as! UINavigationController
        if (segue.identifier == "BrandSegue") {
            let destinationVC = nc.topViewController as! BrandTableViewController
            destinationVC.productsList =  self.productsList
        } else if (segue.identifier == "DetailsSegue") {
            let productCell = sender as! ProductCell
            let destinationVC = nc.topViewController as! ProductDetailsTableViewController
            destinationVC.product =  self.productsList[productCell.tag]
        }
    }
    
    @IBAction func cancelOnChoosingBrand(unwindSegue:UIStoryboardSegue) {
        
    }
    @IBAction func cancelOnSeeingDetails(unwindSegue:UIStoryboardSegue) {
        
    }
}

