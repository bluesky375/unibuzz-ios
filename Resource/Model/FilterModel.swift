//
//  FilterModel.swift
//  UniBuzz
//
//  Created by Gourav on 03/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ObjectMapper

class FilterModel : Mappable {
    var status : Bool?
    var message : String?
    var data : FilterData?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}


class Universities : Mappable {
    var id : Int?
    var name : String?
    var name_ar : String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
    }
    
}


class FilterData : Mappable {
    var base_url : String?
    var countries : [Countries]?
    var categories : [FilterCategories]?
    var universities : [Universities]?
    var courses : [FilterCourses]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        base_url <- map["base_url"]
        countries <- map["countries"]
        categories <- map["categories"]
        universities <- map["universities"]
        courses <- map["courses"]
    }
    
}

class Countries : Mappable {
    var id : Int?
    var name : String?
    var name_ar : String?
    var status : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
        status <- map["status"]
    }
    
}

class FilterCourses : Mappable {
    var id : Int?
    var name : String?
    var name_ar : String?
    var status : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
        status <- map["status"]
    }
    
}


class FilterCategories : Mappable {
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


class CourseModel : Mappable {
    var status : Bool?
    var message : String?
    var data : CourseData?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
    
}

class CourseData : Mappable {
    var courses : [Courses]?
    var avatars : [Avatars]?
    var base_url : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {
        courses <- map["courses"]
        avatars <- map["avatars"]
        base_url <- map["base_url"]
    }

}

class Avatars : Mappable {
    var id : Int?
    var name : String?
    var status : Int?
    var sort_by : Int?
    required init?(map: Map) {

    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
        sort_by <- map["sort_by"]
    }

}


class EventTypeModel : Mappable {
   var status : Bool?
    var message : String?
    var data : [EventData]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
    
}

class EventData : Mappable {
    var id : Int?
    var name : String?
    var status : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        status <- map["status"]
    }

}

