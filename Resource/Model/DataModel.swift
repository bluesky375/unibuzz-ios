//
//  DataModel.swift
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper


class UserResponse: Mappable {
    
    var message                           :       String?
    var status                            :       Bool?

    var getGroup                          :       [GroupObjectInfo]?
    var feeds                             :       WallFeeds?
//    var comment                           :       AllComment?
    var messageList                       :       PostObject?
    var listOfChat                        :       ChatList?
//    var messagee                          :       AllMessages?
    var friendObject                      :       PostObject?
    var groupObject                       :       PostObject?
    var groupPost                         :       PostObject?
    var groupFile                         :       PostObject?
    var replyCommentObj                   :       ReplyComment?
    var postReaction                      :       FeedsObject?
    var createGroup                       :       GroupList?
    var friendsItem                       :       SuggestionOrFriendListItem?
    var cvData                            :       CVObject?
    var groupInfo                         :       GroupInfoObject?
    var addMember                         :       [FriendProfile]?
    var getCountriesAndAvatar             :       AvatarObject?
    var countryList                       :       [CountryList]?
    var universityList                    :       [UniversityList]?
    var campusList                        :       [CampusList]?
    var collegeList                       :       [CollegesList]?
    var addParticipant                    :       [GroupChatMember]?
    var friendStatus                      :       FriendStatus?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        
        status          <- map["status"]
        message         <- map["message"]
        getGroup        <- map["data"]
        feeds           <- map["data"]
//        comment         <- map["data"]
        messageList     <- map["data"]
        listOfChat      <- map["data"]
//        messagee        <- map["data"]
        friendObject    <- map["data"]
        groupObject    <- map["data"]
        groupPost    <- map["data"]
        groupFile    <- map["data"]
        replyCommentObj <- map["data"]
        postReaction    <- map["data"]
        createGroup    <- map["data"]
        friendsItem    <- map["data"]
        cvData    <- map["data"]
        groupInfo <- map["data"]
        addMember <- map["data"]
        countryList <- map["data"]
        universityList <- map["data"]
        campusList <- map["data"]
        collegeList <- map["data"]

        getCountriesAndAvatar <- map["data"]
        addParticipant    <- map["data"]
        friendStatus    <- map["data"]

    }
}

class MessageObject : Mappable {
    
    var messagee                          :       AllMessages?
    var message                           :       String?
    var status                            :       Bool?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        messagee <- map["data"]
        message <- map["message"]
        status <- map["status"]
        
    }
}

class GeneralObject : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        
    }
}

class FeedsDetail : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var feedDetail                        :       FeedDetailObject?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        feedDetail      <- map["data"]

        
    }
}


class AllCommentObject : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var comment                           :       AllComment?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        comment  <- map["data"]
        
    }
}









class UserInfoObject : Mappable {
    
    var id                                      :       Int?
    var first_name                                    :       String?
    var last_name                                 :       String?
    var email                                 :       String?
    var full_name                             :       String?
    var profile_image                             :       String?
    var is_blocked                             :        Bool?
    var bbm                                    :        Bool?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
        is_blocked   <- map["is_blocked"]
        bbm   <- map["bbm"]
    }
}


class GroupObjectInfo : Mappable {
    
    var id                                      :       Int?
    var name                                    :       String?
    var user_id                                 :       Int?
    var barcode                                 :       String?
    var group_thumb                             :       String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        user_id <- map["user_id"]
        barcode <- map["barcode"]
        group_thumb <- map["group_thumb"]
    }
}


class WallFeeds : Mappable {
    
    var post                                       :       PostObject?
    var group                                      :       [GroupObjectInfo]?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        post <- map["posts"]
        group <- map["groups"]
    }
}


class PostObject : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var feedsObject                                         :       [FeedsObject]?
    var chatList                                            :       [ChatList]?
    var friendList                                          :       [FriendList]?
    var listOfGroup                                         :       [GroupList]?
    var group                                               :       GroupList?
    var post                                                :       PostGroup?
    var fileList                                            :       [FileList]?
    var listOfFriend                                         :      [FriendItemList]?
    var listOFRequest                                         :      [RequestFriendList]?
    var listOFSuggestion                                         :      [SuggestionList]?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]

        total <- map["total"]		
        per_page <- map["per_page"]
        feedsObject <- map["data"]
        chatList <- map["data"]
        friendList <- map["data"]
        listOfGroup <- map["data"]
        group <- map["group"]
        post  <- map["posts"]
        fileList <- map["data"]
        listOfFriend <- map["data"]
        listOFRequest <- map["data"]
        listOFSuggestion <- map["data"]


    }
}



class FeedsObject : Mappable {
    
    var id                                                   :       Int?
    var user_id                                              :       Int?
    var user_as                                              :       Int?
    var student_group_id                                     :       Int?
    var parent_id                                            :       Int?
    var slug                                                 :       String?
    var comment                                              :       String?
    var status                                               :       Int?
    var is_delete                                            :       Int?
    var announcement                                         :       Int?
    var allow_comment                                        :       Int?
    var post_like_count                                      :       Int?
    var post_dislike_count                                   :       Int?
    var post_laugh_count                                     :       Int?
    var post_angry_count                                     :       Int?
    var is_favorite                                          :       Bool?
    var user_reaction                                        :       Int?
    var post_group_name                                      :       String?
    var post_group_barcode                                      :       String?

    var created_at                                           :       String?
    var update_at                                            :       String?

    var is_poll                                              :       Bool?
    var total_poll_votes                                     :       Int?
    var total_comments                                       :       Int?
    var is_voted                                             :       Bool?
    var is_edited                                             :      Bool?
    var is_reported                                          :       Bool?
    var user                                                 :       UserInfoObject?
    var postOption                                           :       [PostOption]?
//    var postOptionsss                                        :       [PostOptionss]?
    var allComment                                           :       [AllComment]?
    var commentAvatar                                        :       [CommentAvatar]?
    var friendStatus                                         :       FriendStatus?
    var groupInfo                                            :       GroupInfo?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        user_as <- map["user_as"]
        student_group_id <- map["student_group_id"]
        parent_id <- map["parent_id"]
        slug <- map["slug"]
        comment <- map["comment"]
        status <- map["status"]
        is_delete <- map["is_delete"]
        announcement <- map["announcement"]
        allow_comment <- map["allow_comment"]
        post_like_count <- map["post_like_count"]
        post_dislike_count <- map["post_dislike_count"]
        post_laugh_count <- map["post_laugh_count"]
        post_angry_count <- map["post_angry_count"]
        is_favorite <- map["is_favorite"]
        user_reaction <- map["user_reaction"]
        post_group_name <- map["post_group_name"]
        is_poll <- map["is_poll"]
        total_poll_votes <- map["total_poll_votes"]
        total_comments <- map["total_comments"]
        is_voted <- map["is_voted"]
        created_at <- map["created_at"]
        update_at  <- map["updated_at"]
        user <- map["user"]
        postOption <- map["post_options"]
//        postOptionsss <- map["post_options"]
        allComment  <- map["all_post_comments"]
        groupInfo   <- map["group_name"]
        commentAvatar <- map["comment_user_avatars"]
        is_edited    <- map["is_edited"]
        is_reported  <- map["is_reported"]
        post_group_barcode <- map["post_group_barcode"]
        friendStatus <- map["friend_status"]


    }
}

class PostOption : Mappable {
    
    var id                                        :       Int?
    var post_id                                      :       Int?
    var name                                      :       String?
    var status                                      :       Int?
    var post_votes_count                                      :       Int?
    var myVote                                      :       MyVote?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        post_id <- map["post_id"]
        name <- map["name"]
        status <- map["status"]
        post_votes_count <- map["post_votes_count"]
        myVote <- map["my_vote"]

    }
}

class FriendStatus : Mappable {
    
    var friends                                        :       Bool?
    var requested                                      :       Bool?
    var invited                                      :       Bool?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        friends <- map["friends"]
        requested <- map["requested"]
        invited <- map["invited"]
        
    }
}


class PostOptionss : Mappable {
    
    var id                                        :       Int?
    var name                                      :       String?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
    }
}


class MyVote : Mappable {
    
    var post_option_id                                        :       Int?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        post_option_id <- map["post_option_id"]
        
    }
}
class FeedDetailObject : Mappable {
    
    var post                                           :       FeedsObject?
    var memberList                                     :       [MemberList]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        post <- map["post"]
        memberList <- map["members"]
    }
}

class MemberList : Mappable {
    
    var id                                                                 :       Int?
    var student_group_id                                                   :       Int?
    var member_type                                                        :       Int?
    var status                                                             :       Int?
    var is_admin                                                           :       Bool?
    var user                                                               :       UserInfoObject?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        student_group_id <- map["student_group_id"]
        member_type <- map["user_details"]
        status <- map["status"]
        is_admin <- map["is_admin"]
        user   <- map["user"]

        
    }
}

class AllComment : Mappable {
    
    var id                                                 :      Int?
    var user_id                                            :       Int?
    var group_post_id                                      :       Int?
    var comment                                            :       String?
    var parent_id                                          :       Int?
    var status                                             :       Int?
    var created_at                                         :       String?
    var total_comments                                     :       Int?
    var userInfo                                           :       UserInfoObject?
    var replyComment                                       :       [ReplyComment]?
    var reportComment                                             :       ReportComment?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        group_post_id <- map["group_post_id"]
        comment <- map["comment"]
        parent_id <- map["parent_id"]
        status <- map["status"]
        userInfo <- map["user"]
        replyComment <- map["replies"]
        created_at   <- map["created_at"]
        total_comments   <- map["total_comments"]
        reportComment   <- map["report"]

    }
}

class ReportComment : Mappable {
    
    var id                                                 :      Int?
    var post_comment_id                                            :       Int?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        post_comment_id <- map["post_comment_id"]
        
    }
}



class ReplyComment : Mappable {
    
    var id                                                 :      Int?
    var user_id                                            :       Int?
    var group_post_id                                      :       Int?
    var comment                                            :       String?
    var parent_id                                          :       Int?
    var status                                             :       Int?
    var created_at                                         :       String?
    var userInfo                                           :       UserInfoObject?
    var reportComment                                      :       ReportComment?

    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        group_post_id <- map["group_post_id"]
        comment <- map["comment"]
        parent_id <- map["parent_id"]
        status <- map["status"]
        userInfo <- map["user"]
        created_at   <- map["created_at"]
        reportComment <- map["report"]
    }
}


class GroupInfo : Mappable {
    
    var id                                        :       Int?
    var name                                      :       String?
    var descriptionOfUniversity                                      :       String?
    var barcode                                      :       String?
    var logo                                      :       String?
    var group_thumb                                      :       String?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        descriptionOfUniversity <- map["description"]
        barcode <- map["barcode"]
        logo <- map["logo"]
        group_thumb <- map["group_thumb"]

        
    }
}

class CommentAvatar : Mappable {
    
    var imge                                        :       String?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        imge <- map["0"]
        
        
    }
}


class ChatList  : Mappable {
    
    var id                                                         :       Int?
    var book_store_id                                              :       Int?
    var sender_id                                                  :       Int?
    var receiver_id                                                :       Int?
    var group_name                                                 :       String?
    var group_logo                                                 :       String?
    var sender_is_typing                                           :       Int?
    var receiver_is_typing                                         :       Int?
    var status                                                     :       Int?
    var identity_type                                              :       Int?
    var post_type                                                  :       Int?
    var unreadMessageCount                                         :       Int?

    var chatUser                                                   :       UserInfoObject?
    var group_image                                                :       String?
    var is_group                                                   :       Bool?
    var is_anonymous                                               :       Bool?
    var created_at                                                 :       String?
    var latest_message                                             :       LatestMessage?
    var listOfAllMessage                                           :       [AllMessages]?
    var dtail                                                      :       ChatUserDetail?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        book_store_id <- map["book_store_id"]
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        group_name <- map["group_name"]
        group_logo <- map["group_logo"]
        sender_is_typing <- map["sender_is_typing"]
        receiver_is_typing <- map["receiver_is_typing"]
        status <- map["status"]
        identity_type <- map["identity_type"]
        post_type <- map["post_type"]
        chatUser <- map["chat_user"]
        group_image <- map["group_image"]
        is_group <- map["is_group"]
        is_anonymous <- map["is_anonymous"]
        latest_message <- map["latest_message"]
        created_at  <- map["created_at"]
        listOfAllMessage  <- map["all_messages"]
        dtail  <- map["detail"]
        unreadMessageCount <- map["unread_messages_count"]
        


    }
}

class LatestMessage : Mappable {
    
    var id                                                 :       Int?
    var message                                            :       String?
    var chat_id                                            :       Int?
    var sender_id                                          :       Int?
    var receiver_id                                        :       Int?
    var is_read                                            :       Int?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        chat_id <- map["chat_id"]
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        is_read <- map["is_read"]


    }
}

class ChatUserDetail : Mappable {
    
    var url                                                 :       String?
    var titleOfChat                                            :       String?
    var image                                            :       String?
    var user_id                                          :       Int?
    var sub_category_id                                        :       Int?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        url <- map["url"]
        titleOfChat <- map["title"]
        image <- map["image"]
        user_id <- map["user_id"]
        sub_category_id <- map["sub_category_id"]


    }
}

class ChatMessageList : Mappable {

    var id                                                   :       Int?
    var distance                                             :       Int?
    var calories                                             :       Int?
    var duration                                             :       Int?
    var notes                                                :       String?
    var start_datetime                                       :       String?
    var distances                                             :       String?
    var caloriess                                             :       String?
    var durations                                             :       String?


    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        distance <- map["distance"]
        calories <- map["calories"]
        duration <- map["duration"]
        notes <- map["notes"]
        start_datetime <- map["start_datetime"]
        distances <- map["distance"]
        caloriess <- map["calories"]
        durations <- map["duration"]

        
    }
}

class AllMessages  : Mappable {
    
    var id                                                         :       Int?
    var message                                                    :       String?
    var chat_id                                                    :       Int?
    var sender_id                                                  :       Int?
    var receiver_id                                                :       Int?
    var is_read                                                    :       Int?
    var type                                                       :       Int?
    var post_link                                                  :       Int?
    var type_id                                                    :       Int?
    var status                                                     :       Int?
    var identity_type                                              :       Int?
    var parent_id                                                  :       Int?
    var is_forward                                                 :       Int?
    var created_at                                                 :       String?
    var sender_name                                                :       String?
    var image                                                      :       String?
    var userType                                                   :       Int?
    var is_anonymous                                               :       Bool?
    var is_reply                                                   :       Bool?
    var platform                                                   :       String?
    var from                                                         :       String?
//    var chat_ids                                                    :       String?

    var parent_message                                             :       ParesntMessage?
    var details                                                  :       MessageDetail?
    var message_files                                            :       [MessageFiles]?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        chat_id <- map["chat_id"]
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        is_read <- map["is_read"]
        type <- map["type"]
        post_link <- map["post_link"]
        type_id <- map["type_id"]
        status <- map["status"]
        identity_type <- map["identity_type"]
        parent_id <- map["parent_id"]
        is_forward <- map["is_forward"]
        created_at <- map["created_at"]
        sender_name <- map["sender_name"]
        image <- map["image"]
        userType  <- map["userType"]
        is_anonymous  <- map["is_anonymous"]
        is_reply  <- map["is_reply"]
        userType  <- map["userType"]
        parent_message  <- map["parent_message"]
        details <- map["detail"]
        message_files <- map["message_files"]

        platform        =   "Phone"
        from             =  "iOS"
        
//        chat_ids             =  "chat_id"

//        if map.JSON["platform"] == nil {
//            return platform == "Phone"
//        }
        

        
        
    }
}

class MessageDetail  : Mappable {
    
    var url                                                       :       String?
    var titleOfBookOrClassified                                                  :       String?
    var image                                                  :       String?
    var user_id                                                :       Int?
    var sub_category_id                                              :       Int?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        url <- map["url"]
        titleOfBookOrClassified <- map["title"]
        image <- map["image"]
        user_id <- map["user_id"]
        sub_category_id <- map["sub_category_id"]
    }
}


class ParesntMessage  : Mappable {
    
    var id                                                       :       Int?
    var message                                                  :       String?
    var chat_id                                                  :       Int?
    var sender_id                                                :       Int?
    var sender_name                                              :       UserInfoObject?
    var messageFile                                              :       [MessageFiles]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        message <- map["message"]
        chat_id <- map["chat_id"]
        sender_id <- map["sender_id"]
        sender_name <- map["sender_name"]
        messageFile <- map["message_files"]

    }
}

class MessageFiles  : Mappable {
    
    var id                                                       :       Int?
    var chat_message_id                                                  :       Int?
    var file_name                                                  :       String?
    var file_path                                                :       String?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        chat_message_id <- map["chat_message_id"]
        file_name <- map["file_name"]
        file_path <- map["file_path"]
    }
}


class FriendList  : Mappable {
    
    var id                                                            :       Int?
    var created_at                                                    :       String?
    var user_id                                                       :       Int?
    var friend_user_id                                                :       Int?
    var is_read                                                       :       Int?
    var is_follow                                                     :       Int?
    var deleted_at                                                    :       Int?
    var friendProfile                                                 :       FriendProfile?
    var userFriend                                                    :       FriendProfile?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        friend_user_id <- map["friend_user_id"]
        is_read <- map["is_read"]
        is_follow <- map["is_follow"]
        deleted_at <- map["deleted_at"]
        friendProfile <- map["friend_profile"]
        userFriend <- map["user"]

    }
}


class FriendProfile : Mappable {
    
    var id                                      :       Int?
    var first_name                                    :       String?
    var last_name                                 :       String?
    var full_name                             :       String?
    var profile_image                             :       String?
    var uni_name                             :       String?
    var uniObj                                :  UniversityObj?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
        uni_name   <- map["uni_name"]
        uniObj   <- map["uni_name"]

        
    }
}

class UniversityObj : Mappable {
    
    var id                                      :       Int?
    var name                                    :       String?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
    }
}

class GroupList : Mappable {
    
    var id : Int?
    var name : String?
    var user_id : Int?
    var university_id : Int?
    var college_id : Int?
    var department_id : Int?
    var course_id : Int?
    var professor : String?
    var university : String?
    var description : String?
    var cover : String?
    var logo : String?
    var barcode : String?
    var status : Int?
    var is_delete : Int?
    var is_block : Int?
    var group_type : Int?
    var created_at : String?
    var updated_at : String?
    var members_count : Int?
    var posts_count : Int?
    var group_thumb : String?
    var university_name : String?
    var is_my_group : Bool?
    var is_private_group : Bool?
    var is_invited : Bool?
    var is_blocked : Bool?
    var is_sub_admin : Bool?
    var is_requested : Bool?
    var requests_count : Int?
    var is_member : Bool?
    var invitation_id : Int?
    var request_id : Int?
    var course_name : String?
    var course_code : String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        user_id <- map["user_id"]
        university_id <- map["university_id"]
        college_id <- map["college_id"]
        department_id <- map["department_id"]
        course_id <- map["course_id"]
        professor <- map["professor"]
        university <- map["university"]
        description <- map["description"]
        cover <- map["cover"]
        logo <- map["logo"]
        barcode <- map["barcode"]
        status <- map["status"]
        is_delete <- map["is_delete"]
        is_block <- map["is_block"]
        group_type <- map["group_type"]
        created_at <- map["created_at"]
        updated_at <- map["updated_at"]
        members_count <- map["members_count"]
        posts_count <- map["posts_count"]
        group_thumb <- map["group_thumb"]
        university_name <- map["university_name"]
        is_my_group <- map["is_my_group"]
        is_private_group <- map["is_private_group"]
        is_invited <- map["is_invited"]
        is_blocked <- map["is_blocked"]
        is_sub_admin <- map["is_sub_admin"]
        is_requested <- map["is_requested"]
        requests_count <- map["requests_count"]
        is_member <- map["is_member"]
        invitation_id <- map["invitation_id"]
        request_id <- map["request_id"]
        course_name <- map["course_name"]
        course_code <- map["course_code"]
    }
}

class PostGroup : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var groupList                                           :       [FeedsObject]?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        total <- map["total"]
        per_page <- map["per_page"]
        groupList <- map["data"]
        
    }
}

class FileList : Mappable {
    
    var id                                                   :       Int?
    var group_id                                             :       Int?
    var user_id                                              :       Int?
    var titleOfFile                                          :       String?
    var descriptionOfFile                                    :       String?
    var file_name                                            :       String?
    var created_at                                           :       String?
    var university_id                                        :       Int?
    var department_id                                        :       Int?
    var college_id                                           :       Int?
    var professor_id                                         :       Int?
    var course_code                                          :       Int?
    var course_name                                          :       String?
    var type                                                 :       Int?
    var document_type                                        :       Int?
    var creator                                              :       Int?
    var type_text                                            :       String?
    var year                                                 :       String?
    var language                                             :       String?
    var semester                                             :       Int?
    var is_publish                                           :       Int?
    var university_name                                      :       String?
    var professor_name                                       :       String?
    var note_type_name                                       :       String?
    var created_by                                           :       String?
    var base_url                                             :  String?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        group_id <- map["group_id"]
        user_id <- map["user_id"]
        titleOfFile <- map["title"]
        descriptionOfFile <- map["descriptionOfFile"]
        file_name <- map["file_name"]
        created_at <- map["created_at"]
        university_id <- map["university_id"]
        department_id <- map["department_id"]
        college_id <- map["college_id"]
        professor_id <- map["professor_id"]
        course_code <- map["course_code"]
        course_name <- map["course_name"]
        type <- map["type"]
        document_type <- map["document_type"]
        creator <- map["creator"]
        type_text <- map["type_text"]
        year <- map["year"]
        language <- map["language"]
        semester <- map["semester"]
        is_publish <- map["is_publish"]
        university_name <- map["university_name"]
        professor_name <- map["professor_name"]
        note_type_name <- map["note_type_name"]
        created_by <- map["created_by"]
        base_url <- map["base_url"]
    }
}

class SuggestionOrFriendListItem  : Mappable {
    
    var listOfFriend                                        :       PostObject?
    var listOfRequest                                        :       PostObject?
    var listOfSujjestion                                      :       PostObject?
    
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        listOfFriend <- map["friends"]
        listOfRequest <- map["requests"]
        listOfSujjestion <- map["suggestions"]
    }
}


class FriendItemList  : Mappable {
    
    var id                                        :       Int?
    var user_id                                        :       Int?
    var friend_user_id                                      :       Int?
    var is_read                                      :       Int?
    var is_follow                                      :       Int?
    var created_at                                      :       String?
    var friendProfile                                      :       FriendProfile?

    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        friend_user_id <- map["friend_user_id"]
        is_read <- map["is_read"]
        is_follow <- map["is_follow"]
        created_at <- map["created_at"]
        friendProfile <- map["friend_profile"]

    }
}

class RequestFriendList  : Mappable {
    
    var request_id                                      :       Int?
    var is_sent                                         :   Bool?
    var user_id                                          :       Int?
    var first_name                                    :       String?
    var last_name                                 :       String?
    var full_name                                       :       String?
    var profile_image                             :       String?
    var uni_name                             :       String?

    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        request_id <- map["request_id"]
        is_sent <- map["is_sent"]
        user_id <- map["user_id"]

        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
        uni_name   <- map["university_name"]
        
    }
}


class SuggestionList  : Mappable {
    
    var id                                      :       Int?
    var user_id                                         :   Int?
    var friend_user_id                                      :       Int?
    var is_read                                    :       Int?
    var is_follow                                 :       Int?
    var created_at                             :       String?
    
    var friendProfile                             :       FriendProfile?
    var myProfile                                   :     FriendProfile?
    
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        friend_user_id <- map["friend_user_id"]
        
        is_read <- map["is_read"]
        is_follow <- map["is_follow"]
        created_at <- map["created_at"]
        friendProfile <- map["friend_profile"]
        myProfile     <- map["my_profile"]
    }
}

class CVObject  : Mappable {
    
    var name                                      :       String?
    var university                                         :   String?
    var college                                      :       String?
    var myCvObj                                      :      MyCvObject?
    var nationalitiesList                           :       [NationalityList]?
    
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        name <- map["name"]
        university <- map["university"]
        college <- map["college"]
        nationalitiesList <- map["nationalities"]
        myCvObj     <- map["my_cv"]
    }
}


class NationalityList  : Mappable {
    
    var id                                      :       Int?
    var name                             :       String?
    
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}


class MyCvObject  : Mappable {
    
    var id                                      :       Int?
    var user_id                             :       Int?
    var email                             :       String?
    var phone                             :       String?
    var job_title                             :       String?
    var image                             :       String?
    var address                             :       String?
    var website                             :       String?
    var linkedin                             :       String?
    var nationality                             :       Int?
    var language                             :       String?
    var about_me                             :       String?
    var objective                             :       String?
    var experience                             :       String?
    var education                             :       String?
    var skills                             :       String?
    var references                             :       String?
    var nationality_name                             :       String?
    var path                             :       String?

    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        email <- map["email"]
        phone <- map["phone"]
        job_title <- map["job_title"]
        image <- map["image"]
        address <- map["address"]
        website <- map["website"]
        linkedin <- map["linkedin"]
        nationality <- map["nationality"]
        about_me <- map["about_me"]
        language <- map["language"]
        objective <- map["objective"]
        experience <- map["experience"]
        education <- map["education"]
        skills <- map["skills"]
        references <- map["references"]
        nationality_name <- map["nationality_name"]
        path <- map["path"]



    }
}


class GroupInfoObject  : Mappable {
    
    var id                                      :       Int?
    var post_type                               :       Int?
    var sender_id                               :       Int?
    var receiver_id                             :       Int?
    var group_name                              :       String?
    var group_logo                              :       String?
    var group_image                             :       String?
    var chatMembers                             :       [GroupChatMember]?
    var sender                                 :        UserGroupInfo?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        post_type <- map["post_type"]
        sender_id <- map["sender_id"]
        receiver_id <- map["receiver_id"]
        group_name <- map["group_name"]
        group_logo <- map["group_logo"]
        group_image <- map["group_image"]
        chatMembers <- map["chat_members"]
        sender <- map["sender"]
    }
}


class GroupChatMember  : Mappable {
    
    var id                                  :       Int?
    var user_id                             :       Int?
    var chat_id                             :       Int?
    var userInfo                            :      UserGroupInfo?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        chat_id <- map["chat_id"]
        userInfo <- map["user"]
        
        
    }
}

class UserGroupInfo  : Mappable {
    
    var id                                      :       Int?
    var first_name                             :       String?
    var last_name                             :       String?
    var full_name                             :       String?
    var profile_image                             :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
    }
}

class AvatarObject  : Mappable {
    
    var countriesList                                      :       [CountryList]?
    var avatarList                                         :       [AvatarsObject]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        countriesList <- map["countries"]
        avatarList <- map["avatars"]
    }
}



class CountryList  : Mappable {
    
    var id                               :       Int?
    var name                             :       String?
    var slug                             :       String?
    var status                           :       Int?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        status <- map["status"]
    }
}

class UniversityList  : Mappable {
    
    var id                               :       Int?
    var name                             :       String?
    var name_ar                             :       String?
    var slug                             :       String?
    var country_id                           :       Int?
    var campus_count                           :       Int?
    

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        name_ar <- map["name_ar"]
        country_id <- map["country_id"]
        campus_count <- map["campus_count"]

    }
}

class CampusList  : Mappable {
    
    var id                               :       Int?
    var name                             :       String?
    var name_ar                             :       String?
    var slug                             :       String?
    var country_id                           :       Int?
    var status                           :       Int?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        name_ar <- map["name_ar"]
        country_id <- map["country_id"]
        status <- map["status"]
        
    }
}

class CollegesList  : Mappable {
    
    var id                               :       Int?
    var name                             :       String?
    var name_ar                          :       String?
    var slug                             :       String?
    var university_id                    :       Int?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        name_ar <- map["name_ar"]
        university_id <- map["university_id"]
        
    }
}


class AvatarsObject  : Mappable {
    
    var id                               :       Int?
    var image                             :       String?
    var image_path                          :       String?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        image <- map["image"]
        image_path <- map["image_path"]
        
    }
}


class CourseObject  : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var courseList                        :      CourseList?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        courseList <- map["data"]

    }
}

class CourseList : Mappable {
    
    var previousCourse                                      :       CoursePage?
    var currentCourse                                       :       CoursePage?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        previousCourse <- map["previous_course"]
        currentCourse <- map["current_course"]
    }
}

class CoursePage : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var previousCourse                                      :       [PreviousCourseList]?
    var currentCourse                                       :       [CurrentCourseList]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        
        total <- map["total"]
        per_page <- map["per_page"]
        previousCourse <- map["data"]
        currentCourse <- map["data"]

        
    }
}

class PreviousCourseList : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var course_id                                         :       Int?
    var year                                                :       String?
    var semester                                           :       String?
    var grade_id                                               :       Int?
    var professor_id                                            :       Int?
    var feedback                                                :       String?
    var location                                                :       String?
    var type                                                :       Int?
    var notification                                                :       Int?
    var created_at                                                :       String?
    var my_course_name                                                :       String?
    var course_code                                                :       String?
    var grade_name                                                :       String?
    var professor_name                                                :       String?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        course_id <- map["course_id"]
        year <- map["year"]
        semester <- map["semester"]
        
        grade_id <- map["grade_id"]
        professor_id <- map["professor_id"]
        feedback <- map["feedback"]
        location <- map["location"]
        type <- map["type"]
        notification <- map["notification"]
        created_at <- map["created_at"]
        my_course_name <- map["my_course_name"]
        course_code <- map["course_code"]
        grade_name <- map["grade_name"]
        professor_name <- map["professor_name"]

        
    }
}


class CurrentCourseList : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var course_id                                         :       Int?
    var year                                                :       String?
    var semester                                           :       String?
    var grade_id                                               :       Int?
    var professor_id                                            :       Int?
    var feedback                                                :       String?
    var location                                                :       String?
    var type                                                :       Int?
    var notification                                                :       Int?
    var created_at                                                :       String?
    var my_course_name                                                :       String?
    var course_code                                                :       String?
    var grade_name                                                :       String?
    var professor_name                                                :       String?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        course_id <- map["course_id"]
        year <- map["year"]
        semester <- map["semester"]
        
        grade_id <- map["grade_id"]
        professor_id <- map["professor_id"]
        feedback <- map["feedback"]
        location <- map["location"]
        type <- map["type"]
        notification <- map["notification"]
        created_at <- map["created_at"]
        my_course_name <- map["my_course_name"]
        course_code <- map["course_code"]
        grade_name <- map["grade_name"]
        professor_name <- map["professor_name"]
        
        
    }
}


class GradesProfessorObject  : Mappable {

    var message                           :       String?
    var status                            :       Bool?
    var courseList                        :       CourseInfo?

    required init?(map: Map){

    }
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        courseList <- map["data"]

    }
}

class CourseInfo : Mappable {
    var grades : [Grades]?
    var questions : [Questions]?
    var courses : [Courses]?
    var professor : [Professor]?
    var weekdays : [Weekdays]?
    var semesters : [Semesters]?
    var year : [Int]?

   required init?(map: Map) {

    }

    func mapping(map: Map) {

        grades <- map["grades"]
        questions <- map["questions"]
        courses <- map["courses"]
        professor <- map["professor"]
        weekdays <- map["weekdays"]
        semesters <- map["semesters"]
        year <- map["0"]
    }

}


class Grades  : Mappable {

    var id : Int?
    var grade : String?
    var grade_value : String?
    var grade_level : String?

    required init?(map: Map){

    }
    func mapping(map: Map) {
        id <- map["id"]
        grade <- map["grade"]
        grade_value <- map["grade_value"]
        grade_level <- map["grade_level"]
    }
}

class Questions : Mappable {
    var id : Int?
    var subject : String?
    var options : [Options]?

    required init?(map: Map){

    }

    func mapping(map: Map) {

        id <- map["id"]
        subject <- map["subject"]
        options <- map["options"]
    }

}

class Options : Mappable {
    var id : Int?
    var question_id : Int?
    var name : String?

    required init?(map: Map){

    }

    func mapping(map: Map) {

        id <- map["id"]
        question_id <- map["question_id"]
        name <- map["name"]

    }

}

class Courses : Mappable {
    var id : Int?
    var name : String?
    var slug : String?
    var course_code : String?

    required init?(map: Map){

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        slug <- map["slug"]
        course_code <- map["course_code"]
    }

}

class Professor : Mappable {
    var id : Int?
    var name : String?


    required init?(map: Map){

    }

    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]

    }

}

class Weekdays : Mappable {
    var id : Int?
    var name : String?

    required init?(map: Map){

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}

class Semesters : Mappable {
    var id : Int?
    var name : String?

    required init?(map: Map){

    }

    func mapping(map: Map) {

        id <- map["id"]
        name <- map["name"]
    }

}

class AllMember  : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var groupInfo                         :       GroupList?
    var memberList                        :       GroupMemeber?
    var inviteUserList                    :       GroupMemeber?
    var requestUserList                   :       GroupMemeber?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        groupInfo <- map["data"]
        inviteUserList <- map["data"]
        requestUserList <- map["data"]
        memberList <- map["data"]

        
    }
}

class GroupMemeber : Mappable {
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var groupMember                                         :       [GroupMemberList]?
    var inviteMemeberList                                   :       [InviteMember]?
    var requestList                                         :       [RequestList]?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        
        total <- map["total"]
        per_page <- map["per_page"]
        groupMember <- map["data"]
        inviteMemeberList <- map["data"]
        requestList <- map["data"]

    }
}

class GroupMemberList : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var student_group_id                                         :       Int?
    var member_type                                                :       Int?
    var is_block                                           :       Int?
    var grade_id                                               :       Int?
    var status                                            :       Int?
    var is_admin                                                :       Bool?
    var is_sub_admin                                                :       Bool?
    var is_friend                                                :       Bool?
    var friend_request_sent                                                :       Bool?
    var friend_request_received                                                :       Bool?
    var friend_request_id                                                :       Int?
    var member_college_name                                                :       String?
    var professor_name                                                :       String?
    var user                                                 :       UserInfoObject?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        student_group_id <- map["student_group_id"]
        member_type <- map["member_type"]
        is_block <- map["is_block"]
        
        grade_id <- map["grade_id"]
        status <- map["status"]
        is_admin <- map["is_admin"]
        is_sub_admin <- map["is_sub_admin"]
        is_friend <- map["is_friend"]
        friend_request_sent <- map["friend_request_sent"]
        friend_request_received <- map["friend_request_received"]
        friend_request_id <- map["friend_request_id"]
        member_college_name <- map["member_college_name"]
        professor_name <- map["professor_name"]
        user <- map["user"]

        
    }
}

class InviteMember : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var email_address                                         :       String?
    var status                                                :       Int?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        email_address <- map["email_address"]
        status <- map["status"]
        
    }
}

class RequestList : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var student_group_id                                         :       Int?
    var status                                                :       Int?
    var user                                                 :       UserInfoObject?
    
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        student_group_id <- map["student_group_id"]
        status <- map["status"]
        user <- map["user"]
        
        
    }
}

class Book  : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var bookObj                           :       BookOject?
    var bookISBN                          :       BookISBN?
    var bookInfo                          :       BookAdd?
    var bookDetail                        :       BookList?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        bookObj <- map["data"]
        bookISBN <- map["data"]
        bookInfo <- map["data"]
        bookDetail <- map["data"]


        
    }
}


class BookOject : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var bookList                                            :       [BookList]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        total <- map["total"]
        per_page <- map["per_page"]
        bookList <- map["data"]
        
        
    }
}

class BookList : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var user_as                                         :       Int?
    var university_id                                                :       Int?
    var city                                           :       Int?
    var titleOfBook                                               :       String?
    var descriptionOfBook                                            :       String?
    var author                                                :       String?
    var price                                                :       String?
    var image                                                :       String?
    var imageUrl                                                :       String?

    var isbn                                                :       String?
    var course_code                                                :       String?
    var book_status                                                :       Int?
    var location                                                :       String?
    var type                                                :       Int?
    var is_publish                                                :       Int?
    var is_featured                                                :       Int?
    var status                                                :       Int?
    var is_favorite                                                :       Bool?
    var university_name                                                :       String?
    var book_cover                                                :       String?
    var book_city                                                :       String?
    var is_outside                                               :       Int?
    var edition                                                :       String?
    var book_status_name                                       :       String?
    var cover_type_name                                       :       String?
    var cover_type                                       :       String?

    

    var courseListsss                                               :       [UpdatedCoursesList]?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        user_as <- map["user_as"]
        university_id <- map["university_id"]
        city <- map["city"]
        
        titleOfBook <- map["title"]
        descriptionOfBook <- map["description"]
        author <- map["author"]
        price <- map["price"]
        image <- map["image"]
        imageUrl <- map["image_url"]

        isbn <- map["isbn"]
        edition <- map["edition"]

        course_code <- map["course_code"]
        book_status <- map["book_status"]
        location <- map["location"]
        type <- map["type"]
        is_publish <- map["is_publish"]
        is_featured <- map["is_featured"]
        status <- map["status"]
        university_name <- map["university_name"]
        book_cover <- map["book_cover"]
        book_city <- map["book_city"]
        is_outside <- map["is_outside"]
        book_status_name <- map["book_status_name"]
        cover_type <- map["cover_type"]
        cover_type_name <- map["cover_type_name"]
        
        courseListsss  <- map["courses"]
        
    }
}

class BookISBN : Mappable {
    
    var thumbnail                                         :       String?
    var title                                             :       String?
    var author                                            :       String?
    var descriptionOFBook                                 :       String?
    var reference_link                                    :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        thumbnail <- map["thumbnail"]
        title <- map["title"]
        author <- map["author"]
        descriptionOFBook <- map["description"]
        reference_link <- map["reference_link"]
        
        
    }
}

class BookAdd : Mappable {
    
    var citiesList                                            :        [CitiesList]?
    var course                                                :        [CoursesList]?
    var bookStatus                                            :        [BookStatus]?
    var bookCover                                             :        [BookCover]?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        citiesList <- map["cities"]
        course <- map["course"]
        bookStatus <- map["status"]
        bookCover <- map["cover"]
        
        
    }
}

class CitiesList : Mappable {
    
    var id                                              :       Int?
    var country_id                                      :       Int?
    var name                                            :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        country_id <- map["country_id"]
        name <- map["name"]
    }
}

class CoursesList : Mappable {
    
    var id                                        :       Int?
    var name                                      :       String?
    var course_code                               :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        course_code <- map["course_code"]
    }
}


class UpdatedCoursesList : Mappable {
    
    var id                                        :       Int?
    var course_id                                      :       Int?
    var bookstore_id                               :       Int?
    var course                                     :       CoursesList?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        course_id <- map["course_id"]
        bookstore_id <- map["bookstore_id"]
        course <- map["course_name"]

    }
}


class BookStatus : Mappable {
    
    var id                                        :       Int?
    var name                                      :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}

class BookCover : Mappable {
    
    var id                                        :       Int?
    var name                                      :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
    }
}





class Note  : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var note                              :       NoteOject?
    var noteDetail                        :       NoteList?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        note <- map["data"]
        noteDetail <- map["data"]
    }
}


class NoteOject : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var noteList                                            :       [NoteList]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        total <- map["total"]
        per_page <- map["per_page"]
        noteList <- map["data"]
        
        
    }
}

class NoteList : Mappable {
    
    var id                                        :       Int?
    var user_id                                      :       Int?
    var professor_id                                         :       Int?
    var university_id                                                :       Int?
    var titleOfNote                                               :       String?
    var descriptionOfNote                                            :       String?
    var course_code                                                :       Int?
    var course_name                                                :       String?
    var type                                                :       Int?
    var document_type                                                :       Int?
    var creator                                                :       Int?
    var year                                                :       String?
    var language                                                :       String?
    var is_publish                                                :       Int?
    var rate                                                :       Int?
    var note_course_code                                                :       String?
    var note_course_name                                                :       String?
    var university_name                                                :       String?
    var university_logo                                                :       String?
    var professor_name                                                :       String?
    var notes_type                                                :       String?
    var is_favorite                                                :       Bool?
    var created_by                                                 : String?
    var type_name                                                  : String?
    
    var notefileList                                                    :  [NotesFile]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        professor_id <- map["professor_id"]
        university_id <- map["university_id"]
        titleOfNote <- map["title"]
        
        descriptionOfNote <- map["description"]
        course_name <- map["course_name"]
        document_type <- map["document_type"]
        creator <- map["creator"]
        year <- map["year"]
        course_code <- map["course_code"]
        language <- map["language"]
        rate <- map["rate"]
        type <- map["type"]
        is_publish <- map["is_publish"]
        note_course_code <- map["note_course_code"]
        note_course_name <- map["note_course_name"]
        university_name <- map["university_name"]
        university_logo <- map["university_logo"]
        professor_name <- map["professor_name"]
        notes_type <- map["notes_type"]
        is_favorite <- map["is_favorite"]
        created_by <- map["is_favorite"]
        notefileList <- map["note_files"]
        type_name <- map["type_name"]

        
    }
}

class NotesFile : Mappable {
    
    var id                                        :       Int?
    var note_id                                      :       Int?
    var filename                                         :       String?
    var title                                                :       Int?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        note_id <- map["note_id"]
        filename <- map["filename"]
        title <- map["title"]
    }
}

class Job  : Mappable {
    
    var message                           :       String?
    var status                            :       Bool?
    var jobObj                           :       JobCategorieList?
    var jobDetail                        :       JobList?
    var company                          :       CompanyObject?
    var getAllApplication                :       JobsOject?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        message <- map["message"]
        status <- map["status"]
        jobObj <- map["data"]
        jobDetail <- map["data"]
        company <- map["data"]
        getAllApplication <- map["data"]

    }
}

class JobCategorieList : Mappable {
    
    var categorieList       :       [FilterCategorieJob]?
    var job                 :       JobsOject?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        categorieList <- map["categories"]
        job <- map["jobs"]
        
    }
}

class FilterCategorieJob : Mappable {
    
    var id                                        :       Int?
    var name                                      :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
        
    }
}



class JobsOject : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var jobList                                            :       [JobList]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        total <- map["total"]
        per_page <- map["per_page"]
        jobList <- map["data"]
        
        
    }
}

class JobList : Mappable {
    
    var id                                        :       Int?
    var company_id                                      :       Int?
    var category_id                                         :       Int?
    var job_type                                                :       Int?
    var university_id                                               :       String?
    var titleOfJob                                            :       String?
    var country_id                                                :       Int?
    var type                                                :       String?
    var availability                                                :       String?
    var nationality                                                :       Int?
    var salary                                                :       String?
    var start_date                                            :       String?
    var end_date                                            :       String?

    
    var status                                                :       Int?
    var city                                                :       Int?
    var created_at                                                :       String?
    var job_desc                                                :       String?
    var job_requirements                                                :       String?
    var job_skills                                                :       String?
    var job_other_benefits                                                :       String?
    
    var is_favorite                                                :       Bool?
    var user_cv                                                :       Bool?

    var company                                                    :  CompanyObject?
    var jobCategory                                                :  CategoryJob?
    var jobCity                                                    :  JobCity?
    var myApplication                                              :  MyApplication?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        company_id <- map["company_id"]
        category_id <- map["category_id"]
        job_type <- map["job_type"]
        university_id <- map["university_id"]
        titleOfJob <- map["title"]
        country_id <- map["country_id"]
        type <- map["type"]
        availability <- map["availability"]
        nationality <- map["nationality"]
        salary <- map["salary"]
        status <- map["status"]
        city <- map["city"]
        created_at <- map["created_at"]
        job_desc <- map["job_desc"]
        job_requirements <- map["job_requirements"]
        job_skills <- map["job_skills"]
        job_other_benefits <- map["job_other_benefits"]
        is_favorite <- map["is_favorite"]
        company <- map["company"]
        jobCategory <- map["category"]
        jobCity <- map["city_name"]
        myApplication <- map["my_application"]
        start_date <- map["start_date"]
        end_date <- map["end_date"]
        user_cv  <- map["user_cv"]

    }
}

class CompanyObject : Mappable {
    
    var id                                                :       Int?
    var first_name                                      :       String?
    var last_name                                         :       String?
    var email                                                :       String?
    var profile_picture                                           :       Int?
    var user_type                                               :       Int?
    var full_name                                            :       String?
    var profile_image                                            :       String?
    var companyInfo                                                    :  CompanyDetail?
    var companyJobs                                                    :  [JobList]?


    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        first_name <- map["first_name"]
        last_name <- map["last_name"]
        email <- map["email"]
        profile_picture <- map["profile_picture"]
        user_type <- map["user_type"]
        full_name <- map["full_name"]
        profile_image <- map["profile_image"]
        companyInfo <- map["company_detail"]
        companyJobs <- map["company_jobs"]
        
    }
}

class CompanyDetail : Mappable {
    
    var id                                                :       Int?
    var company_name                                      :       String?
    var user_id                                         :       Int?
    var logo                                                :       String?
    var company_logo                                           :       String?
    var company_desc                                               :       String?
    var telephone                                               :       String?
    var website                                               :       String?
    var address                                               :       String?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        company_name <- map["company_name"]
        user_id <- map["user_id"]
        logo <- map["logo"]
        company_logo <- map["company_logo"]
        company_desc <- map["company_desc"]
        telephone <- map["telephone"]
        website <- map["website"]
        address <- map["address"]

        
    }
}

class MyApplication : Mappable {
    
    var id                                                :       Int?
    var user_id                                      :       Int?
    var job_id                                         :       Int?
    var type                                                :       Int?
    var status                                           :       Int?
    var cover_letter                                               :       String?
    var job_cover_letter                                               :       String?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        user_id <- map["user_id"]
        job_id <- map["job_id"]
        type <- map["type"]
        status <- map["status"]
        cover_letter <- map["cover_letter"]
        job_cover_letter <- map["job_cover_letter"]

        
    }
}


class CategoryJob : Mappable {
    
    var id                                                :       Int?
    var name                                      :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
        
    }
}

class JobCity : Mappable {
    
    var id                                                :       Int?
    var name                                      :       String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        
        
    }
}

class WelcomeClassified : Mappable {
    var status: Bool?
    var message: String?
    var clasifiedObj : Classified?
    var subCategorieObj : SubCategories?
    var categoriesList : [Category]?
    var classifiedDetail : ClassifiedPost?

    var favItem : Post?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        clasifiedObj <- map["data"]
        subCategorieObj <- map["data"]
        favItem <- map["data"]
        categoriesList <- map["data"]
        classifiedDetail <- map["data"]

    }
   
}

class Classified : Mappable {
    
    var  posts: Post?
    var  category: [Category]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        posts <- map["posts"]
        category <- map["category"]
        
    }
}

class SubCategories : Mappable {
    
    var  subCategories : [Category]?
    var  formList : [FormList]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        subCategories <- map["categories"]
        formList <- map["form"]
        
    }
}




class Category: Mappable {
    
    var  id: Int?
    var  categoryTitle: String?
    var  categoryTitleAr : String?
    var  categoryTitleFr : String?
    var  categoryTitleTr: String?
    var  slug : String?
    var  categoryIcon: String?
    var  parentID : Int?
    var  isRemoved : Int?
    var  categoryPostsCount : Int?
    var  subCategoryPostsCount : Int?
    var  lastCategoryPostsCount : Int?
    var  lastCategoryCount : Int?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        categoryTitle <- map["category_title"]
        categoryTitleAr <- map["category_title_ar"]
        categoryTitleFr <- map["category_title_fr"]
        categoryTitleTr <- map["category_title_tr"]
        slug <- map["slug"]
        categoryIcon <- map["category_icon"]
        parentID <- map["parent_id"]
        isRemoved <- map["is_removed"]
        categoryPostsCount <- map["category_posts_count"]
        subCategoryPostsCount <- map["sub_category_posts_count"]
        lastCategoryPostsCount <- map["last_category_posts_count"]
        lastCategoryCount <- map["last_category_count"]
  }

}

class FormList : Mappable {
    
    var  list_item_id : Int?
    var  title_english: String?
    var  category_id : Int?
    var  field_name : String?
    var  type : Int?
    var  status : Int?
    var  name : String?
    var  value : String?

    var  optionList : [OptionList]?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        list_item_id <- map["list_item_id"]
        title_english <- map["title_english"]
        category_id <- map["category_id"]
        field_name <- map["field_name"]
        type <- map["type"]
        status <- map["status"]
        optionList <- map["options"]
        name <- map["name"]
        value <- map["value"]

    }
    
}


class Post : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var classifiedObj                                         :       [ClassifiedPost]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        
        total <- map["total"]
        per_page <- map["per_page"]
        classifiedObj <- map["data"]
    }
}

class ClassifiedPost : Mappable {
    
    var  id : Int?
    var  categoryID : Int?
    var  subCategoryID : Int?
    var  subSubCategory: Int?
    
    var lastSubCategory : Int?
    var  lastCategoryID : Int?
    var  countryID : Int?
    var cityID : Int?
    var  userID : Int?
    var userAs  : Int?
    var  postTitle : String?
    var  postImage: String?
    
    var phone: String?
    var price: String?
    var datumDescription : String?
    var location: String?
    var age : Int?
    var usage : Int?
    var condition : Int?
    var brand: Int?
    
    var warranty : Int?
    var rating : Int?
    var  duration : Int?
    var ticketNo: Int?
    var kilometer : String?
    var bodyCondition : String?
    var mechanicalCondition: String?
    
    var year: Int?
    var vinNumber: Int?
    var bodyType : Int?
    var bodyColor : Int?
    var transmissionType : Int?
    var regionalSpecs: Int?
    
    var  noOfCylinders : Int?
    var doors : Int?
    var horsepower : Int?
    var fuelType: Int?
    var extras: Int?
    var lat : String?
    var long: String?
    var sellerType : Int?
    var length: Int?
    var  make : String?
    var model : String?
    var capacityWeight: String?
    var  wheels : Int?
    var manufacturer : Int?
    var engineSize: Int?
    var budget: Int?
    var status : Int?
    var isDelete: Int?
    var dateCreated: String?
    var  mainCategory: String?
    var subCategoryName : String?
    var subSubCategoryName : String?
    var lastSubCategoryName: String?
    var  lastCategoryName: String?
    var countryName: String?
    var  ageName : String?
    var usageName: String?
    var conditionName : String?
    
    var brandName: String?
    var warrantyName: String?
    var bodyConditionName : String?
    var mechanicalConditionName: String?
    var yearName: String?
    var bodyTypeName: String?
    var bodyColorName: String?
    var transmissionName: String?
    var  regionalSpecName: String?
    var cylinderName: String?
    var doorsName: String?
    var horsepowerName: String?
    var fuelTypeName: String?
    var sellerTypeName: String?
    var makerName : String?
    var modelName: String?
    var image_path: String?
    var is_favorite: Bool?
    var postImages: [PostImage]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {

        id <- map["id"]
        categoryID <- map["category_id"]
        subCategoryID <- map["sub_category_id"]
        subSubCategory <- map["sub_sub_category"]
        lastSubCategory <- map["last_sub_category"]
        lastCategoryID <- map["last_category_id"]
        countryID <- map["country_id"]
        cityID <- map["city_id"]
        userID <- map["user_id"]
        userAs <- map["user_as"]
        postTitle <- map["post_title"]
        postImage <- map["post_image"]
        phone <- map["phone"]
        price <- map["price"]
        datumDescription <- map["description"]
        location <- map["location"]
        age <- map["age"]
        usage <- map["usage"]
        condition <- map["condition"]
        brand <- map["brand"]
        warranty <- map["warranty"]
        rating <- map["rating"]
        duration <- map["duration"]
        ticketNo <- map["ticket_no"]
        kilometer <- map["kilometer"]
        bodyCondition <- map["body_condition"]
        mechanicalCondition <- map["mechanical_condition"]
        year <- map["year"]
        vinNumber <- map["vin_number"]
        bodyType <- map["body_type"]
        bodyColor <- map["body_color"]
        transmissionType <- map["transmission_type"]
        regionalSpecs <- map["regional_specs"]
        noOfCylinders <- map["no_of_cylinders"]
        doors <- map["doors"]
        //
        horsepower <- map["horsepower"]
        fuelType <- map["fuel_type"]
        extras <- map["extras"]
        lat <- map["lat"]
        long <- map["long"]
        sellerType <- map["seller_type"]
        length <- map["length"]
        make <- map["make"]
        //
        model <- map["model"]
        capacityWeight <- map["capacity_weight"]
        wheels <- map["wheels"]
        manufacturer <- map["manufacturer"]
        engineSize <- map["engine_size"]
        budget <- map["budget"]
        status <- map["status"]
        isDelete <- map["is_delete"]
        dateCreated <- map["date_created"]
        mainCategory <- map["main_category"]
        subCategoryName <- map["sub_category_name"]
        subSubCategoryName <- map["sub_sub_category_name"]
        lastSubCategoryName <- map["last_sub_category_name"]
        lastCategoryName <- map["last_category_name"]
        countryName <- map["country_name"]
        ageName <- map["age_name"]
        usageName <- map["usage_name"]
        conditionName <- map["condition_name"]
        warrantyName <- map["warranty_name"]
        bodyConditionName <- map["body_condition_name"]
        mechanicalConditionName <- map["mechanical_condition_name"]
        yearName <- map["year_name"]
        bodyTypeName <- map["body_type_name"]
        bodyColorName <- map["body_color_name"]
        transmissionName <- map["transmission_name"]
        regionalSpecName <- map["regional_spec_name"]
        cylinderName <- map["cylinder_name"]
        doorsName <- map["doors_name"]
        horsepowerName <- map["horsepower_name"]
        fuelTypeName <- map["fuel_type_name"]
        sellerTypeName <- map["seller_type_name"]
        makerName <- map["maker_name"]
        modelName <- map["model_name"]
        image_path <- map["image_path"]
        
        is_favorite <- map["is_favorite"]
        postImages <- map["post_images"]


    }
}

class PostImage : Mappable {
    var  id : Int?
    var  postID: Int?
    var  name: String?
    var  type: Int?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        postID <- map["post_id"]
        name <- map["name"]
        type <- map["type"]
    }
}


class CreateClassified : Mappable {
    var status: Bool?
    var message: String?
    var classifiedList : [CategoriesList]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        classifiedList <- map["data"]
    }
    
}

class CategoriesList : Mappable {
    var  id: Int?
    var  categoryTitle : String?
     var slug        : String?
    var  parent_id: Int?
    var  is_removed : Int?
    var  formList : [FormList]?
    var  subCategoriesList  : [SubCategoriesList]?

    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        categoryTitle <- map["category_title"]
        parent_id <- map["parent_id"]
        is_removed <- map["is_removed"]
        slug <- map["slug"]

        formList <- map["form_fields"]
        subCategoriesList <- map["children"]
    }
}

class SubCategoriesList : Mappable {
    var  id: Int?
    var  categoryTitle : String?
    var  parent_id: Int?
    var  is_removed : Int?
    var subSubCat  :  [SubsubCategoriesList]?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        categoryTitle <- map["category_title"]
        parent_id <- map["parent_id"]
        is_removed <- map["is_removed"]
        subSubCat  <- map["children"]
    }
    
}

class SubsubCategoriesList : Mappable {
    var  id: Int?
    var  categoryTitle : String?
    var  parent_id: Int?
    var  is_removed : Int?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        id <- map["id"]
        categoryTitle <- map["category_title"]
        parent_id <- map["parent_id"]
        is_removed <- map["is_removed"]
    }
    
}


class OptionList : Mappable {
    var  list_item_id: Int?
    var  title_english : String?
    var  parent_id: Int?
    var  category_id : Int?
    var  type       : Int?
    var  field_name  : String?
    var formList : [FormList]?
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        list_item_id <- map["list_item_id"]
        title_english <- map["title_english"]
        parent_id <- map["parent_id"]
        category_id <- map["category_id"]
        type <- map["type"]
        field_name <- map["field_name"]

    }
}


class WelcomeSolution : Mappable {
    var status: Bool?
    var message: String?
    var solutin : SolutionList?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        solutin <- map["data"]

    }
   
}

class SolutionList : Mappable {
    
    var current_page                                        :       Int?
    var first_page_url                                      :       String?
    var nextPageUrl                                         :       String?
    var from                                                :       Int?
    var last_page                                           :       Int?
    var total                                               :       Int?
    var per_page                                            :       Int?
    var listOfSolution                                      :       [Solution]?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        current_page <- map["current_page"]
        first_page_url <- map["first_page_url"]
        from <- map["from"]
        last_page <- map["last_page"]
        nextPageUrl <- map["next_page_url"]
        
        total <- map["total"]
        per_page <- map["per_page"]
        listOfSolution <- map["data"]
    }
}

class Solution : Mappable {
    
    var  id: Int?
    var  question: String?
    var  latex : String?
    var  titleOfLatex : String?
    var  category_id: Int?
    var  sub_category_id : Int?
    var  sub_sub_category_id : Int?
    var  country_id : Int?
    var  user_id : Int?
    var  status : Int?
    var  category_name : String?
    var  sub_category_name : String?
    var  sub_sub_category_name : String?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        id <- map["id"]
        question <- map["question"]
        latex <- map["latex"]
        titleOfLatex <- map["title"]
        category_id <- map["category_id"]
        sub_category_id <- map["sub_category_id"]
        sub_sub_category_id <- map["sub_sub_category_id"]
        country_id <- map["country_id"]
        user_id <- map["user_id"]
        status <- map["status"]
        category_name <- map["category_name"]
        sub_category_name <- map["sub_category_name"]
        sub_sub_category_name <- map["sub_sub_category_name"]

    }
}

class WelcomeUnreadMessage : Mappable {
    var status: Bool?
    var message: String?
    var objOfUnreadMsg : UnreadMessageList?

    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        status <- map["status"]
        message <- map["message"]
        objOfUnreadMsg <- map["data"]

    }
}

class UnreadMessageList : Mappable {
    var unread                                        :       Int?
    
    required init?(map: Map){
        
    }
    func mapping(map: Map) {
        unread <- map["unread"]
    }
}
