//
//	GPAGpaBenefit.swift


import Foundation 
import ObjectMapper


class GPAGpaBenefit : Mappable{

	var gradeFrom : String?
	var gradeTo : String?
	var id : Int?
	var name : String?
	var universityGpaId : Int?

	required init?(map: Map){}
	

	func mapping(map: Map)
	{
		gradeFrom <- map["grade_from"]
		gradeTo <- map["grade_to"]
		id <- map["id"]
		name <- map["name"]
		universityGpaId <- map["university_gpa_id"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         gradeFrom = aDecoder.decodeObject(forKey: "grade_from") as? String
         gradeTo = aDecoder.decodeObject(forKey: "grade_to") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         name = aDecoder.decodeObject(forKey: "name") as? String
         universityGpaId = aDecoder.decodeObject(forKey: "university_gpa_id") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if gradeFrom != nil{
			aCoder.encode(gradeFrom, forKey: "grade_from")
		}
		if gradeTo != nil{
			aCoder.encode(gradeTo, forKey: "grade_to")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if name != nil{
			aCoder.encode(name, forKey: "name")
		}
		if universityGpaId != nil{
			aCoder.encode(universityGpaId, forKey: "university_gpa_id")
		}

	}

}
