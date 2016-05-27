//
//  ProductsViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/7/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class ProductsViewController: UIViewController, NetworkServiceDelegate, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: properties declaration
    @IBOutlet weak var productsTableView: UITableView!
    var productsList = [Product]()
    var product = Product()
    var selectedBrand = String()
    @IBOutlet weak var selectedBrandButton: UIButton!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.productsTableView.layoutMargins = UIEdgeInsetsZero
        self.productsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.productsTableView.tableFooterView = UIView()
        
        // get data from server
        let service = NetworkService ()
        service.delegate = self
        service.getProductsList()
        
        self.selectedBrand = "All Brands"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Network-Service delegate methods
    func didReceiveResponseForGetProductsList(productsDict:NSDictionary) {
        print("Info dictionary:\( productsDict )")
        
        if let products = productsDict.valueForKey("products") as? [NSDictionary] {
            for productDict in products {
                let product = Product(dict:productDict)
                self.productsList.append(product)
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.productsTableView.reloadData()
        })
    }
    
    func didFailToReceiveResponseWithMessage(message:NSString) {
        print(message)
    }
    
    
    // MARK: TableView delegate & datasource methods
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
    
    
    // MARK: Controllers Navigation methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let nc = segue.destinationViewController as! UINavigationController
        if (segue.identifier == "BrandSegue") {
            let destinationVC = nc.topViewController as! BrandTableViewController
            destinationVC.productsList =  self.productsList
            destinationVC.selectedBrand = self.selectedBrand
        } else if (segue.identifier == "DetailsSegue") {
            let productCell = sender as! ProductCell
            let destinationVC = nc.topViewController as! ProductDetailsViewController
            destinationVC.product =  self.productsList[productCell.tag]
        }
    }
    
    @IBAction func cancelOnChoosingBrand(unwindSegue:UIStoryboardSegue) {
        let sourceVC = unwindSegue.sourceViewController as! BrandTableViewController
        self.selectedBrand = sourceVC.selectedBrand
        self.selectedBrandButton.titleLabel!.text = self.selectedBrand
    }
    @IBAction func cancelOnSeeingDetails(unwindSegue:UIStoryboardSegue) {
        
    }
}

