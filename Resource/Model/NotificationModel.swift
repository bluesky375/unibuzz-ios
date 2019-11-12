// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let notifications = try? newJSONDecoder().decode(Notifications.self, from: jsonData)

import Foundation
import ObjectMapper

class EData : Mappable {
    var notifications : Notifications?
    var unread : Int?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        notifications <- map["notifications"]
        unread <- map["unread"]
    }
}


class Notication : Mappable {
    var status : Bool?
    var message : String?
    var data : EData?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
    
}

class ReadNotication : Mappable {
    var status : Bool?
    var message : String?
    var data : EData?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }
}

class Notifications : Mappable {
    var current_page : Int?
    var data : [IData]?
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
    
    required init?(map: Map){
        
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

class IData : Mappable {
    var id : Int?
    var user_id : Int?
    var posted_by : Posted_by?
    var type : Int?
    var post_id : Int?
    var comment : String?
    var post_comment : String?
    var is_read : Int?
    var user_as : Int?
    var email_address : String?
    var created_at : String?
    var status : Int?
    var total_post : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        id <- map["id"]
        user_id <- map["user_id"]
        posted_by <- map["posted_by"]
        type <- map["type"]
        post_id <- map["post_id"]
        comment <- map["comment"]
        post_comment <- map["post_comment"]
        is_read <- map["is_read"]
        user_as <- map["user_as"]
        email_address <- map["email_address"]
        created_at <- map["created_at"]
        status <- map["status"]
        total_post <- map["total_post"]
    }
    
}

class Posted_by : Mappable {
    var id : Int?
    var first_name : String?
    var last_name : String?
    var profile_picture : Int?
    var user_type : Int?
    var allow_user : String?
    var full_name : String?
    var profile_image : String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        profile_picture <- map["profile_picture"]
        user_type <- map["user_type"]
        allow_user <- map["allow_user"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
    }
    
}
