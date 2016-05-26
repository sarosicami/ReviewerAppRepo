//
//  Product.swift
//  ReviewerApp
//
//  Created by Camelia Sarosi on 5/26/16.
//  Copyright © 2016 Camelia Sarosi. All rights reserved.
//

import UIKit

struct Product {
    var id: Int?
    var brand: String?
    var model: String?
    var processor: String?
    var display: String?
    var RAMMemory: String?
    var memorySpeed: Int?
    var hardDrive: Int?
    var videoCard: String?
    var cardDescription: String?
    var batteryLife: Int?
    var weight: Double?
    var housingMaterial: String?
    var color: String?
    var operatingSystem: String?
    var reviews: NSArray?
    
    init () {
        
    }
    
    init(dict: NSDictionary) {
        self.id = dict.valueForKey("id") as? Int
        self.brand = dict.valueForKey("brand") as? String
        self.model = dict.valueForKey("product_model") as? String
        self.processor = dict.valueForKey("processor") as? String
        self.display = dict.valueForKey("display") as? String
        self.RAMMemory = dict.valueForKey("RAM_memory") as? String
        self.memorySpeed = dict.valueForKey("memory_speed") as? Int
        self.hardDrive = dict.valueForKey("hard_drive") as? Int
        self.videoCard = dict.valueForKey("video_card") as? String
        self.cardDescription = dict.valueForKey("card_description") as?  String
        self.batteryLife = dict.valueForKey("battery_life") as? Int
        self.weight = dict.valueForKey("item_weight") as? Double
        self.housingMaterial = dict.valueForKey("housing_material") as?  String
        self.color = dict.valueForKey("color") as? String
        self.operatingSystem = dict.valueForKey("operating_system") as?  String
        self.reviews = dict.valueForKey("reviews") as? NSArray
    }
}

