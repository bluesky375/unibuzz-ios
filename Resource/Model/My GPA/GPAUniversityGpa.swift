//
//	GPAUniversityGpa.swift


import Foundation 
import ObjectMapper


class GPAUniversityGpa: Mappable {

	var grade : String?
	var gradeLevel : String?
	var gradeValue : String?
	var id : Int?
	var universityId : Int?

	required init?(map: Map){}

	func mapping(map: Map)
	{
		grade <- map["grade"]
		gradeLevel <- map["grade_level"]
		gradeValue <- map["grade_value"]
		id <- map["id"]
		universityId <- map["university_id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         grade = aDecoder.decodeObject(forKey: "grade") as? String
         gradeLevel = aDecoder.decodeObject(forKey: "grade_level") as? String
         gradeValue = aDecoder.decodeObject(forKey: "grade_value") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         universityId = aDecoder.decodeObject(forKey: "university_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if grade != nil{
			aCoder.encode(grade, forKey: "grade")
		}
		if gradeLevel != nil{
			aCoder.encode(gradeLevel, forKey: "grade_level")
		}
		if gradeValue != nil{
			aCoder.encode(gradeValue, forKey: "grade_value")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if universityId != nil{
			aCoder.encode(universityId, forKey: "university_id")
		}

	}

}
