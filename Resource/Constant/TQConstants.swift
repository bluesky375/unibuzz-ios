//
//  ZGConstants.swift
//  ZoGoo
//
//  Created by Salman Nasir on 20/02/2017.
//  Copyright © 2017 Salman Nasir. All rights reserved.
//

import UIKit
  


  struct setBoarder {
    let view : UIView?
    let width : CGFloat?
    let color : UIColor?
    
    @discardableResult  init(view: UIView, width: CGFloat , color : UIColor ) {
        self.view = view
        self.width  = width
        self.color  = color
        view.layer.borderColor = color.cgColor
        view.layer.borderWidth = 1
        
        

    }
}

enum UBUserReaction : Int
{
    case Like = 0 ,
    Dislike ,
    Happy ,
    UserAngry = 5
    
    
}

enum TQActionType: Int {
    case TQLogin = 0,
    TQSignup,
    TQForgetPassword ,
    TQSkip
}

var DEVICE_TOKEN: String = ""
let SCREEN_WIDTH = UIScreen.main.bounds.width
let SCREEN_HEGHT = UIScreen.main.bounds.height
var DEVICE_LAT =  0.0
var DEVICE_LONG = 0.0
var DEVICE_ADDRESS = ""
var SELECTUSER = ""
var APPVERSION = ""



let IS_IPHONE_5 = (UIScreen.main.bounds.width == 320)
let IS_IPHONE_6 = (UIScreen.main.bounds.width == 375)
let IS_IPHONE_6P = (UIScreen.main.bounds.width == 414)

//LIVE URL

let APPID  =  "9B701345-7241-41B8-8FE6-ADF7A6854B6E"



//  API Contant


let secretKEY = ""
let API_PREFIX = "hrUEGwqQDyqZEsekXHleDKyPKjIyRL"

  let ROOT_URL = "http://138.68.245.84/" ; // DEV SERVER

//let ROOT_URL = "https://uni.buzz/" ; // LIVE SERVER

let BASE_URL  =  "\(ROOT_URL)api/v2/\(API_PREFIX)/" // DEV SERVER URL


let ROOT_URLFORSOCKET = "http://138.68.245.84:3000"; // DEV SERVER

//let ROOT_URLFORSOCKET = "https://uni.buzz:3000/"; // LIVE SERVER
//


let PDFBASE_URL = "\(ROOT_URL)uploads/notes/"
let CLASSIFIEDBASEURL = "\(ROOT_URL)template/icons/classified/"

let BOOKIMAGEBASEURL = "\(ROOT_URL)/uploads/bookstore/thumb_300/"

// let PDF
//let PDFBASE_URL  =  "http://192.168.1.12:8080/api/v2/uploads/notes/"
//
//let CLASSIFIEDBASEURL  =  "http://192.168.1.12:8080/api/v2/template/icons/classified/"



let SIGNUP = BASE_URL + "oauth/register"
let FORGOTPASSWORD = BASE_URL + "oauth/forget"
let GETGROUP = BASE_URL + "post/store"
let USERWALL = BASE_URL + "user/wall"
let POSTRECT = BASE_URL + "post/react"
let POSTFAV = BASE_URL + "post/favorite"
let POSTUNFAV = BASE_URL + "favorites/remove"


let HIDEPOST = BASE_URL + "post/hide"
let REPORT = BASE_URL + "post/report"
let POSTVIEW = BASE_URL + "post/view"

let ADDCOMMENT = BASE_URL + "comments/store"
let INBOX = BASE_URL + "inbox"
let INBOXCHAT = BASE_URL + "inbox/chat"
let CHATMESSAGE = BASE_URL + "inbox/chat/message"
let FRIENDLIST = BASE_URL + "friends/index"
let CREATEGROUP = BASE_URL + "inbox/group/store"
let GROUPLIST = BASE_URL + "groups/"
let GROUPVIEW = BASE_URL + "groups/view/"
let FILEVIEW = BASE_URL + "groups/files/"
let FILECREATE = BASE_URL + "groups/files/create"
let FILESTORE = BASE_URL + "groups/files/store"
let FRIENDLISTOFGROUP = BASE_URL + "groups/members/"


let REPLYCOMMENT = BASE_URL + "comments/reply"
let VOTE = BASE_URL + "post/vote"
let GROUPINVITATION = BASE_URL + "groups/invitations/invite"

let GROUPCREATE = BASE_URL + "groups/android/store"
let GROUPUPDATE = BASE_URL + "groups/update"
let JOINGROUPREQUEST = BASE_URL + "groups/requests/join/"
let CANCELGROUPREQUEST = BASE_URL + "groups/requests/cancel/"
let CANCELINVITE = BASE_URL + "groups/invitations/cancel/"
let COMMENTLOAD = BASE_URL + "comments/load/"

let PROFILE = BASE_URL + "account/profile"
let UPDATEPROFILE = BASE_URL + "account/profile/update"

let ALLFRIENDLIST = BASE_URL + "friends/all"
let UNFOLLOWFRIEND = BASE_URL + "friends/unfollow/"
let FOLLOWFRIEND = BASE_URL + "friends/follow/"
let UNFRIEND = BASE_URL + "friends/unfriend/"
let REJECT = BASE_URL + "friends/requests/reject/"
let ACCEPT = BASE_URL + "friends/requests/accept/"
let CANCEL = BASE_URL + "friends/requests/cancel/"
let SEND = BASE_URL + "friends/requests/send/"
let REPORTCOMMENT = BASE_URL + "comments/report"
let UPDATEPOST = BASE_URL + "post/update"
let GETMYGPA = BASE_URL + "mygpa/get"
let GETMYGPA2 = "mygpa/get"
let DELETECHAT = BASE_URL + "inbox/chat/destroy/"
let BLOCKEDUSER = BASE_URL + "user/block/"
let CVGET = BASE_URL + "mycv/get"
let CREATECV = BASE_URL + "mycv/create"
let GROUPINFO = BASE_URL + "inbox/group/info/"
let DESTROY = BASE_URL + "inbox/group/"
let DESTROYGROUP = BASE_URL + "inbox/group/destroy/"
let LEAVEGROUP = BASE_URL + "inbox/group/"
let FRIENDADD = BASE_URL + "inbox/group/"
let ADDMEMBERSINGROUP = BASE_URL + "inbox/group/members/add"
let COUNTRYLIST = BASE_URL + "oauth/register"
let UNIVERSITYLISt = BASE_URL + "university/country/"
let CAMPUSLIST = BASE_URL + "university/campus/"
let COLLEGELIST = BASE_URL + "university/college/"
let UPDATECV = BASE_URL + "mycv/update"
let POSTDESTROY = BASE_URL + "post/destroy/"
let DESTROYCOMMENT = BASE_URL + "comments/destroy/"
let LOGOUT = BASE_URL + "oauth/logout"
let USERPOST = BASE_URL + "user/posts"
let FAVOURITE = BASE_URL + "favorites/index"
let STARTNEWCHAT = BASE_URL + "inbox/chat"
let ACCEPTINVITATION = BASE_URL + "groups/invitations/accept/"

let REJECTREQUEST = BASE_URL + "groups/invitations/reject/"
let LEAVEGROUPOGGROUP = BASE_URL + "groups/leave/"
let FORWARDMESSAGE = BASE_URL + "inbox/chat/message/forward"
let COURSES = BASE_URL + "groups/courses"

let DELETEMESSAGE = BASE_URL + "inbox/chat/"
let MYCOURSE = BASE_URL + "mycourses/get"
let MYCOURSEDESTROY = BASE_URL + "mycourses/destroy/"
let MYCOURSECREATE = BASE_URL + "mycourses/create?tab="
let INVITATION = BASE_URL + "groups/invitations/get/"
let GROUPREQUEST = BASE_URL + "groups/requests/get/"
let ACCEPTREQUEST = BASE_URL + "groups/requests/accept/"
let REJECTREQUESTSS = BASE_URL + "groups/requests/reject/"
let CANCELINVITATION = BASE_URL + "groups/invitations/cancel/"
let INVITE = BASE_URL + "groups/invitations/invite/"
let MYNOTELIST = BASE_URL + "notes/index"
let NOTESFAV = BASE_URL + "notes/favorite/"
let NOTEVIEW = BASE_URL + "notes/view/"
let NOTESSAVED = BASE_URL + "notes/saved"
let BOOKSTORE = BASE_URL + "books/index"
let FREEBOOK = BASE_URL + "books/free"
let BOOKISBN = BASE_URL + "books/isbn/"
let BOOKADD = BASE_URL + "books/add"
let ADDBOOK = BASE_URL + "books/store"
let MYBOOK = BASE_URL + "books/my"
let DESTROYBOOK = BASE_URL + "books/destroy/"
let BOOKVIEW = BASE_URL + "books/view/"
let UPDATEBOOK = BASE_URL + "books/update/"
let JOBLIST = BASE_URL + "jobs/index"

let JOBFAV = BASE_URL + "jobs/favorite/"
let JOBVIEW = BASE_URL + "jobs/view/"
let APPLIEDJOB = BASE_URL + "jobs/apply"
let JOBAPPLICATION = BASE_URL + "jobs/applications"

let COMPANYVIEW = BASE_URL + "jobs/company/"
let CONTACTSELLER = BASE_URL + "books/contact"
let CLASSIFIED = BASE_URL + "classifieds/get"
let SUBCATORIESVIEW = BASE_URL + "classifieds/sub/category/"
let CLASSIFIEDCATEGORIES = BASE_URL + "classifieds/category/"
let CLASSIFIEDFAV = BASE_URL + "classifieds/favorite/"
let CLASSIFIEDSAVE = BASE_URL + "classifieds/saved"

let USERCLASSIFIED = BASE_URL + "classifieds/user/post"
let DELETECLASSIFIED = BASE_URL + "classifieds/destroy/"

let CLASSIFIEDCONTACTSELLER = BASE_URL + "classifieds/contact"
let CATEGORIESLIST = BASE_URL + "classifieds/create"
let CLASSIFIEDFORM = BASE_URL + "classifieds/form/"
let CLASSIFIEDCREATE = BASE_URL + "classifieds/create"
let FRIENDSCHECK = BASE_URL + "friends/check/"
let EDITCLASSIFIED = BASE_URL + "classifieds/form/edit/"

let CLASSFIFIEDUPDATE = BASE_URL + "classifieds/update"
let BOOKDETAIL = BASE_URL + "books/view/"
let CLASSIFIEDVIEW = BASE_URL + "classifieds/view/"
let NEWCHAT = BASE_URL + "inbox/chat/new/ios"
let SOLUTIONLIST = BASE_URL + "notes/solution/index"

let UNREADMESSAGECOUNT = BASE_URL + "inbox/chat/unread"
let NOTIFICATIONS = BASE_URL + "notifications/index?page="
let MARKASREADNOTIFICATIONS = BASE_URL + "notifications/read/all"
let CATEGORIES = BASE_URL + "notes/category"
let FILTERCATEGORIES = BASE_URL + "notes/android/category"
let EVENTTYPE = BASE_URL + "groups/events/type"
let CREATEEVENT = BASE_URL + "groups/events/store"
let UPDATEEVENT = BASE_URL + "groups/events/update"
let ALLEVENT = BASE_URL + "groups/events/"
let DELETEEVENT = BASE_URL + "groups/events/destroy/"




//mycourses/create?tab=pr






var firstPageUrl : String?





//let ALLINTEREST = BASE_URL + "interest/interests"
//let UPDATEINTEREST = BASE_URL + "interest/update"
//let HEALTHGOAL = BASE_URL + "userapi/healthgoal"
//let GETALLUSERDETAIL = BASE_URL + "userapi/user"
//let ADDFOODTODAY = BASE_URL + "userapi/foodtoday"
//let ADDKITCHEN = BASE_URL + "userapi/kitchen"
//let ADDEXERCISE = BASE_URL + "userapi/updateexercise"

//weak var localUserData: UserInformation!


let kUserNameRequiredLength: Int = 3
let kValidationMessageMissingInput: String = "Please fill all the fields".localized()
let kEmptyString: String = "".localized()
let kPasswordRequiredLength: Int = 6
let kUserNameRequiredLengthForPhone: Int = 9
let kValidationMessageMissingInputPhone : String = "Please give the proper phone Number".localized()

let KValidationPassword : String = "Password must be greater 5 digits".localized()
let kValidationEmailInvalidInput: String = "Please enter valid Email Address".localized()
let kValidationEmailEmpty : String = "email can't be blank".localized()
let kValidationPasswordEmpty : String = "Password can't be blank".localized()
let kValidationPhoneNumEmpty : String = "Phone Number can't be blank".localized()

let kUpdateTokenMessage: String = "user does not exists".localized()
let KMessageTitle: String = "Uni Buzz".localized()
let KChoseCategory: String = "Choose Category".localized()

let CURRENT_DEVICE = UIDevice.current
let KIDNumberValidat : String = "Id Number can't be blank".localized()
let KIMAGeSELECT : String = "Please Select the image".localized()

let kValidationNameInput: String = "Please Enter the name".localized()
let kValidationNameInputCharacter : String = "Full Name must be alphabet characters.\n".localized()
let kValidationConfirmPasswordEmpty : String = "Confirm Password can't be blank".localized()
let KPasswordMismatch : String = "Password mismatch".localized()



let kValidationCardNumInput: String = "Card Number can't be blank".localized()
let kValidationCardHolderNameInput: String = "Card Holder Name can't be blank".localized()
let kValidationCardHolderNameInputCharacter : String = "Card Holder Name must be alphabet characters.\n".localized()
let kValidationCardExpiryDate : String = "Expiry date can't be blank".localized()
let kValidationCardCcvNum : String = "Ccv Number  can't be blank".localized()
let KValidationOFInternetConnection : String = "No Internet Connection".localized()

//weak var localUserData: UserObjectInfo!



let MAIN                           = UIStoryboard(name: "Main", bundle: nil)
let HOME                           = UIStoryboard(name: "Home", bundle: nil)


struct VCIdentifier {
//   User ViewControllers
    static let KINTOVC = "BLIntoViewController"
    static let kForgotPasswordController = "GSForgotPasswordVC"
    static let KUBLOGIN = "UBLoginVC"
    static let KDMSIGNUPSelection = "GSSignUpSelectionVC"
    static let KTABBARCONTROLLER = "UBTabBarController"
    static let KHCCHATLISt = "HCChatListVC"
    static let KHCInterentListVC = "HCInterestListVC"
    static let KHCSelectGOal = "HCSelectGoalVC"
    static let KHCSTARTVC = "HCStartVC"

    
    
    
//    static let kEmployeeChatVC = "EmployeeChatViewController"
//    static let kEmployeeEditProfile = "EmployeeEditProfile"
//    static let kEmployeeNotification = "EmployeeNotification"
}



//

let kUserId                 : String = "user_id"
let kFirstName              : String = "firstname"
let kLastName               : String = "lastname"
let KFullName               : String = "fullname"
let KPhoneNum               : String = "phoneNumber"

let kEmail                  : String = "email"
let kPassword               : String = "password"

let kConfirmPassword        : String = "confirmPassword"
let KNewPassword               : String = "newPassword"
let KIdNumver               : String = "idNumber"

let KType                   : String  = "type"
let KCategory                   : String  = "category"
let KCountry                 : String  = "country"
let KCity                : String  = "city"
let KCompany                : String  = "company"



let KCODE                    : String = "code"
let KRESENTCODE              : String = "code"

let kSocialId               : String = "social_id"
let kProfileImage           : String = "profile_image"
let kSignupType             : String = "signup_type"
let kLatitude               : String = "latitute"
let kLongitude              : String = "longitude"
let kDevice                  : String = "device"
let KDeviceID                  : String = "deviceid"



let kDeviceTOken              : String = "deviceToken"
let KImageFileName                : String = "profilePicture.png"
let KImagePropertyName                : String = "propertyPicture.png"
let KImageParam                : String = "message_files[]"
let KADDRESS              : String = "address"

let KImageIDCARDName               : String = "idNumberPicture.png"
let KImageIDCardParam                : String = "idNumberPicture"

let KDeviceType                  : String = "iOS"
let KProductName                 : String  = "productName"
let KProductCategory                 : String  = "productCategory"
let KProductAddress                : String  = "productLocalisation"
let KProductDescription                 : String  = "productDescription"
let KProductPrice                 : String  = "productPrice"
let KProductImage                 : String  = "productImages"
let KProductID                 : String  = "productId"
let KSentOfferPrice                : String  = "price"

let KProductfavourite                 : String  = "favourite"
let KFavouriteBadge                 : String  = "Badge"
let KFavouriteCount                : String  = "favouriteItemCount"
let KExpiryDate                : String  = "userCardExpiry"
let KCardHolderName                : String  = "userCardHolderName"
let KUserCardNumber                : String  = "userCardNumber"
let KCardCVVNum                : String  = "userCardCsv"
let KOfferSENT                : String  = "offerSent"
let KUPDATEPROFILE                : String  = "updateProfile"

let KACCEPTOFFER                : String  = "acceptOffer"
let KREJECTOFFER                : String  = "rejectOffer"
let KNEWOFFER                : String  = "newOffer"

let KStatus                : String  = "status"
let KOfferSendUserId                : String  = "offerSenderUserId"

let KOFFERId                 : String  = "offerId"
let KCONFIRMATIONMESSAGE                 : String  = "Garage Sale is working with Services  provider to confirm your Order ".localized()




