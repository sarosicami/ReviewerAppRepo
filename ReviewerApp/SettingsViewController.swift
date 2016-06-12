//
//  SettingsViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/11/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//


import UIKit

class SettingsViewController:  UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var settingsTableView: UITableView!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove white padding on the left side of separator lines
        self.settingsTableView.layoutMargins = UIEdgeInsetsZero
        self.settingsTableView.separatorInset = UIEdgeInsetsZero
        
        // hide separator lines for empty cells
        self.settingsTableView.tableFooterView = UIView()
    }

    
    // MARK: TableView delegate & datasource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)
        -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath)
                cell.layoutMargins = UIEdgeInsetsZero
                cell.textLabel?.text = "User:"
                //                cell.detailTextLabel?.text =
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
                return cell
            } else if indexPath.row == 3 {
                let cell = tableView.dequeueReusableCellWithIdentifier("LogOutCell", forIndexPath: indexPath)
                cell.layoutMargins = UIEdgeInsetsZero
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as! SettingCell
                cell.layoutMargins = UIEdgeInsetsZero
                if indexPath.row == 1 {
                    cell.settingLabel.text = "Change Password";
                } else if indexPath.row == 2 {
                    cell.settingLabel.text = "Edit Profile";
                }
                
                return cell
            }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 3 {
            self.navigationController!.popToRootViewControllerAnimated(false)
        }
    }
}
