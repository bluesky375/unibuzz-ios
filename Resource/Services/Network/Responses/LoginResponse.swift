//
//  LoginResponse.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 26/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//

import Foundation

struct LoginResponse: Response {
    var status: Bool?
    var message: String?
    let data: Session?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    func process() {
        guard let details = data else {
            return
        }
    }
}


struct  Session: Codable {
    var id: Int?
    var first_name: String?
    var last_name: String?
    var email: String?
    var username: String?
    var referral_code: String?
    var introduction: String?
    var phone: String?
    var dob: String?

    var user_type : Int?
    var gender: String?
    var student_level: Int?
    var country_id: Int?
    var university_id: Int?
    var college_id: Int?
    var department_id: Int?
    var program_id: Int?
    var city_id: Int?
    var nationality: Int?
    var profile_picture: Int?
    var parent_id: Int?
    var current_gpa: String?
    var credit_hour: String?
    var status: Int?
    var is_verified: Int?
    var is_block: Int?
    var allow_post: String?
    var can_post: Int?
    var access_token: String?
    var token_type: String?
    var full_name: String?
    var profile_image: String?
    var university_name : String?
    var college_name : String?
    var user_primary_email : String?
    var created_at : String?
    var allow_user    : AllowUser?
    
//    var gpa : [GPA]?

    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case username = "username"
        case referral_code = "referral_code"
        case introduction = "introduction"
        case user_type = "user_type"
        case gender = "gender"
        case student_level = "student_level"
        case country_id = "country_id"
        case university_id = "university_id"
        case college_id = "college_id"
        case department_id = "department_id"
        case program_id = "program_id"
        case city_id = "city_id"
        case nationality = "nationality"
        case profile_picture = "profile_picture"
        case parent_id = "parent_id"
        case current_gpa = "current_gpa"
        case credit_hour = "credit_hour"
        case status = "status"
        case is_verified = "is_verified"
        case is_block = "is_block"
        case allow_post = "allow_post"
        case can_post = "can_post"
        case access_token = "access_token"
        case token_type = "token_type"
        case full_name = "full_name"
        case profile_image = "profile_image"
        case allow_user = "allow_user"
        case university_name = "university_name"
        case college_name = "college_name"
        case user_primary_email = "user_primary_email"
        case phone = "phone"
        case created_at = "created_at"
        case dob = "date_of_birth"


//        case gpa = "gpa"

        
    }
    
}

struct AllowUser: Codable {
    var post: Int?
    var classified: Int?
    var job: Int?
    var notes: Int?
    var bookstore: Int?
    
    
    enum CodingKeys: String, CodingKey {
        case post = "post"
        case classified = "classified"
        case job = "job"
        case notes = "notes"
        case bookstore = "bookstore"
    }
    
}

struct Avatar : Codable {
    var id: Int?
    var image : String?
    var imagePath: String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case image = "image"
        case imagePath = "image_path"
    }
    
}


struct AvatarResponse : Response {
    var status: Bool?
    var message: String?
    var data: AvatarSession?
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
        
    }
    
    func process() {
        guard let details = data else {
            return
        }
    }
}

struct AvatarSession  : Codable {
    
    var userAvat      : [Avatar]?
    
    
    enum CodingKeys: String, CodingKey {
        
        case userAvat = "avatars"
    }
    
}


struct FeedsResponse : Response {
    var status: Bool?
    var message: String?
//    let data: WallFeedss?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
//        case data = "data"

    }

    func process() {
//        guard let details = data else {
//            return
//        }
    }
}
//
//
//struct WallFeedss : Codable {
//
//    var posts  : PostObjects?
//    var groups : [GroupObjectInfos]?
//
//
//    enum CodingKeys: String, CodingKey {
//
//        case posts = "posts"
//        case groups = "groups"
//    }
//
//}
//
//struct PostObjects : Codable {
//
//    var current_page                                        :       Int?
//    var first_page_url                                      :       String?
//    var from                                                :       Int?
//    var last_page                                           :       Int?
//    var total                                               :       Int?
//    var per_page                                            :       Int?
//    var feedsObject                                         :       [FeedsObjects]?
//    enum CodingKeys: String, CodingKey {
//
//        case current_page = "current_page"
//        case first_page_url = "first_page_url"
//        case from = "from"
//        case last_page = "last_page"
//        case total = "total"
//        case per_page = "per_page"
//        case feedsObject = "data"
//
//    }
//
//}

struct GroupObjectInfos : Codable {
    
    var id                                      :       Int?
    var name                                    :       String?
    var user_id                                 :       Int?
    var barcode                                 :       String?
    var group_thumb                             :       String?
    
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case user_id = "user_id"
        case barcode = "barcode"
        case group_thumb = "group_thumb"

    }
    
}



struct UserInfoObjects : Codable {
    
    var id                                      :       Int?
    var first_name                                    :       String?
    var last_name                                 :       String?
    var email                                 :       String?
    var full_name                             :       String?
    var profile_image                             :       String?
    var is_blocked                             :        Bool?
    
    enum CodingKeys: String, CodingKey {
        
        case id = "id"
        case first_name = "first_name"
        case last_name = "last_name"
        case email = "email"
        case full_name = "full_name"
        case profile_image = "profile_image"
        case is_blocked = "is_blocked"

        
    }
}
struct GPA: Codable {
    var id: Int
    var userId: Int
    var course: String?
    var creditHour: Int?
    var grade: Int?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case userId = "user_id"
        case course = "course"
        case creditHour = "credit_hour"
        case grade = "grade"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
    
}

struct GradeName: Codable {
    var id: Int
    var universityId: Int?
    var grade: String?
    var gradeValue: Float?
    var gradeLevel: String?
    var createdAt: String?
    var updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case universityId = "university_d"
        case grade = "grade"
        case gradeValue = "grade_value"
        case gradeLevel = "grade_level"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        
    }
}

//struct FeedsObjects : Codable  {
//
//    var id                                                   :       Int?
//    var user_id                                              :       Int?
//    var user_as                                              :       Int?
//    var student_group_id                                     :       Int?
//    var parent_id                                            :       Int?
//    var slug                                                 :       String?
//    var comment                                              :       String?
//    var status                                               :       Int?
//    var is_delete                                            :       Int?
//    var announcement                                         :       Int?
//    var allow_comment                                        :       Int?
//    var post_like_count                                      :       Int?
//    var post_dislike_count                                   :       Int?
//    var post_laugh_count                                     :       Int?
//    var post_angry_count                                     :       Int?
//    var is_favorite                                          :       Bool?
//    var user_reaction                                        :       Int?
//    var post_group_name                                      :       String?
//    var created_at                                           :       String?
//    var is_poll                                              :       Bool?
//    var total_poll_votes                                     :       Int?
//    var total_comments                                       :       Int?
//    var is_voted                                             :       Bool?
//    var is_reported                                          :       Bool?
//    var is_edited                                            :       Bool?
//    var user                                                 :       UserInfoObjects?
//    var postOption                                           :       [PostOptions]?
//    var allComment                                           :       [AllComments]?
//    var commentAvatar                                        :       [CommentAvatars]?
//    var groupInfo                                            :       GroupInfos?
//
//
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case user_id = "user_id"
//        case user_as = "user_as"
//        case student_group_id = "student_group_id"
//        case parent_id = "parent_id"
//        case slug = "slug"
//        case comment = "comment"
//        case status = "status"
//        case is_delete = "is_delete"
//        case announcement = "announcement"
//        case allow_comment = "allow_comment"
//        case post_like_count = "post_like_count"
//        case post_dislike_count = "post_dislike_count"
//        case post_laugh_count = "post_laugh_count"
//        case post_angry_count = "post_angry_count"
//        case is_favorite = "is_favorite"
//        case user_reaction = "user_reaction"
//        case post_group_name = "post_group_name"
//        case is_poll = "is_poll"
//        case total_poll_votes = "total_poll_votes"
//        case total_comments = "total_comments"
//        case is_voted = "is_voted"
//        case created_at = "created_at"
//        case user = "user"
//        case postOption = "post_options"
//        case groupInfo = "group_name"
//        case commentAvatar = "commentAvatar"
//        case allComment = "all_post_comments"
////        case commentAvatar = "commentAvatar"
////        case commentAvatar = "commentAvatar"
//
//        case is_reported    = "is_reported"
//        case is_edited    = "is_edited"
//
//
//
//    }
//}

//struct UserInfoObjects : Codable {
//
//    var id                                      :       Int?
//    var first_name                                    :       String?
//    var last_name                                 :       String?
//    var email                                 :       String?
//    var full_name                             :       String?
//    var profile_image                             :       String?
//    var is_blocked                             :        Bool?
//
//    enum CodingKeys: String, CodingKey {
//
//        case id = "id"
//        case first_name = "first_name"
//        case last_name = "last_name"
//        case email = "email"
//        case full_name = "full_name"
//        case profile_image = "profile_image"
//        case is_blocked = "is_blocked"
//
//
//    }
//}
//
//struct PostOptions : Codable {
//
//    var id                                        :       Int?
//    var post_id                                      :       Int?
//    var name                                      :       String?
//    var status                                      :       Int?
//    var post_votes_count                                      :       Int?
//    var myVote                                      :       MyVotes?
//
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case post_id = "post_id"
//        case name = "name"
//        case status = "status"
//        case post_votes_count = "post_votes_count"
//        case myVote           = "my_vote"
//    }
//
//}
//
//struct MyVotes : Codable  {
//    var post_option_id                                        :       Int?
//
//    enum CodingKeys: String, CodingKey {
//        case post_option_id = "post_option_id"
//
//    }
//}
//
//
//struct CommentModel : Response {
//    var status: Bool?
//    var message: String?
//    let data: AllComments?
//
//    enum CodingKeys: String, CodingKey {
//        case status = "status"
//        case message = "message"
//        case data = "data"
//
//    }
//
//    func process() {
//        guard let details = data else {
//            return
//        }
//    }
//}
//
//struct ReplyCommentsss  : Response {
//    var status: Bool?
//    var message: String?
//    let data: ReplyComments?
//
//    enum CodingKeys: String, CodingKey {
//        case status = "status"
//        case message = "message"
//        case data = "data"
//
//    }
//
//    func process() {
//        guard let details = data else {
//            return
//        }
//    }
//}
//
//
//
//struct AllComments : Codable {
//
//    var id                                                 :      Int?
//    var user_id                                            :       Int?
//    var group_post_id                                      :       Int?
//    var comment                                            :       String?
//    var parent_id                                          :       Int?
//    var status                                             :       Int?
//    var created_at                                         :       String?
//    var total_comments                                     :       Int?
//    var userInfo                                           :       UserInfoObjects?
//    var replyComment                                       :       [ReplyComments]?
//
//
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case user_id = "user_id"
//        case group_post_id = "group_post_id"
//        case comment = "comment"
//        case parent_id = "parent_id"
//        case status = "status"
//        case total_comments = "total_comments"
//
//        case userInfo = "user"
//        case replyComment = "replies"
//        case created_at = "created_at"
//    }
//}
//
//struct ReplyComments : Codable {
//
//    var id                                                 :      Int?
//    var user_id                                            :       Int?
//    var group_post_id                                      :       Int?
//    var comment                                            :       String?
//    var parent_id                                          :       Int?
//    var status                                             :       Int?
//    var created_at                                         :       String?
//    var userInfo                                           :       UserInfoObjects?
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case user_id = "user_id"
//        case group_post_id = "group_post_id"
//        case comment = "comment"
//        case parent_id = "parent_id"
//        case status = "status"
//        case userInfo = "userInfo"
//        case created_at = "created_at"
//    }
//}
////
//struct GroupInfos : Codable {
//
//    var id                                        :       Int?
//    var name                                      :       String?
//    var descriptionOfUniversity                                      :       String?
//    var barcode                                      :       String?
//    var logo                                      :       String?
//    var group_thumb                                      :       String?
//
//
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case name = "name"
//        case descriptionOfUniversity = "description"
//        case barcode = "barcode"
//        case logo = "logo"
//        case group_thumb = "group_thumb"
//
//
//    }
//}
//
//struct CommentAvatars : Codable {
//    var imge                                        :       String?
//    enum CodingKeys: String ,  CodingKey {
//        case imge = "0"
//    }
//
//}
//
//struct ReactOnPost : Response {
//    var status: Bool?
//    var message: String?
//    let data    : FeedsObjects?
//
//    enum CodingKeys: String, CodingKey {
//        case status = "status"
//        case message = "message"
//        case data = "data"
//
//    }
//
//    func process() {
//        guard let details = data else {
//            return
//        }
//    }
//}
