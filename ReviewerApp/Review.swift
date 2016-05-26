//
//  Review.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

struct Review {
    var id: NSNumber?
    var body:String?
    var productId: NSNumber?

    init(dict: NSDictionary) {
        self.id = dict.valueForKey("id") as? NSNumber
        self.body = dict.valueForKey("brand") as? String
        self.productId = dict.valueForKey("id") as? NSNumber
    }
}

