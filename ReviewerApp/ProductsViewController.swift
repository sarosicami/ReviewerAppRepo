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
    var currentProductsList = [Product]()
    var product = Product()
    var selectedIndex = Int()
    var loggedUser = User()
    @IBOutlet weak var selectedBrandButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        // remove white padding on the left side of separator lines
        self.productsTableView.layoutMargins = UIEdgeInsetsZero
        self.productsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.productsTableView.tableFooterView = UIView()
        
        // get data from server
        let service = NetworkService ()
        service.delegate = self
        service.getProductsList()
        
        self.selectedIndex = 0
        
        let attributedString = NSMutableAttributedString(string:"")
        let attrs = [
            NSFontAttributeName:UIFont(
                name: "HelveticaNeue",
                size: 18.0)!,
            NSUnderlineStyleAttributeName : 1]
        let buttonTitleStr = NSMutableAttributedString(string:"All Brands", attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        self.selectedBrandButton.setAttributedTitle(attributedString, forState: .Normal)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.productsTableView.indexPathForSelectedRow != nil {
            let indexPath: NSIndexPath = self.productsTableView.indexPathForSelectedRow!
            self.productsTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
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
        
        self.currentProductsList = self.productsList
        
        dispatch_async(dispatch_get_main_queue(), {
            self.productsTableView.reloadData()
        })
    }
    
    func didFailToReceiveResponseWithMessage(failureMessage:NSString) {
        dispatch_async(dispatch_get_main_queue(), {
            self.stopActivityIndicator()
            let alertMessage = UIAlertController(title: "", message:failureMessage as String, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertMessage.addAction(defaultAction)
            self.presentViewController(alertMessage, animated: true, completion: nil)
        })
    }
    
    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentProductsList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            let cell = tableView.dequeueReusableCellWithIdentifier("ProductCell", forIndexPath: indexPath) as! ProductCell
            
            cell.layoutMargins = UIEdgeInsetsZero
            
            let product = self.currentProductsList[indexPath.row]
            cell.modelLabel.text = product.brand! + " " + product.model!
            cell.descriptionLabel.text = product.processor
            cell.tag = indexPath.row
            
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    // MARK: Controllers Navigation methods
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "BrandSegue") {
            let destinationVC = segue.destinationViewController as! BrandTableViewController
            destinationVC.productsList =  self.productsList
            destinationVC.selectedIndex = self.selectedIndex
        } else if (segue.identifier == "DetailsSegue") {
            let productCell = sender as! ProductCell
            let destinationVC = segue.destinationViewController as! ProductDetailsViewController
            destinationVC.product =  self.currentProductsList[productCell.tag]
            destinationVC.loggedUser = self.loggedUser
        } else if (segue.identifier == "SettingsSegue") {
            let destinationVC = segue.destinationViewController as! SettingsViewController
            destinationVC.loggedUser = self.loggedUser
        }
    }
    
    @IBAction func cancelOnChoosingBrand(unwindSegue:UIStoryboardSegue) {
        let sourceVC = unwindSegue.sourceViewController as! BrandTableViewController
        self.selectedIndex = sourceVC.selectedIndex
        
        let attributedString = NSMutableAttributedString(string:"")
        let attrs = [
            NSFontAttributeName:UIFont(
                name: "HelveticaNeue",
                size: 18.0)!,
            NSUnderlineStyleAttributeName : 1]
        let buttonTitleStr = NSMutableAttributedString(string:sourceVC.brands[sourceVC.selectedIndex], attributes:attrs)
        attributedString.appendAttributedString(buttonTitleStr)
        self.selectedBrandButton.setAttributedTitle(attributedString, forState: .Normal)
        self.currentProductsList = [Product]()
        
        if sourceVC.brands[sourceVC.selectedIndex] == "All Brands" {
            self.currentProductsList = self.productsList
        } else {
            for product in self.productsList {
                if product.brand == sourceVC.brands[sourceVC.selectedIndex] {
                    self.currentProductsList.append(product)
                }
            }
        }
        self.productsTableView.reloadData()
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

