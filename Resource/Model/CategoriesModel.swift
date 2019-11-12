//
//  CategoriesModel.swift
//  UniBuzz
//
//  Created by MobikasaNight on 31/10/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ObjectMapper

class CategoriesModel : Mappable {
    var status : Bool?
    var message : String?
    var data : CategoriesData?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
    
}


class CategoriesData : Mappable {
    var base_url : String?
    var categories : [Categories]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        base_url <- map["base_url"]
        categories <- map["categories"]
    }
    
}

class Categories : Mappable {
    var id : Int?
    var name : String?
    var name_ar : String?
    var icon : String?
    var status : Int?
    var sort_by : Int?
    var category_notes_count : Int?
    var icon_name : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
        icon <- map["icon"]
        status <- map["status"]
        sort_by <- map["sort_by"]
        category_notes_count <- map["category_notes_count"]
        icon_name <- map["icon_name"]
    }
    
}
