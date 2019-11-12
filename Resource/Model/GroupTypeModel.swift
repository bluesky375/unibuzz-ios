//
//  GroupTypeModel.swift
//  UniBuzz
//
//  Created by Gourav on 07/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

import ObjectMapper

class GroupTypeModel : Mappable {
    var status : Bool?
    var message : String?
    var data : GroupData?

   required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }

}

class GroupData : Mappable {
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
