//
//  User.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 6/13/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

struct User {
    var id: Int?
    var username:String?
    var email: String?
    var country: String?
    var isLogged: Bool?
    
    init(dict: NSDictionary) {
        self.id = dict.valueForKey("id") as? Int
        self.username = dict.valueForKey("username") as? String
        self.email = dict.valueForKey("email") as? String
        self.country = dict.valueForKey("country") as? String
    }
}
