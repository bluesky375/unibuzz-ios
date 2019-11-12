//
//  FileModel.swift
//  UniBuzz
//
//  Created by Gourav on 07/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ObjectMapper


class FileModel : Mappable {
    var status : Bool?
    var message : String?
    var data : FileData?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        status <- map["status"]
        message <- map["message"]
        data <- map["data"]
    }

}

class Language : Mappable {
    var id : String?
    var name : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}



class FileData : Mappable {
    var notes_type : [Notes_type]?
    var creator : [Creator]?
    var language : [Language]?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        notes_type <- map["notes_type"]
        creator <- map["creator"]
        language <- map["language"]
    }

}


class Notes_type : Mappable {
    var id : Int?
    var name : String?
    var name_ar : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
        name_ar <- map["name_ar"]
    }

}


class Creator : Mappable {
    var id : Int?
    var name : String?

    required init?(map: Map) {

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}
