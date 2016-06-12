//
//  AddReviewViewController.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/12/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

class AddReviewViewController : UIViewController {
    
    @IBOutlet weak var reviewTextView: UITextView!
    
    // MARK: ViewController's methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reviewTextView.autocorrectionType = UITextAutocorrectionType.No;
    }
    
    override func viewDidAppear(animated: Bool) {
        let tbvc = self.tabBarController  as! ReviewsTabBarController
        tbvc.title = "Add Review"
    }
    
    func saveReview() {
        
    }
}
