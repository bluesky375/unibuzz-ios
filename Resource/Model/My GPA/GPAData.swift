//
//	GPAData.swift


import Foundation 
import ObjectMapper


class GPAData : Mappable{

	var allowPost : String?
	var allowUser : GPAAllowUser?
	var creditHour : String?
	var currentGpa : String?
	var firstName : String?
	var fullName : String?
	var gpa : [Course]?
	var gpaBenefits : [GPAGpaBenefit]?
	var id : Int?
	var lastName : String?
	var overallGpa : String?
	var profileImage : String?
	var profilePicture : Int?
	var semesterGpa : String?
	var universityGpa : [GPAUniversityGpa]?

	required init?(map: Map){}
	
	func mapping(map: Map)
	{
		allowPost <- map["allow_post"]
		allowUser <- map["allow_user"]
		creditHour <- map["credit_hour"]
		currentGpa <- map["current_gpa"]
		firstName <- map["first_name"]
		fullName <- map["full_name"]
		gpa <- map["gpa"]
		gpaBenefits <- map["gpa_benefits"]
		id <- map["id"]
		lastName <- map["last_name"]
		overallGpa <- map["overall_gpa"]
		profileImage <- map["profile_image"]
		profilePicture <- map["profile_picture"]
		semesterGpa <- map["semester_gpa"]
		universityGpa <- map["university_gpa"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         allowPost = aDecoder.decodeObject(forKey: "allow_post") as? String
         allowUser = aDecoder.decodeObject(forKey: "allow_user") as? GPAAllowUser
         creditHour = aDecoder.decodeObject(forKey: "credit_hour") as? String
         currentGpa = aDecoder.decodeObject(forKey: "current_gpa") as? String
         firstName = aDecoder.decodeObject(forKey: "first_name") as? String
         fullName = aDecoder.decodeObject(forKey: "full_name") as? String
         gpa = aDecoder.decodeObject(forKey: "gpa") as? [Course]
         gpaBenefits = aDecoder.decodeObject(forKey: "gpa_benefits") as? [GPAGpaBenefit]
         id = aDecoder.decodeObject(forKey: "id") as? Int
         lastName = aDecoder.decodeObject(forKey: "last_name") as? String
         overallGpa = aDecoder.decodeObject(forKey: "overall_gpa") as? String
         profileImage = aDecoder.decodeObject(forKey: "profile_image") as? String
         profilePicture = aDecoder.decodeObject(forKey: "profile_picture") as? Int
         semesterGpa = aDecoder.decodeObject(forKey: "semester_gpa") as? String
         universityGpa = aDecoder.decodeObject(forKey: "university_gpa") as? [GPAUniversityGpa]

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if allowPost != nil{
			aCoder.encode(allowPost, forKey: "allow_post")
		}
		if allowUser != nil{
			aCoder.encode(allowUser, forKey: "allow_user")
		}
		if creditHour != nil{
			aCoder.encode(creditHour, forKey: "credit_hour")
		}
		if currentGpa != nil{
			aCoder.encode(currentGpa, forKey: "current_gpa")
		}
		if firstName != nil{
			aCoder.encode(firstName, forKey: "first_name")
		}
		if fullName != nil{
			aCoder.encode(fullName, forKey: "full_name")
		}
		if gpa != nil{
			aCoder.encode(gpa, forKey: "gpa")
		}
		if gpaBenefits != nil{
			aCoder.encode(gpaBenefits, forKey: "gpa_benefits")
		}
		if id != nil{
			aCoder.encode(id, forKey: "id")
		}
		if lastName != nil{
			aCoder.encode(lastName, forKey: "last_name")
		}
		if overallGpa != nil{
			aCoder.encode(overallGpa, forKey: "overall_gpa")
		}
		if profileImage != nil{
			aCoder.encode(profileImage, forKey: "profile_image")
		}
		if profilePicture != nil{
			aCoder.encode(profilePicture, forKey: "profile_picture")
		}
		if semesterGpa != nil{
			aCoder.encode(semesterGpa, forKey: "semester_gpa")
		}
		if universityGpa != nil{
			aCoder.encode(universityGpa, forKey: "university_gpa")
		}

	}

}
