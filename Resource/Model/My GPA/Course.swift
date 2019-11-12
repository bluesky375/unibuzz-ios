//
//	Course.swift
//

import Foundation 
import ObjectMapper

class Course : Mappable {

	var course : String?
	var createdAt : String?
	var creditHour : String?
	var grade : Int?
	var id : Int?
	var updatedAt : String?
	var userId : Int?

	required init?(map: Map){}

	func mapping(map: Map)
	{
		course <- map["course"]
		createdAt <- map["created_at"]
		creditHour <- map["credit_hour"]
		grade <- map["grade"]
		id <- map["id"]
		updatedAt <- map["updated_at"]
		userId <- map["user_id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         course = aDecoder.decodeObject(forKey: "course") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? String
         creditHour = aDecoder.decodeObject(forKey: "credit_hour") as? String
         grade = aDecoder.decodeObject(forKey: "grade") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? String
         userId = aDecoder.decodeObject(forKey: "user_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if course != nil{
			aCoder.encode(course, forKey: "course")
		}
		if createdAt != nil{
			aCoder.encode(createdAt, forKey: "created_at")
		}
		if creditHour != nil{
			aCoder.encode(creditHour, forKey: "credit_hour")
		}
		if grade != nil{
			aCoder.encode(grade, forKey: "grade")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if updatedAt != nil{
			aCoder.encode(updatedAt, forKey: "updated_at")
		}
		if userId != nil{
			aCoder.encode(userId, forKey: "user_id")
		}

	}

}
