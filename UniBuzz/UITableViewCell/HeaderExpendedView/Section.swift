//
//  Section.swift
//  ExpendableView
//
//  Created by Ihsan ullah on 13/11/2018.
//  Copyright © 2018 htmlpro. All rights reserved.
//

import Foundation

struct Section {
    
    var genre: String
    var icon : String
    var subMenu: [String]!
    var expanded:  Bool!
    
    init(genre: String, icon : String , subMenu:[String], expanded: Bool) {
        self.genre = genre
        self.subMenu = subMenu
        self.expanded = expanded
        self.icon = icon
    }
}

struct PollUpdate : Codable  {
    var id: Int
    var comment : String
    
    init(id: Int , comment : String) {
        self.id = id
        self.comment = comment
    }
}

struct Friend : Codable  {
    var id: Int
    
    init(id: Int) {
        self.id = id
    }
}


struct CourseCreate : Codable  {
    var id : Int
    var start_time : String
    var end_time : String

    init(id: Int , start_time : String  , end_time : String ) {
        self.id = id
        self.start_time = start_time
        self.end_time = end_time

    }
}

struct FieldClassified {
    
    var field_name: String
    var listItemId : String

    init(field_name: String, listItemId : String) {
        self.field_name = field_name
        self.listItemId = listItemId
    }
}


