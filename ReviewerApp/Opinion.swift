//
//  Opinion.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/7/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

struct Opinion {
    var id: Int?
    var body:String?
    var aspect:String?
    var category:String?
    var emotion:String?
    var polarity:String?
    var reviewId: Int?
    
    init(dict: NSDictionary) {
        self.id = dict.valueForKey("id") as? Int
        self.body = dict.valueForKey("body") as? String
        self.aspect = dict.valueForKey("aspect") as? String
        self.category = dict.valueForKey("category") as? String
        self.emotion = dict.valueForKey("emotion") as? String
        self.polarity = dict.valueForKey("polarity") as? String
        self.reviewId = dict.valueForKey("product_id") as? Int
    }
}
