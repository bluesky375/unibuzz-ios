//
//  CalendarModel.swift
//  UniBuzz
//
//  Created by Gourav on 06/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ObjectMapper

 class CalendarModel : Mappable {
     var status : Bool?
     var message : String?
     var data : CalendarData?

     required init?(map: Map) {

     }

    func mapping(map: Map) {

         status <- map["status"]
         message <- map["message"]
         data <- map["data"]
     }

 }

class CalendarData : Mappable {
    var current_page : Int?
    var data : [EventList]?
    var first_page_url : String?
    var from : Int?
    var last_page : Int?
    var last_page_url : String?
    var next_page_url : String?
    var path : String?
    var per_page : Int?
    var prev_page_url : String?
    var to : Int?
    var total : Int?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        current_page <- map["current_page"]
        data <- map["data"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        last_page_url <- map["last_page_url"]
        next_page_url <- map["next_page_url"]
        path <- map["path"]
        per_page <- map["per_page"]
        prev_page_url <- map["prev_page_url"]
        to <- map["to"]
        total <- map["total"]
    }

}



class CalendarUser : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var email : String?
    var profile_picture : Int?
    var user_type : Int?
    var allow_user : String?
    var full_name : String?
    var profile_image : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        profile_picture <- map["profile_picture"]
        user_type <- map["user_type"]
        allow_user <- map["allow_user"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
    }

}

class EventList : Mappable {
    var id : Int?
    var user_id : Int?
    var student_group_id : Int?
    var country_id : Int?
    var university_id : Int?
    var college_id : Int?
    var city_id : Int?
    var title : String?
    var slug : String?
    var description : String?
    var image : String?
    var thumb : String?
    var address : String?
    var latitude : String?
    var longitude : String?
    var start_date : String?
    var end_date : String?
    var time_from : String?
    var event_url : String?
    var fees : String?
    var time_to : String?
    var status : Int?
    var is_delete : Int?
    var type : Int?
    var group_event : Int?
    var event_type : Int?
    var start_date_time : String?
    var created_at : String?
    var updated_at : String?
    var event_desc : String?
    var event_image : String?
    var event_thumb : String?
    var user_attending : Int?
    var user : CalendarUser?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        user_id <- map["user_id"]
        student_group_id <- map["student_group_id"]
        country_id <- map["country_id"]
        university_id <- map["university_id"]
        college_id <- map["college_id"]
        city_id <- map["city_id"]
        title <- map["title"]
        slug <- map["slug"]
        description <- map["description"]
        image <- map["image"]
        thumb <- map["thumb"]
        address <- map["address"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        start_date <- map["start_date"]
        end_date <- map["end_date"]
        time_from <- map["time_from"]
        event_url <- map["event_url"]
        fees <- map["fees"]
        time_to <- map["time_to"]
        status <- map["status"]
        is_delete <- map["is_delete"]
        type <- map["type"]
        group_event <- map["group_event"]
        event_type <- map["event_type"]
        start_date_time <- map["start_date_time"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        event_desc <- map["event_desc"]
        event_image <- map["event_image"]
        event_thumb <- map["event_thumb"]
        user_attending <- map["user_attending"]
        user <- map["user"]
    }

}
