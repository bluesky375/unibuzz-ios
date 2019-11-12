//
//	GPAAllowUser.swift


import Foundation 
import ObjectMapper
import AlamofireObjectMapper

class GPAAllowUser : Mappable {

	var bookstore : Int?
	var classified : Int?
	var job : Int?
	var notes : Int?
	var post : Int?

	required init?(map: Map){}

	func mapping(map: Map)
	{
		bookstore <- map["bookstore"]
		classified <- map["classified"]
		job <- map["job"]
		notes <- map["notes"]
		post <- map["post"]
		
	}

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
	{
         bookstore = aDecoder.decodeObject(forKey: "bookstore") as? Int
         classified = aDecoder.decodeObject(forKey: "classified") as? Int
         job = aDecoder.decodeObject(forKey: "job") as? Int
         notes = aDecoder.decodeObject(forKey: "notes") as? Int
         post = aDecoder.decodeObject(forKey: "post") as? Int

	}

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
	{
		if bookstore != nil{
			aCoder.encode(bookstore, forKey: "bookstore")
		}
		if classified != nil{
			aCoder.encode(classified, forKey: "classified")
		}
		if job != nil{
			aCoder.encode(job, forKey: "job")
		}
		if notes != nil{
			aCoder.encode(notes, forKey: "notes")
		}
		if post != nil{
			aCoder.encode(post, forKey: "post")
		}

	}

}
