//
//  Review.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

struct Review {
    var id: Int?
    var body:String?
    var productId: Int?

    init(dict: NSDictionary) {
        self.id = dict.valueForKey("id") as? Int
        self.body = dict.valueForKey("body") as? String
        self.productId = dict.valueForKey("product_id") as? Int
    }
}

