//
//  AuthEndpoint.swift
//  Grubs-up
//
//  Created by Ahmed Durrani on 25/05/2019.
//  Copyright © 2019 CyberHost. All rights reserved.
//

import Foundation
import UIKit

enum AuthEndpoint : Endpoint {
    
    case login(email: String, password: String ,  client_id : String , client_secret : String , scope : String , grant_type : String)
    
    case updateProfile(firstName: String, lastName: String ,password : String , confirmPassword : String , dob : String , phoneNumber : String, profilePicture: String)
    case primaryEmail(email: String)

    case feedsList
    case profile
    case reactOnPost(postId : String , reaction : String)
    case getPaginationRequest(typeId: String)
    case getSearchResult(search : String)
    case fav(postId : String)
    case unFav(postId : String)
    case noteFav(noteId : String)
    case classfiedFav(noteId : String)

    
    case postView(postId : String)
    case comment(postId : String , comment : String)
    case replyComment(postId : String , comment : String , comment_id : String)
    case voteOnPoll(postId : String ,  option_id : String)
    case updloadPoll(group_id : String ,  group_barcode : String  , type : String , comment : String  , is_anonymous : String , disable_comments : String , options : [String: Any])
    case updloadPost(group_id : String ,  group_barcode : String  , type : String , comment : String  , is_anonymous : String , disable_comments : String)

    var path: String {
        switch self {
        case .login(_,_,_,_,_,_):
            return "oauth/login"
        case .updateProfile(_,_,_,_,_,_,_):
            return "account/profile/update"
        case .feedsList:
            return "user/wall"
        case .profile :
            return "account/profile"
        case .reactOnPost(_ , _):
            return  "post/react"
        case .getPaginationRequest(_):
            return "user/wall"
        case .fav(_):
            return "post/favorite"
        case .noteFav(_):
            return "notes/favorite"
        case .classfiedFav(_):
            return "classifieds/favorite"
        case .postView(_) :
            return "post/view"
        case .comment(_ , _):
            return "comments/store"
        case .replyComment(_ , _ , _):
            return "comments/reply"
        case .unFav(_) :
            return "favorites/remove"
        case .voteOnPoll(_ , _) :
            return "post/vote"
        case .updloadPost(_ , _ , _ , _ , _ , _) :
            return "post/store"
        case .updloadPoll(_ , _ , _ , _ , _ , _ ,_) :
            return "post/store"
            
        case .getSearchResult(_) :
            return "user/wall"
        case .primaryEmail(_):
            return "account/profile/primary/email"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login(_,_,_,_,_,_):
            return .post
            
        case .updateProfile(_,_,_,_,_,_,_):
            return .put
            
        case .feedsList:
            return .get
        case .profile:
            return .get
        case .reactOnPost(_ , _):
            return .put
        case .getPaginationRequest(_):
            return .get
        case .fav(_):
            return .put
        case .postView (_) :
            return .get
        case .comment(_ , _) :
            return .post
        case .replyComment(_ , _ , _):
            return .post

        case .voteOnPoll(_ , _):
            return .post

        case .unFav( _ ):
            return .put
        case .updloadPoll(_ , _ , _ , _ , _ , _ , _ ) :
            return .post
        case .updloadPost(_ , _ , _ , _ , _ , _ ) :
            return .post
        case .getSearchResult(let search):
            return .get
        case .primaryEmail(_):
            return .post
        case .noteFav(let noteId):
            return .put
        case .classfiedFav(let noteId):
            return .delete
        }
    }
    
    var contentType: HTTPContentType {
        switch self {
            
        case .updateProfile(_,_,_,_,_,_,_):
            return .form
            
        case .primaryEmail(_):
            return .form
        case .comment(_ , _) :
            return .form
        case .replyComment(_ , _ , _ ) :
            return .form
        case .voteOnPoll(_ , _ ) :
            return .form
        default:
            return .form
        }
    }
    
    var query: HTTPParameters {
        var query = HTTPParameters()
        switch self {
        case .getPaginationRequest(let pageNum):
            query["page"] = pageNum
        case .getSearchResult(let q ):
            query["q"] = q

        default:
            break
        }
        return query
    }


//    var contentType: HTTPContentType {
//        switch self {
//        case .uploadDocument(_,_,_):
//            return .multipart
//        default:
//            return .form
//        }
//    }

//    var query: HTTPParameters {
//        var query = HTTPParameters()
//        switch self {
//        case .reactOnPost(let postId , let react)
//
//        default:
//            break
//        }
//        return query
//    }

    var body: HTTPParameters {
        var body = HTTPParameters()
        
//        var body: [String: Any] = [:]

        switch self {
        case .login(let email, let password , let client_id , let client_secret , let scope , let grant_type ):
            body["username"] = email
            body["password"] = password
            body["client_id"] = client_id
            body["client_secret"] = client_secret
            body["scope"] = scope
            body["grant_type"] = grant_type


        case .updateProfile(let firstName, let lastName , let password , let confirmPassword , let dob , let phoneNumber , let profilePicture):
            body["first_name"] = firstName
            body["last_name"] = lastName
            body["profile_picture"] = profilePicture
            body["password"] = password
            body["date_of_birth"] = dob
            body["phone"] = phoneNumber
            body["password_confirmation"] = confirmPassword
            
        case .comment(let postId , let comment) :
            body["post_id"] = postId
            body["comment"] = comment
        case .replyComment(let postId , let comment , let commentId) :
            body["post_id"] = postId
            body["comment"] = comment
            body["comment_id"] = commentId
        case .voteOnPoll(let postId , let optionId):
            body["post_id"] = postId
            body["option_id"] = optionId

        case .updloadPost(let groupId , let  group_barcode, let  type, let  comment, let  is_anonymous , let  disable_comments) :
            body["group_id"] = groupId
            body["group_barcode"] = group_barcode
            body["type"] = type
            body["comment"] = comment
            body["is_anonymous"] = is_anonymous
            body["disable_comments"] = disable_comments
        case .updloadPoll(let groupId , let  group_barcode, let  type, let  comment, let  is_anonymous , let  disable_comments, let   options ) :
            body["group_id"] = groupId
            body["group_barcode"] = group_barcode
            body["type"] = type
            body["comment"] = comment
            body["is_anonymous"] = is_anonymous
            body["disable_comments"] = disable_comments
            body  = options as! HTTPParameters
            
        case .primaryEmail(let email) :
            body["email"] = email
            
        default:
            break
        }
        return body
    }

    var multipart: [HTTPMultipart] {
        var multipart: [HTTPMultipart] = []

        return multipart
    }
}

