//
//  UBFeedDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import GrowingTextView
import IQKeyboardManagerSwift
import ActionSheetPicker_3_0
import SCLAlertView
import SVProgressHUD
  

protocol UpdateVoteDelegate : class {
    func update(obj : FeedsObject , checkIndex : Int)
    func updateReact(obj : FeedsObject , checkIndex : Int)
    func reportOrHidePost(obj : FeedsObject , checkIndex : Int)
    func updateFav(obj : FeedsObject , checkIndex : Int)
    func deleteObj(obj : FeedsObject , checkIndex : Int)
}

class UBFeedDetailVC: UIViewController , UIGestureRecognizerDelegate {
    @IBOutlet weak var tblViewss: UITableView!
    var userObj : Session?
    @IBOutlet weak var profileImage : UIImageView!
    var userFeeds : FeedsDetail?
    var feedObj : FeedsObject?
    var isUserPooling : Bool?
//    private var commentObj : AllComments? = AllComments()
    var sec : Int?
    var isReplySelect : Bool?
    @IBOutlet weak var txtComment: GrowingTextView!
    var indexSelect : Int?
//    weak var delegate : UpdateVoteDelegate?
    weak var delegate: UpdateVoteDelegate? = .none

    @IBOutlet weak var imgOfUse: UIImageView!
    
    @IBOutlet weak var btnComment: UIButton!
    
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
     var totalComment : Int?
    
    var selectSection : Int?
    
    @IBOutlet weak var btnSexualContent: UIButton!
    @IBOutlet weak var btnHateFull: UIButton!
    @IBOutlet weak var btnSpam: UIButton!
    @IBOutlet weak var viewOfPop: UIView!
    
    
    @IBOutlet weak var viewOfComment: UIView!
    @IBOutlet weak var viewOfReply: UIView!
    @IBOutlet weak var lblReplyPerson : UILabel!
    
    
    @IBOutlet weak var viewOfReport : UIView!
    @IBOutlet weak var btnSexualContent1: UIButton!
    @IBOutlet weak var btnHateFull1: UIButton!
    @IBOutlet weak var btnSpam1 : UIButton!
    
    @IBOutlet weak var imgOfSexualContent : UIImageView!
    @IBOutlet weak var imgOfHateFul : UIImageView!
    @IBOutlet weak var imgOfSpam : UIImageView!
    
    @IBOutlet weak var btnBAck: UIButton!

    
    @IBOutlet weak var imgOfSexualContent1 : UIImageView!
    @IBOutlet weak var imgOfHateFul1 : UIImageView!
    @IBOutlet weak var imgOfSpam1 : UIImageView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    private   var isRepot = ""
    private var isRepotPost = ""
    private var commentId : Int?
    private var replyCommentId  : Int?
    private var isSelectCommentOrReplyComment : Bool?
    @IBOutlet weak var bottomViewBottomSpaceConstant : NSLayoutConstraint!
    @IBOutlet weak var bottomtblViewSpaceConstant : NSLayoutConstraint!

    let commentDateForm = DateFormatter()

    private let refreshControl = UIRefreshControl()
    var  group = DispatchGroup()
    var isDeleted : Bool?
    var isDeleteds : Int?
    var postId : Int?
    private var isCommentReported  : [Int] = []
    private var isReplyCommentReported  : [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isDeleted = false
        viewOfReply.isHidden = true
        isReplySelect = false
        isSelectCommentOrReplyComment = false
        btnBAck.isUserInteractionEnabled = false
        if feedObj!.allow_comment == 1 {
            viewOfComment.isHidden = true
        } else {
            viewOfComment.isHidden = false
        }
        commentDateForm.dateFormat = "yyyy-MM-dd HH:mm:ss"
        commentDateForm.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        self.btnComment.isUserInteractionEnabled = false
        self.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)
        tblViewss.rowHeight = UITableView.automaticDimension
        tblViewss.estimatedRowHeight = 65.0
        tblViewss.sectionHeaderHeight =  UITableView.automaticDimension
        tblViewss.estimatedSectionHeaderHeight = 211.0 ;
        txtComment.delegate = self
        if isUserPooling == false {
            let headerNib = UINib.init(nibName: "FeedHeaderCell", bundle: Bundle.main)
            tblViewss.register(headerNib, forHeaderFooterViewReuseIdentifier: "FeedHeaderCell")
        } else {
            let headerNib = UINib.init(nibName: "FeedHeaderPollCell", bundle: Bundle.main)
            tblViewss.register(headerNib, forHeaderFooterViewReuseIdentifier: "FeedHeaderPollCell")
        }
        tblViewss.registerCells([
            CommentCell.self , ReplyCommentCell.self
            ])
        
        IQKeyboardManager.shared.enable = false
        getFeedDetail()
      
        guard  let image = userObj?.profile_image  else   {
            return profileImage.image = UIImage(named: "User")
        }
        imgOfUse.setImage(with: image, placeholder: UIImage(named: "profile2"))
        let cgFloats: CGFloat = self.imgOfUse.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(self.imgOfUse , radius: CGFloat(someFloats))


    }
    
    @objc func didLoadDetail(_ notification: NSNotification) {
        getFeedDetail()
    }
//
    @objc private func refreshWithData(_ sender: Any) {
        // Fetch Weather Data
        if Connectivity.isConnectedToInternet()  {
              self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
              self.navigationController!.interactivePopGestureRecognizer!.delegate = self
              //self.revealController.recognizesPanningOnFrontView = false
              self.btnBAck.isUserInteractionEnabled = false
              getFeedDetail()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
         }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl.endRefreshing()
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl =  refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = false
        //self.revealController.recognizesPanningOnFrontView = false
        tblViewss.addSubview(refreshControl)
        refreshControl.isEnabled = true
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshControl.isEnabled = false
        refreshControl.removeFromSuperview()
        self.refreshControl.endRefreshing()
        if self.isDeleted == false {
            self.delegate?.updateReact(obj: self.userFeeds?.feedDetail?.post ?? self.feedObj!  , checkIndex: self.indexSelect!)
        }
    }
    deinit {
//        self.userObj = nil
        NotificationCenter.default.removeObserver(self)
         print("<<<<<<<<< UBFeedDetailVC delloc")
        
        
//        self.userObj = nil

    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.bottomConstraint.constant = keyboardHeight
        self.bottomViewBottomSpaceConstant.constant = 0
    }

    @objc func keyboardWillHide(notification:NSNotification)  {
        self.bottomViewBottomSpaceConstant.constant = 0.0
        self.bottomConstraint.constant = 10.0
    }
    
    @IBAction private func btnBack_Pressed(_ sender : UIButton) {
      self.navigationController?.popViewController(animated: true)
    }

    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        txtComment.resignFirstResponder()
    }
    func getFeedDetail() {
        if Connectivity.isConnectedToInternet() {
        let postId = feedObj?.id ?? self.userFeeds?.feedDetail?.post?.id
        let serviceUrl = "\(POSTVIEW)/\(postId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: FeedsDetail.self, success: {[weak self] (response) in
            
            self!.userFeeds = (response as! FeedsDetail)
            if self!.userFeeds?.status == true {
                for (_ , feed) in ((self!.userFeeds?.feedDetail?.post?.allComment!.enumerated())!) {
                    
                    if feed.reportComment != nil {
                        self?.isCommentReported.append(feed.id!)
                    }
                    for (_ ,  reply) in ((feed.replyComment?.enumerated())!) {
                        if reply.reportComment != nil {
                            self?.isReplyCommentReported.append(reply.id!)
                        }
                    }
                }
                
                self!.tblViewss.delegate = self
                self!.tblViewss.dataSource = self
                self!.totalComment = self!.userFeeds?.feedDetail?.post?.total_comments
                self!.tblViewss.reloadData()
                self!.refreshControl.endRefreshing()
                self!.btnBAck.isUserInteractionEnabled = true
                self?.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
                self?.navigationController!.interactivePopGestureRecognizer!.delegate = self
                //self!.revealController.recognizesPanningOnFrontView = false
            } else {
                self!.refreshControl.endRefreshing()
                self?.showAlertViewWithTitle(title: KMessageTitle, message: (self!.userFeeds?.message!)!, dismissCompletion: {
                    self?.navigationController?.popViewController(animated: true)
                })
//                self!.showAlert(title: KMessageTitle, message: (self!.userFeeds?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

        }
     }
    
    @IBAction private func btnAddComment(_ sender : UIButton) {
        if Connectivity.isConnectedToInternet() {

        if isReplySelect == false {
            let postId = self.userFeeds?.feedDetail?.post?.id
            
            if txtComment.text.count > 0 {
                self.btnComment.isUserInteractionEnabled = false
                self.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)
                
                let deviceParam =      ["post_id"            : "\(postId!)",
                                        "comment"            :  txtComment.text!
                    ] as [String : Any]
                self.txtComment.text = ""
                WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: ADDCOMMENT, serviceType: "Login".localized(), modelType: AllCommentObject.self, success: { [weak self ] (responseData) in
                    if  let post = responseData as? AllCommentObject {
                        if post.status == true {
                            self!.userFeeds?.feedDetail?.post?.allComment?.append(post.comment!)
                            self!.tblViewss.insertSections(IndexSet(integer: (self!.userFeeds?.feedDetail?.post?.allComment!.count)!), with: .none)
                            self!.txtComment.text = ""
                            self!.totalComment = post.comment?.total_comments
                            self!.btnComment.isUserInteractionEnabled = false
                            self!.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)
                            let count =  (self!.userFeeds?.feedDetail?.post?.allComment!.count)! - 1
                            let sectionIndexPath = IndexPath(row: NSNotFound, section: count)
                            self!.tblViewss.scrollToRow(at: sectionIndexPath, at: .none, animated: false)
//                            self.tblViewss.reloadData()


//                            let indexx = [NSIndexPath  indexP]
//                            let index = [NSIndexPath indexPathForRow: NSNotFound inSection: (self.userFeeds?.feedDetail?.post?.allComment!.count)]
//                            self.tblViewss.scrollToRow(at: (self.userFeeds?.feedDetail?.post?.allComment!.count)!, at: .top, animated: true)
                            
                            self!.txtComment.resignFirstResponder()
//                            self.tblViewss.scrollToBottomss(animated : true)
//                            self.tblViewss.scrollToBottomRow()
                            
                            
                        } else {
                            self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                            self!.btnComment.isUserInteractionEnabled = true
                        }
                    }
                }, fail: { (error) in
                }, showHUD: true)
            }
        }
        else if isReplySelect == true {
            
            if txtComment.text.count > 0 {
                
                self.btnComment.isUserInteractionEnabled = false
                self.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)

                let commentId = self.userFeeds?.feedDetail?.post?.allComment![self.selectSection!].id
                let postId = self.userFeeds?.feedDetail?.post?.id
                let deviceParam =    [ "post_id"                  : "\(postId!)",
                                       "comment_id"               : "\(commentId!)" ,
                                       "comment"                  : txtComment.text!
                    ] as [String : Any]
                WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: REPLYCOMMENT, serviceType: "Reply Comment".localized(), modelType: UserResponse.self, success: { [weak self ] (responseData) in
                    if  let post = responseData as? UserResponse {
                        if post.status == true {
                            self!.viewOfReply.isHidden = true
                            
                            self!.userFeeds?.feedDetail?.post?.allComment![self!.selectSection!].replyComment?.append(post.replyCommentObj!)
//                            let sectionIndexPath = IndexPath(row: (self.userFeeds?.feedDetail?.post?.allComment![self.selectSection!].replyComment!.count)! , section: self.selectSection!)
//                            self.tblViewss.scrollToRow(at: sectionIndexPath, at: .none, animated: false)
                            self!.btnComment.isUserInteractionEnabled = false
                            self!.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)

                            self!.txtComment.text = ""
                            self!.txtComment.resignFirstResponder()
                            self!.isReplySelect = false
                             self!.tblViewss.reloadData()
//                            let count =  (self.userFeeds?.feedDetail?.post?.allComment!.count)! - 1
                           

//                            self.tblViewss.scrollToBottom()
                            
                            
                            
                        } else {
                            self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                            self!.btnComment.isUserInteractionEnabled = true

                        }
                    }
                }, fail: { (error) in
                }, showHUD: true)
                
            } else {
                self.showAlert(title: KMessageTitle, message: "Enter the comment".localized(), controller: self)
            }
        }
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

        }
    }
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
        viewOfReply.isHidden = true
        self.isReplySelect = false
        
    }
    
    @objc func profileUser(sender : UIButton) {
        self.commentId = sender.tag
//        let feedObj = self.userFeeds?.feedDetail?.post
        let userCommentId = self.userFeeds?.feedDetail?.post?.allComment![sender.tag].user_id
         let userComment = self.userFeeds?.feedDetail?.post?.allComment![sender.tag].userInfo
        if feedObj?.user_as == 1 || userCommentId == self.userObj?.id {
//            print("Hello")
        } else {
          let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
          if #available(iOS 10.0 , *)  {
           vc?.modalPresentationStyle = .overCurrentContext
         } else {
           vc?.modalPresentationStyle = .currentContext
         }
           vc?.userInfo = userComment
           vc?.providesPresentationContextTransitionStyle = true
           present(vc!, animated: true) {
            }

        }
        

    }
    
    @objc func reposrtPost(sender : UIButton) {
        self.commentId = sender.tag
         let commentIdsss = self.userFeeds?.feedDetail?.post?.allComment![sender.tag].user_id
         let comentId = self.userFeeds?.feedDetail?.post?.allComment![sender.tag].id

        if userObj?.id == commentIdsss {
          
            ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                if index == 0 {
                    self!.destroyComment()
                }
                return
            }, cancel: { (actionStrin ) in
                
            }, origin: sender)

        } else {
            
        if  self.userFeeds?.feedDetail?.post?.user_id == self.userObj?.id  {
            
            if isCommentReported.contains((comentId)!) {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Already Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                    if index == 0 {
                        self!.destroyComment()
                    }
//                    else if index == 1 {
//                        self!.viewOfPop.isHidden  = false
//                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: sender)

            } else {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                    if index == 0 {
                        self!.destroyComment()
                    } else if index == 1 {
                        self!.viewOfPop.isHidden  = false
                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: sender)

            }
        } else {
            
            if isCommentReported.contains((comentId)!) {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Already Reported".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
//                    if index == 0 {
//                        self!.viewOfPop.isHidden  = false
//                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: sender)
            } else {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                    if index == 0 {
                        self!.viewOfPop.isHidden  = false
                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: sender)

            }

            }
        }
    }

    @objc func replyCommentOnComment(sender : UIButton) {
        txtComment.becomeFirstResponder()
        selectSection = sender.tag
        isReplySelect = true
        isSelectCommentOrReplyComment = false
        viewOfReply.isHidden = false
        self.lblReplyPerson.text = self.userFeeds?.feedDetail?.post?.allComment![self.selectSection!].comment
 
    }
    

    func postFav(post : FeedsObject) {
        
        if Connectivity.isConnectedToInternet() {

        let param =    [ : ] as [String : Any]
        let postId = self.userFeeds?.feedDetail?.post?.id
        let serviceURl = "\(POSTFAV)/\(postId!)"
        WebServiceManager.put(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: MessageObject.self, success: {[weak self] (responseData) in
             CFRunLoopStop(CFRunLoopGetCurrent())
            let userFav = responseData as? MessageObject
            if userFav!.status == true {
                    
            } else {
                self?.showAlertViewWithTitle(title: KMessageTitle, message: (userFav?.message!)!, dismissCompletion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
//            }
        }, fail: { (error) in
                self.showAlert(title: KMessageTitle, message: error.description , controller: self)
        }, showHUD: true)
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

        }
    }
    func reportPost(post : FeedsObject) {
        let postId = post.id
        viewOfReport.isHidden = false
//        let deviceParam =    [     "post_id"            : "\(postId!)",
//                                    "reason"            : "Spam or misleading"
//            ] as [String : Any]
//        WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: REPORT, serviceType: "Login", modelType: UserResponse.self, success: { (responseData) in
//            if  let posts = responseData as? UserResponse {
//                if posts.status == true {
//                    self.delegate?.reportOrHidePost(obj: post , checkIndex: self.indexSelect!)
//                    self.navigationController?.popViewController(animated: true)
//                } else {
//                    self.showAlert(title: KMessageTitle, message: posts.message!, controller: self)
//                }
//            }
//        }, fail: { (error) in
//        }, showHUD: true)
        
    }
    
    func reactPoll(post : FeedsObject , rection : String  , isReactOnPost : FeedHeaderPollCell) {
      if Connectivity.isConnectedToInternet() {

        let postId = post.id
        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.reactOnPost(postId: "\(postId!)", reaction: rection)
        NetworkLayer.fetchPost(endPointss , url: endPoint, with: LoginResponse.self) {[weak self] (result) in
            switch result {
            case .success(let response):
                CFRunLoopStop(CFRunLoopGetCurrent())
                if response.status == true {
                    isReactOnPost.btnAngry.isUserInteractionEnabled = true
                    isReactOnPost.btnLike.isUserInteractionEnabled = true
                    isReactOnPost.btnLaugh.isUserInteractionEnabled = true
                    isReactOnPost.btnDislike.isUserInteractionEnabled = true
                } else {
                    self?.showAlertViewWithTitle(title: KMessageTitle, message: (response.message!), dismissCompletion: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                    
                }
            case .failure(let error):
                break
            }
            
        }
      } else {
        self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

    }
    }
    
    func rectOnPost(post : FeedsObject , rection : String , isReactionOnPost : FeedHeaderCell) {
        
        if Connectivity.isConnectedToInternet() {

        let postId = post.id
        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.reactOnPost(postId: "\(postId!)", reaction: rection)
        NetworkLayer.fetchPost(endPointss , url: endPoint, with: LoginResponse.self) { [weak self] (result) in
            switch result {
                
            case .success(let response):
                 CFRunLoopStop(CFRunLoopGetCurrent())
                if response.status == true {
                    isReactionOnPost.btnAngry.isUserInteractionEnabled      = true
                    isReactionOnPost.btnUserLike.isUserInteractionEnabled   = true
                    isReactionOnPost.btnDislike.isUserInteractionEnabled    = true
                    isReactionOnPost.btnHappy.isUserInteractionEnabled      = true

                } else {
                    self?.showAlertViewWithTitle(title: KMessageTitle, message: (response.message!), dismissCompletion: {
//                        self!.delegate?.deleteObj(obj: (self?.feedObj!)! , checkIndex: self!.indexSelect!)
                        self?.navigationController?.popViewController(animated: true)
                    })
                    
                }
            case .failure(let error):
                break
            }
            }
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

        }
//        WebServiceManager.put(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post", modelType: UserResponse.self, success: { (responseData) in
//            if  let post = responseData as? UserResponse {
//                if post.status == true {
////                    self.userFeeds?.feedDetail?.post = post.postReaction
//                    self.tblViewss.reloadData()
//                    self.delegate?.updateReact(obj: post.postReaction!, checkIndex: self.indexSelect!)
//                    isReactionOnPost.btnUserLike.isUserInteractionEnabled = true
//                    isReactionOnPost.btnDislike.isUserInteractionEnabled = true
//                    isReactionOnPost.btnHappy.isUserInteractionEnabled = true
//                    isReactionOnPost.btnAngry.isUserInteractionEnabled = true
//
//                } else {
//                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
//                }
//            }
//        }, fail: { (error) in
//        }, showHUD: true)
    }
    
    func voteOnPoll(optionId : Int  , cell : FeedHeaderPollCell) {
        
        if Connectivity.isConnectedToInternet() {

         refreshControl.isEnabled = false
        let postId = feedObj?.id
        let deviceParam =    ["post_id"            : "\(postId!)",
                              "option_id"            :  optionId
                             ] as [String : Any]
        WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: VOTE, serviceType: "Vote".localized(), modelType: UserResponse.self, success: { [weak self] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    //                    self.showAlertViewWithTitle(title: KMessageTitle, message: post.message!, dismissCompletion: {
                    
                    
                    self!.userFeeds?.feedDetail?.post = post.postReaction
                    self!.tblViewss.reloadData()
                    self!.delegate?.update(obj: post.postReaction!, checkIndex: self!.indexSelect!)
                    cell.btnQuestion1.isUserInteractionEnabled = true
                    cell.btnQuestion2.isUserInteractionEnabled = true
                    cell.btnQuestion3.isUserInteractionEnabled = true
                    cell.btnQuestion4.isUserInteractionEnabled = true
                    cell.btnQuestion5.isUserInteractionEnabled = true
                    self!.refreshControl.isEnabled = true

                    
                    
                    
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

        }
    }
    

        
//        WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: VOTE, serviceType: "Vote", modelType: UserResponse.self, success: { (responseData) in
//            if  let post = responseData as? UserResponse {
//                if post.status == true {
////                    self.showAlertViewWithTitle(title: KMessageTitle, message: post.message!, dismissCompletion: {
////                        self.userFeeds?.feedDetail?.post = post.postReaction
//                        self.tblViewss.reloadData()
//                        self.delegate?.update(obj: post.postReaction!, checkIndex: self.indexSelect!)
////                    })
//
//
//                } else {
//                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
//                }
//            }
//        }, fail: { (error) in
//        }, showHUD: true)

    
    
   

    @IBAction func btnSexualContent_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent1.image = UIImage(named: "selected_ic")
        imgOfHateFul1.image = UIImage(named: "checkUn")
        imgOfSpam1.image = UIImage(named: "checkUn")

        isRepot = "Sexual content"
    }
    
    
    @IBAction func btnHateFull_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent1.image = UIImage(named: "checkUn")
        imgOfHateFul1.image = UIImage(named: "selected_ic")
        imgOfSpam1.image = UIImage(named: "checkUn")
        isRepot = "Hateful or abusive content"
        
    }
    
    @IBAction func btnSpam(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent1.image = UIImage(named: "checkUn")
        imgOfHateFul1.image = UIImage(named: "checkUn")
        imgOfSpam1.image = UIImage(named: "selected_ic")
        isRepot = "Spam or misleading"
    }
    
    @IBAction func btnSexualContent_Pressed1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent.image = UIImage(named: "selected_ic")
        imgOfHateFul.image = UIImage(named: "checkUn")
        imgOfSpam.image = UIImage(named: "checkUn")

        
        isRepotPost = "Sexual content"
    }
    
    
    @IBAction func btnHateFull_Pressed1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent.image = UIImage(named: "checkUn")
        imgOfHateFul.image = UIImage(named: "selected_ic")
        imgOfSpam.image = UIImage(named: "checkUn")
        isRepotPost = "Hateful or abusive content"
        
    }
    
    @IBAction func btnSpam1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent.image = UIImage(named: "checkUn")
        imgOfHateFul.image = UIImage(named: "checkUn")
        imgOfSpam.image = UIImage(named: "selected_ic")
        isRepotPost = "Spam or misleading"
    }
    
    @IBAction private func btnDonePost_Pressed(_ sender : UIButton) {
      
        if Connectivity.isConnectedToInternet() {

        if self.isRepotPost.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Please select the option".localized(), controller: self)
       } else {
        self.userFeeds?.feedDetail?.post?.is_reported = true
        let postId = self.feedObj!.id
        let deviceParam =    [      "post_id"            : "\(postId!)",
                                    "reason"            : isRepotPost
            ] as [String : Any]
        WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: REPORT, serviceType: "Login".localized(), modelType: GeneralObject.self, success: { [weak self] (responseData) in
            if  let posts = responseData as? GeneralObject {
                if posts.status == true {
                    self!.viewOfReport.isHidden = true
                    self!.imgOfSexualContent.image = UIImage(named: "checkUn")
                    self!.imgOfHateFul.image = UIImage(named: "checkUn")
                    self!.imgOfSpam.image = UIImage(named: "checkUn")
                    self!.isRepotPost = ""

                } else {
                    self!.showAlert(title: KMessageTitle, message: posts.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
      }
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)

        }
    }
    
    @IBAction private func btnCancelPost_Pressed(_ sender : UIButton) {
        viewOfReport.isHidden = true
        self.imgOfSexualContent.image = UIImage(named: "checkUn")
        self.imgOfHateFul.image = UIImage(named: "checkUn")
        self.imgOfSpam.image = UIImage(named: "checkUn")

    }
    @IBAction func btnDone_Pressed(_ sender: UIButton) {
        var deviceParam: [String : Any] = [:]
        
        if self.isRepot.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Please select the option".localized(), controller: self)
        } else {
        if isSelectCommentOrReplyComment == true {
            deviceParam = [     "comment_id"            : "\(self.replyCommentId!)",
                                "reason"               :  isRepot
                          ]
            isReplyCommentReported.append(self.replyCommentId!)
        } else {
            let commentId = self.userFeeds?.feedDetail?.post?.allComment![self.commentId!].id
                deviceParam = [     "comment_id"            : "\(commentId!)",
                                    "reason"                :  isRepot
                              ]
            
            isCommentReported.append(commentId!)
        }
        WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: REPORTCOMMENT , serviceType: "Login".localized(), modelType: GeneralObject.self, success: {[weak self] (responseData) in
            if  let posts = responseData as? GeneralObject {
                if posts.status == true {
                    self?.tblViewss.reloadData()
                    self!.viewOfPop.isHidden = true
                    self?.imgOfSexualContent1.image = UIImage(named: "checkUn")
                    self?.imgOfSpam1.image = UIImage(named: "checkUn")
                    self!.imgOfHateFul1.image = UIImage(named: "checkUn")
                    self!.isRepot = ""

                } else {
                    self!.showAlert(title: KMessageTitle, message: posts.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
        }
        
    }
    
    
    
    @IBAction func btnCancel_Pressed(_ sender: UIButton) {
        viewOfPop.isHidden = true
        isRepot = ""
        isRepotPost = ""

    }
    
    func confirmDelete(post : FeedsObject , index : Int) {
        let postId = post.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(POSTDESTROY)\(postId!)"
        
            WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: GeneralObject.self, success: {[weak self] (responseData) in
                if  let post = responseData as? GeneralObject {
                    if post.status == true {
                            self!.navigationController?.popViewController(animated: true)
                    } else {
                        self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    }
                }
            }, fail: { (error) in
            }, showHUD: true)
    }
    
    func confirm() {
        let postId = self.userFeeds?.feedDetail?.post?.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(POSTDESTROY)\(postId!)"
//        SVProgressHUD.show(withStatus: "Loading")
        
        self.delegate?.deleteObj(obj: ((self.userFeeds!.feedDetail?.post)!)! , checkIndex: self.indexSelect!)
        self.navigationController?.popViewController(animated: true)
        
        
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: GeneralObject.self, success: {[weak self] (responseData) in
            if  let post = responseData as? GeneralObject {
                if post.status == true {
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
        
    }

    
    func postDestroyOnDetail(post : FeedsObject , index : Int) {
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this ?".localized()) {
            self.isDeleted = true
            self.confirm()
        }
//        let appearance = SCLAlertView.SCLAppearance(
//            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
//            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
//            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//            showCloseButton: false,
//            dynamicAnimatorActive: true,
//            buttonsLayout: .horizontal
//        )
//        let alert = SCLAlertView(appearance: appearance)
//
//        _  = alert.addButton("Yes", action: { [unowned self] in
//
//
////            self.userWallFeeds?.posts?.feedsObject?.remove(at: index.row)
////            self.tblViewss.reloadData()
////            self.confirm(post: post, index: index)
//        })
//        _  = alert.addButton("No", action: { [unowned self] in
//
//        })
//
//        let color = UIColor(red: 55/255.0, green: 69/255.0, blue: 163/255.0, alpha: 1.0)
//
//        let icon = UIImage(named:"wall_checked")
//        _ = alert.showCustom("UniBuzz", subTitle: ("Are you sure to want to delete this ?" as? String)!, color: color, icon: icon!, circleIconImage: icon!)
    }
    
    func destroyComment() {
        
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this comment ?".localized()) {
            let commentId = self.userFeeds?.feedDetail?.post?.allComment![self.commentId!].id
            
            DispatchQueue.global(qos: .utility).async { [weak self] in
                if let index  = self!.userFeeds?.feedDetail?.post?.allComment?.index(where: {$0.id == commentId}) {
                    self!.userFeeds?.feedDetail?.post?.allComment?.remove(at: index)
                }
                DispatchQueue.main.async { [weak self] in
                    self!.tblViewss.reloadData()
                }
            }
            let param =    [ : ] as [String : Any]
            let serviceURl = "\(DESTROYCOMMENT)\(commentId!)"
            WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post", modelType: GeneralObject.self, success: {[weak self] (responseData) in
                if  let post = responseData as? GeneralObject {
                    if post.status == true {
                        
                    } else {
                        self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    }
                }
                }, fail: { (error) in
            }, showHUD: true)        }


        
        
    }
    
    func destroyReplyComent(selectIndex : IndexPath , sec : Int ) {
        
        self.replyCommentId = self.userFeeds?.feedDetail?.post?.allComment![sec - 1].replyComment![selectIndex.row].id
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this comment ?".localized()) {

        let param =    [ : ] as [String : Any]
        
        let serviceURl = "\(DESTROYCOMMENT)\(self.replyCommentId!)"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: GeneralObject.self, success: {[weak self] (responseData) in
            if  let post = responseData as? GeneralObject {
                if post.status == true {
                    DispatchQueue.global(qos: .utility).async { [weak self] in
                        if let index  = self!.userFeeds?.feedDetail?.post?.allComment![sec - 1].replyComment?.index(where: {$0.id == self!.replyCommentId}) {
                            self!.userFeeds?.feedDetail?.post?.allComment![sec  - 1].replyComment?.remove(at: index)
                        }
                        DispatchQueue.main.async {
                            self!.tblViewss.reloadData()
                        }
                    }
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
            
        }
    }

    func setReaction(post : FeedsObject , isClickReaction : String , alreadeReaction : Int?  , cell : FeedHeaderCell , isSelected : Bool ) {
        
        var feedObj : FeedsObject?
        
        if post.user_reaction != nil {
            if isClickReaction == "0" {
                if isSelected == true {
                    let  like = Int(cell.lblLikeCount.text!)
                    print("likeCount\(like!)")
                    let likeCount = like! + 1
                    cell.lblLikeCount.text = "\(likeCount)"
                    cell.btnUserLike.isSelected     = true
                    cell.btnHappy.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = 0
                    self.userFeeds?.feedDetail?.post?.post_like_count = likeCount

//                    self.userFeeds?.feedDetail?.post = feedObj!
                    
                    if alreadeReaction == 1 {
                        let  disL = Int(cell.lblDislikeCount.text!)
                        let disLikeCount = disL! - 1
                        cell.lblDislikeCount.text = "\(disLikeCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 0
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount

                        cell.btnDislike.isSelected    = false
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 2 {
                        let  hpy = Int(cell.lblHappy.text!)
                        let happyCount = hpy! - 1
                        cell.lblHappy.text = "\(likeCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 0
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyCount
                        
                        cell.btnHappy.isSelected    = false
                    } else if alreadeReaction == 5 {
                        let  angr = Int(cell.lblAngry.text!)
                        let angryCount = angr! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 0
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                        cell.btnAngry.isSelected    = false
                    }
                    
                } else {
                    let  like = Int(cell.lblLikeCount.text!)
                    let likeCount = like! - 1
                    print("Dislike\(like!)")
                    
                    cell.lblLikeCount.text = "\(likeCount)"
                    cell.btnUserLike.isSelected       = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                }
            }
            else if isClickReaction == "1" {
                if isSelected == true {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disLikeCount = like! + 1
                    cell.lblDislikeCount.text = "\(disLikeCount)"
//                    self.postReactionId.append((post.id!))
//                    if post.user_reaction != nil {
//                        self.postReaction.append(post.user_reaction!)
//                    }
                    cell.btnUserLike.isSelected       = false
                    cell.btnHappy.isSelected      = false
                    cell.btnDislike.isSelected    = true
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feedDetail?.post?.user_reaction = 1
                    self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
//                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
//                            self.postReactionId.remove(at: index)
//                        }
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 1
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount

                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let happyCount = like! - 1
                        cell.lblHappy.text = "\(happyCount)"
//                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
//                            self.postReactionId.remove(at: index)
//                        }
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 1
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyCount
                        
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 1
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    }
                    
                } else {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disL = like! - 1
                    cell.lblDislikeCount.text = "\(disL)"
                    cell.btnDislike.isSelected    = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_dislike_count = disL
                }
            }
            else if isClickReaction == "2" {
                if isSelected == true {
                    let  hpy = Int(cell.lblHappy.text!)
                    let happyMode = hpy! + 1
                    cell.lblHappy.text = "\(happyMode)"
//                    self.postReactionId.append((post.id!))
//                    if post.user_reaction != nil {
//                        self.postReaction.append(post.user_reaction!)
//                    }
                    cell.btnUserLike.isSelected       = false
                    cell.btnHappy.isSelected      = true
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feedDetail?.post?.user_reaction = 2
                    self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode

                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 2
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode

                        
                        
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLikeCheck = like! - 1
                        cell.lblDislikeCount.text = "\(disLikeCheck)"
                       
                        self.userFeeds?.feedDetail?.post?.user_reaction = 2
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCheck
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode

                        
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 2
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode
                        
                    }
                    
                } else {
                    let  like = Int(cell.lblHappy.text!)
                    let hpY = like! - 1
                    cell.lblHappy.text = "\(hpY)"
                    cell.btnHappy.isSelected      = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_laugh_count = hpY

                    
                    
                    
                    
                    
                }
            }
            else if isClickReaction == "5" {
                if isSelected == true {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! + 1
                    cell.lblAngry.text = "\(angryCount)"
//                    self.postReactionId.append((post.id!))
//                    if post.user_reaction != nil {
//                        self.postReaction.append(post.user_reaction!)
//                    }
                    cell.btnUserLike.isSelected       = false
                    cell.btnHappy.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = true
                    self.userFeeds?.feedDetail?.post?.user_reaction = 5
                    //                    self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount

                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 5
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount

                        
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLike = like! - 1
                        cell.lblDislikeCount.text = "\(disLike)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 5
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLike
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let hpyCount = like! - 1
                        cell.lblHappy.text = "\(hpyCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 5
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = hpyCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    }
                    
                } else {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! - 1
                    cell.lblAngry.text = "\(angryCount)"
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount

                    
                }
            }
        } else {
            
            if isClickReaction == "0" {
                let  like = Int(cell.lblLikeCount.text!)
                let likeCount = like! + 1
                cell.lblLikeCount.text = "\(likeCount)"
                self.userFeeds?.feedDetail?.post?.user_reaction = 0
                self.userFeeds?.feedDetail?.post?.post_like_count = likeCount

                
                cell.btnUserLike.isSelected       = true
                cell.btnHappy.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "1" {
                let  like = Int(cell.lblDislikeCount.text!)
                let disLike = like! + 1
                cell.lblDislikeCount.text = "\(disLike)"
                self.userFeeds?.feedDetail?.post?.user_reaction = 1
                self.userFeeds?.feedDetail?.post?.post_dislike_count = disLike

                cell.btnUserLike.isSelected       = false
                cell.btnHappy.isSelected      = false
                cell.btnDislike.isSelected    = true
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "2" {
                let  like = Int(cell.lblHappy.text!)
                let laugh = like! + 1
                cell.lblHappy.text = "\(laugh)"
                cell.btnUserLike.isSelected       = false
                cell.btnHappy.isSelected      = true
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                self.userFeeds?.feedDetail?.post?.user_reaction = 2
                self.userFeeds?.feedDetail?.post?.post_laugh_count = laugh

                
                
            } else if isClickReaction == "5" {
                let  like = Int(cell.lblAngry.text!)
                let angryCount = like! + 1
                cell.lblAngry.text = "\(angryCount)"
                cell.btnUserLike.isSelected       = false
                cell.btnHappy.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = true
                self.userFeeds?.feedDetail?.post?.user_reaction = 5
                self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount


                
            }
            
        }
        
    }
    
    
    func setReactionOnPoll(post : FeedsObject , isClickReaction : String , alreadeReaction : Int?  , cell : FeedHeaderPollCell , isSelected : Bool) {
        
        var feedObj : FeedsObject?
        
        if post.user_reaction != nil {
            if isClickReaction == "0" {
                if isSelected == true {
                    let  like = Int(cell.lblLikeCount.text!)
                    print("likeCount\(like!)")
                    let likeCount = like! + 1
                    cell.lblLikeCount.text = "\(likeCount)"
                    cell.btnLike.isSelected     = true
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = 0
                    self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                    if alreadeReaction == 1 {
                        let  disL = Int(cell.lblDislikeCount.text!)
                        let disLikeCount = disL! - 1
                        cell.lblDislikeCount.text = "\(disLikeCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 0
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        cell.btnDislike.isSelected    = false
                    } else if alreadeReaction == 2 {
                        let  hpy = Int(cell.lblHappy.text!)
                        let happyCount = hpy! - 1
                        cell.lblHappy.text = "\(likeCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 0
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyCount
                        cell.btnLaugh.isSelected    = false
                    } else if alreadeReaction == 5 {
                        let  angr = Int(cell.lblAngry.text!)
                        let angryCount = angr! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 0
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                        
                        cell.btnAngry.isSelected    = false
                    }
                    
                } else {
                    let  like = Int(cell.lblLikeCount.text!)
                    let likeCount = like! - 1
                    print("Dislike\(like!)")
                    
                    cell.lblLikeCount.text = "\(likeCount)"
                    cell.btnDislike.isSelected       = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                }
            }
            else if isClickReaction == "1" {
                if isSelected == true {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disLikeCount = like! + 1
                    cell.lblDislikeCount.text = "\(disLikeCount)"
                    //                    self.postReactionId.append((post.id!))
                    //                    if post.user_reaction != nil {
                    //                        self.postReaction.append(post.user_reaction!)
                    //                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = true
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feedDetail?.post?.user_reaction = 1
                    self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 1
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let happyCount = like! - 1
                        cell.lblHappy.text = "\(happyCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 1
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyCount
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 1
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    }
                    
                } else {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disL = like! - 1
                    cell.lblDislikeCount.text = "\(disL)"
                    cell.btnDislike.isSelected    = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_dislike_count = disL
                }
            }
            else if isClickReaction == "2" {
                if isSelected == true {
                    let  hpy = Int(cell.lblHappy.text!)
                    let happyMode = hpy! + 1
                    cell.lblHappy.text = "\(happyMode)"
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = true
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feedDetail?.post?.user_reaction = 2
                    self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode
                    
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 2
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode
                        
                        
                        
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLikeCheck = like! - 1
                        cell.lblDislikeCount.text = "\(disLikeCheck)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 2
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLikeCheck
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode
                        
                        
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 2
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = happyMode
                        
                    }
                    
                } else {
                    let  like = Int(cell.lblHappy.text!)
                    let hpY = like! - 1
                    cell.lblHappy.text = "\(hpY)"
                    cell.btnLaugh.isSelected      = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_laugh_count = hpY
                    
                    
                    
                    
                    
                    
                }
            }
            else if isClickReaction == "5" {
                if isSelected == true {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! + 1
                    cell.lblAngry.text = "\(angryCount)"
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = true
                    self.userFeeds?.feedDetail?.post?.user_reaction = 5
                    //                    self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        
                        self.userFeeds?.feedDetail?.post?.user_reaction = 5
                        self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                        
                        
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLike = like! - 1
                        cell.lblDislikeCount.text = "\(disLike)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 5
                        self.userFeeds?.feedDetail?.post?.post_dislike_count = disLike
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                        
                        //                        cell.btnLaugh.isSelected    = false
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let hpyCount = like! - 1
                        cell.lblHappy.text = "\(hpyCount)"
                        self.userFeeds?.feedDetail?.post?.user_reaction = 5
                        self.userFeeds?.feedDetail?.post?.post_laugh_count = hpyCount
                        self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    }
                    
                } else {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! - 1
                    cell.lblAngry.text = "\(angryCount)"
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feedDetail?.post?.user_reaction = -1
                    self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                    
                    
                }
            }
        } else {
            
            if isClickReaction == "0" {
                let  like = Int(cell.lblLikeCount.text!)
                let likeCount = like! + 1
                cell.lblLikeCount.text = "\(likeCount)"
                self.userFeeds?.feedDetail?.post?.user_reaction = 0
                self.userFeeds?.feedDetail?.post?.post_like_count = likeCount
                
                
                cell.btnLike.isSelected       = true
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "1" {
                let  like = Int(cell.lblDislikeCount.text!)
                let disLike = like! + 1
                cell.lblDislikeCount.text = "\(disLike)"
                self.userFeeds?.feedDetail?.post?.user_reaction = 1
                self.userFeeds?.feedDetail?.post?.post_dislike_count = disLike
                
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = true
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "2" {
                let  like = Int(cell.lblHappy.text!)
                let laugh = like! + 1
                cell.lblHappy.text = "\(laugh)"
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = true
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                self.userFeeds?.feedDetail?.post?.user_reaction = 2
                self.userFeeds?.feedDetail?.post?.post_laugh_count = laugh
                
                
                
            } else if isClickReaction == "5" {
                let  like = Int(cell.lblAngry.text!)
                let angryCount = like! + 1
                cell.lblAngry.text = "\(angryCount)"
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = true
                self.userFeeds?.feedDetail?.post?.user_reaction = 5
                self.userFeeds?.feedDetail?.post?.post_angry_count = angryCount
                
                
                
            }
            
        }
        
    }
    


    func editPost(post : FeedsObject) {
        if post.is_poll == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditPollVC") as? UBEditPollVC
            vc?.post = self.userFeeds?.feedDetail?.post
            vc?.selectIndex = indexSelect
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditPostVC") as? UBEditPostVC
            vc?.post = self.userFeeds?.feedDetail?.post
            vc?.selectIndex = indexSelect
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
}

extension UBFeedDetailVC :  EditPostDelegate {
    func editPost(obj : FeedsObject , index : Int) {
        self.userFeeds?.feedDetail?.post = obj
        self.userFeeds?.feedDetail?.post?.comment = obj.comment
        self.tblViewss.reloadData()
//        self.feedObj = obj
//        tblViewss.reloadData()
    }

}

extension UBFeedDetailVC :  EditPollDelegate {
    func editPoll(obj: FeedsObject, index: Int) {
        self.userFeeds?.feedDetail?.post = obj
        self.userFeeds?.feedDetail?.post?.comment = obj.comment
        self.userFeeds?.feedDetail?.post?.postOption = obj.postOption
        self.tblViewss.reloadData()

        
        
        }        //        self.userFeeds?.feedDetail?.post = obj
    
        //        tblViewss.reloadData()
    
    
}

extension UBFeedDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if  self.userFeeds?.feedDetail?.post?.allow_comment == 1 {
            self.viewOfComment.isHidden = true
            return 1
        } else {
            
            self.viewOfComment.isHidden = false
            return ((self.userFeeds?.feedDetail?.post?.allComment!.count)! + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            if isUserPooling == true {
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FeedHeaderPollCell") as! FeedHeaderPollCell
                if self.userFeeds?.feedDetail?.post?.postOption?.count != 0 {
//                    cell.lblNAme.text = self.userFeeds?.feedDetail?.post?.user?.full_name
                    cell.lblUni.text = self.userFeeds?.feedDetail?.post?.post_group_name
//                    cell.lblDate.text = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feedDetail?.post?.created_at)!)
                    cell.lblPost.text = self.userFeeds?.feedDetail?.post?.comment
                    
                    cell.lblDate.text = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feedDetail?.post!.created_at)!)
                    let likeCount = self.userFeeds?.feedDetail?.post?.post_like_count
                    let disLike = self.userFeeds?.feedDetail?.post?.post_dislike_count
                    let launghCount = self.userFeeds?.feedDetail?.post?.post_laugh_count
                    let angry = self.userFeeds?.feedDetail?.post?.post_angry_count
                    let vote = self.userFeeds?.feedDetail?.post?.total_poll_votes
                    let userReaction = self.userFeeds?.feedDetail?.post?.user_reaction
                    
                    if self.userFeeds?.feedDetail?.post?.is_edited == true {
                        let updatedDate = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feedDetail?.post!.update_at)!)
                        cell.lblEdited.isHidden = false
                        cell.lblEdited.text = "edited".localized() + " \(updatedDate)"
                    } else {
                        cell.lblEdited.isHidden = true
                        
                    }

                    
                        if self.userFeeds?.feedDetail?.post!.postOption?.count == 2 {
                            cell.lblThirdPollQuestion.isHidden = true
                            cell.lblFourthQuestion.isHidden = true
                            
                            cell.heightOfThirdLabel.constant = 0.0
                            cell.heightofFirstProgress.constant = 0.0
                            cell.heightOfFourthLabel.constant = 0.0
                            cell.heightofSecondProgress.constant = 0.0
                            cell.heightOfFiftLabel.constant = 0.0
                            cell.heightOfThirdPreogres.constant = 0.0
                            let firstName  = self.userFeeds?.feedDetail?.post!.postOption![0].name
                            let secondName  = self.userFeeds?.feedDetail?.post!.postOption![1].name
                            if self.userFeeds?.feedDetail?.post!.postOption![0].myVote != nil {
                                cell.lblFirstPollQuestion.text = "\(firstName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblFirstPollQuestion.text = firstName
                            }
                            if self.userFeeds?.feedDetail?.post!.postOption![1].myVote != nil {
                                cell.lblSecondPollQuestion.text = "\(secondName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblSecondPollQuestion.text = secondName
                            }
                            cell.progressOfThidPoll.isHidden = true
                            cell.progressOfFourthPoll.isHidden = true
                            cell.progressOfFifthPoll.isHidden = true
                            
                            cell.btnQuestion3.isHidden = true
                            cell.btnQuestion4.isHidden = true
                            
                            if self.userFeeds?.feedDetail?.post?.is_voted == false {
                                cell.btnQuestion1.isHidden = false
                                cell.btnQuestion2.isHidden = false
                                cell.btnQuestion3.isHidden = true
                                cell.btnQuestion4.isHidden = true
                                cell.btnQuestion5.isHidden = true
                                
                                
                            } else {
                                cell.btnQuestion1.isHidden = true
                                cell.btnQuestion2.isHidden = true
                                cell.btnQuestion3.isHidden = true
                                cell.btnQuestion4.isHidden = true
                                cell.btnQuestion5.isHidden = true
                            }
                            let totalVoteCountOfFirstsss = (self.userFeeds?.feedDetail?.post!.postOption![0].post_votes_count)!
                            let totalVoteCountOfFirstssssss : Float?
                            if vote == nil {
                                totalVoteCountOfFirstssssss = 0.0
                            } else {
                                totalVoteCountOfFirstssssss  = Float(totalVoteCountOfFirstsss) / Float(vote!)
                            }
                            
                            cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstssssss!)) { [weak self] in
                                
                            }
//                            cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstssssss!))
                            
                            let totalVoteCountSecondss = (self.userFeeds?.feedDetail?.post!.postOption![1].post_votes_count)!
                            
                            let totalVoteCountSecondsssss : Float?
                            if vote == nil {
                                totalVoteCountSecondsssss = 0
                            } else {
                                totalVoteCountSecondsssss  = Float(totalVoteCountSecondss) / Float(vote!)
                            }
                            
                            cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondsssss!)) { [weak self] in
                                
                            }
//                            cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondsssss!))
                        }
                        if self.userFeeds?.feedDetail?.post!.postOption?.count == 3 {
                            
                            cell.lblThirdPollQuestion.isHidden = false
                            cell.lblFourthQuestion.isHidden = true
                            cell.lblFifthQues.isHidden = true
                            
                            cell.progressOfThidPoll.isHidden = false
                            cell.progressOfFourthPoll.isHidden = true
                            cell.progressOfFifthPoll.isHidden = true
                            
                            
                            if self.userFeeds?.feedDetail?.post?.is_voted == false {
                                cell.btnQuestion3.isHidden = false
                                cell.btnQuestion1.isHidden = false
                                cell.btnQuestion2.isHidden = false
                                cell.btnQuestion4.isHidden = true
                                cell.btnQuestion5.isHidden = true
                            } else {
                                cell.btnQuestion3.isHidden = true
                                cell.btnQuestion1.isHidden = true
                                cell.btnQuestion2.isHidden = true
                                cell.btnQuestion4.isHidden = true
                                cell.btnQuestion5.isHidden = true
                            }
                            cell.heightOfThirdLabel.constant = 14.0
                            cell.heightofFirstProgress.constant = 14.0
                            cell.heightOfFourthLabel.constant = 0.0
                            cell.heightofSecondProgress.constant = 0.0
                            cell.heightOfFiftLabel.constant = 0.0
                            cell.heightOfThirdPreogres.constant = 0.0

                            let firstName  = self.userFeeds?.feedDetail?.post!.postOption![0].name
                            let secondName  = self.userFeeds?.feedDetail?.post!.postOption![1].name
                            let thirdName  = self.userFeeds?.feedDetail?.post!.postOption![2].name
                            if self.userFeeds?.feedDetail?.post!.postOption![0].myVote != nil {
                                cell.lblFirstPollQuestion.text = "\(firstName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblFirstPollQuestion.text = firstName
                            }
                            if self.userFeeds?.feedDetail?.post!.postOption![1].myVote != nil {
                                cell.lblSecondPollQuestion.text = "\(secondName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblSecondPollQuestion.text = secondName
                            }
                            if self.userFeeds?.feedDetail?.post!.postOption![2].myVote != nil {
                                cell.lblThirdPollQuestion.text = "\(thirdName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblThirdPollQuestion.text = thirdName
                            }
                            let totalVoteCountOfFirst = (self.userFeeds?.feedDetail?.post!.postOption![0].post_votes_count)!
                            let totalVoteCountSecond = (self.userFeeds?.feedDetail?.post!.postOption![1].post_votes_count)!
                            let totalVoteCount = (self.userFeeds?.feedDetail?.post!.postOption![2].post_votes_count)!
                            
                            let totalVoteCountOfFirstsss : Float?
                            let totalVoteCountSecondssss : Float?
                            let totalVoteCountsss : Float?

                            if vote == nil {
                                totalVoteCountOfFirstsss = 0
                                totalVoteCountSecondssss = 0
                                totalVoteCountsss = 0
                                
                            } else {
                                totalVoteCountOfFirstsss  = Float(totalVoteCountOfFirst) / Float(vote!)
                                totalVoteCountSecondssss  = Float(totalVoteCountSecond) / Float(vote!)
                                totalVoteCountsss  = Float(totalVoteCount) / Float(vote!)
                                
                            }
                            cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss!)) { [weak self] in
                                
                            }
//                            cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss!))
                            cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondssss!))
                            cell.progressOfThidPoll.animateTo(progress: CGFloat(totalVoteCountsss!))
                        }
                        else  if self.userFeeds?.feedDetail?.post!.postOption?.count == 4 {
                            cell.lblThirdPollQuestion.isHidden = false
                            cell.lblFourthQuestion.isHidden = false
                            cell.progressOfThidPoll.isHidden = false
                            cell.progressOfFourthPoll.isHidden = false
                            cell.progressOfFifthPoll.isHidden = true
                            cell.lblFifthQues.isHidden = true
                            if self.userFeeds?.feedDetail?.post?.is_voted == false {
                                cell.btnQuestion3.isHidden = false
                                cell.btnQuestion4.isHidden = false
                                cell.btnQuestion1.isHidden = false
                                cell.btnQuestion2.isHidden = false
                                cell.btnQuestion5.isHidden = true
                                
                            } else {
                                cell.btnQuestion1.isHidden = true
                                cell.btnQuestion2.isHidden = true
                                
                                cell.btnQuestion3.isHidden = true
                                cell.btnQuestion4.isHidden = true
                                cell.btnQuestion5.isHidden = true
                            }
                            cell.heightOfThirdLabel.constant = 14.0
                            cell.heightofFirstProgress.constant = 10.0
                            cell.heightOfFourthLabel.constant = 14.0
                            cell.heightofSecondProgress.constant = 10.0
                            cell.heightOfFiftLabel.constant = 0.0
                            cell.heightOfThirdPreogres.constant = 0.0
                            let firstName  = self.userFeeds?.feedDetail?.post!.postOption![0].name
                            let secondName  = self.userFeeds?.feedDetail?.post!.postOption![1].name
                            let thirdName  = self.userFeeds?.feedDetail?.post!.postOption![2].name
                            let forthNAme  = self.userFeeds?.feedDetail?.post!.postOption![3].name

                            if self.userFeeds?.feedDetail?.post!.postOption![0].myVote != nil {
                                cell.lblFirstPollQuestion.text = "\(firstName!)" + " (My Vote)".localized()
                            } else {
                                 cell.lblFirstPollQuestion.text = firstName
                            }
                            
                            if self.userFeeds?.feedDetail?.post!.postOption![1].myVote != nil {
                                cell.lblSecondPollQuestion.text = "\(secondName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblSecondPollQuestion.text = secondName
                            }
                            
                            if self.userFeeds?.feedDetail?.post!.postOption![2].myVote != nil {
                                cell.lblThirdPollQuestion.text = "\(thirdName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblThirdPollQuestion.text = thirdName
                            }
                            
                            if self.userFeeds?.feedDetail?.post!.postOption![3].myVote != nil {
                                cell.lblFourthQuestion.text = "\(forthNAme!)" + " (My Vote)".localized()
                            } else {
                                cell.lblFourthQuestion.text = forthNAme
                            }
                            let first = (self.userFeeds?.feedDetail?.post!.postOption![0].post_votes_count)!
                            let second = (self.userFeeds?.feedDetail?.post!.postOption![1].post_votes_count)!
                            let third = (self.userFeeds?.feedDetail?.post!.postOption![2].post_votes_count)!
                            let fourht = (self.userFeeds?.feedDetail?.post!.postOption![3].post_votes_count)!
                            let VoteCountOfFirstsss : Float?
                            let VoteCountSecondssss : Float?
                            let VoteCountThird : Float?
                            let VoteCountFourth : Float?
                            
                            
                            if vote == nil {
                                VoteCountOfFirstsss = 0
                                VoteCountSecondssss = 0
                                VoteCountThird = 0
                                VoteCountFourth = 0
                                
                                
                            } else {
                                VoteCountOfFirstsss  = Float(first) / Float(vote!)
                                VoteCountSecondssss  = Float(second) / Float(vote!)
                                VoteCountThird  = Float(third) / Float(vote!)
                                VoteCountFourth  = Float(fourht) / Float(vote!)
                            }
                            
                            
                            cell.progressOfFirstPoll.animateTo(progress: CGFloat(VoteCountOfFirstsss!))
                            cell.progressOfThidPoll.animateTo(progress: CGFloat(VoteCountThird!))
                            cell.progressOfFourthPoll.animateTo(progress: CGFloat(VoteCountFourth!))
                            cell.progressOfSecondPoll.animateTo(progress: CGFloat(VoteCountSecondssss!))
                            
                        }
                        else  if self.userFeeds?.feedDetail?.post!.postOption?.count == 5 {
                            cell.lblThirdPollQuestion.isHidden = false
                            cell.lblFourthQuestion.isHidden = false
                            cell.progressOfThidPoll.isHidden = false
                            cell.progressOfFourthPoll.isHidden = false
                            cell.progressOfFifthPoll.isHidden = false
                            cell.lblFifthQues.isHidden = false
                            if self.userFeeds?.feedDetail?.post?.is_voted == false {
                                cell.btnQuestion3.isHidden = false
                                cell.btnQuestion4.isHidden = false
                                cell.btnQuestion1.isHidden = false
                                cell.btnQuestion2.isHidden = false
                                cell.btnQuestion5.isHidden = false
                            } else {
                                cell.btnQuestion1.isHidden = true
                                cell.btnQuestion2.isHidden = true
                                
                                cell.btnQuestion3.isHidden = true
                                cell.btnQuestion4.isHidden = true
                                cell.btnQuestion5.isHidden = true
                            }
                            cell.heightOfThirdLabel.constant = 14.0
                            cell.heightofFirstProgress.constant = 10.0
                            cell.heightOfFourthLabel.constant = 14.0
                            cell.heightofSecondProgress.constant = 10.0
                            cell.heightOfFiftLabel.constant = 14.0
                            cell.heightOfThirdPreogres.constant = 10.0
                            let firstName  = self.userFeeds?.feedDetail?.post!.postOption![0].name
                            let secondName  = self.userFeeds?.feedDetail?.post!.postOption![1].name
                            let thirdName  = self.userFeeds?.feedDetail?.post!.postOption![2].name
                            let forthNAme  = self.userFeeds?.feedDetail?.post!.postOption![3].name
                            let fifths  = self.userFeeds?.feedDetail?.post!.postOption![4].name

                            if self.userFeeds?.feedDetail?.post!.postOption![0].myVote != nil {
                                cell.lblFirstPollQuestion.text = "\(firstName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblFirstPollQuestion.text = firstName
                            }
                            
                            if self.userFeeds?.feedDetail?.post!.postOption![1].myVote != nil {
                                cell.lblSecondPollQuestion.text = "\(secondName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblSecondPollQuestion.text = secondName
                            }
                            
                            if self.userFeeds?.feedDetail?.post!.postOption![2].myVote != nil {
                                cell.lblThirdPollQuestion.text = "\(thirdName!)" + " (My Vote)".localized()
                            } else {
                                cell.lblThirdPollQuestion.text = thirdName
                            }
                            if self.userFeeds?.feedDetail?.post!.postOption![3].myVote != nil {
                                cell.lblFourthQuestion.text = "\(forthNAme!)" + " (My Vote)".localized()
                            } else {
                                cell.lblFourthQuestion.text = forthNAme
                            }

                            if self.userFeeds?.feedDetail?.post!.postOption![4].myVote != nil {
                                cell.lblFifthQues.text = "\(fifths!)" + " (My Vote)".localized()
                            } else {
                                cell.lblFifthQues.text = fifths
                            }
                            let first = (self.userFeeds?.feedDetail?.post!.postOption![0].post_votes_count)!
                            let second = (self.userFeeds?.feedDetail?.post!.postOption![1].post_votes_count)!
                            let third = (self.userFeeds?.feedDetail?.post!.postOption![2].post_votes_count)!
                            let fourht = (self.userFeeds?.feedDetail?.post!.postOption![3].post_votes_count)!
                            let fifth = (self.userFeeds?.feedDetail?.post!.postOption![4].post_votes_count)!
                            
                            let VoteCountOfFirstsss : Float?
                            let VoteCountSecondssss : Float?
                            let VoteCountThird : Float?
                            let VoteCountFourth : Float?
                            let VoteCountFifth : Float?
                            if vote == nil {
                                VoteCountOfFirstsss = 0
                                VoteCountSecondssss = 0
                                VoteCountThird = 0
                                VoteCountFourth = 0
                                VoteCountFifth = 0
                            } else {
                                VoteCountOfFirstsss  = Float(first) / Float(vote!)
                                VoteCountSecondssss  = Float(second) / Float(vote!)
                                VoteCountThird  = Float(third) / Float(vote!)
                                VoteCountFourth  = Float(fourht) / Float(vote!)
                                VoteCountFifth  = Float(fifth) / Float(vote!)
                            }
                            
                            cell.progressOfFirstPoll.animateTo(progress: CGFloat(VoteCountOfFirstsss!))
                            cell.progressOfThidPoll.animateTo(progress: CGFloat(VoteCountThird!))
                            cell.progressOfFourthPoll.animateTo(progress: CGFloat(VoteCountFourth!))
                            cell.progressOfSecondPoll.animateTo(progress: CGFloat(VoteCountSecondssss!))
                            cell.progressOfFifthPoll.animateTo(progress: CGFloat(VoteCountFifth!))
                        }
                    cell.lblDescriptiionOfUni.text = self.userFeeds?.feedDetail?.post?.groupInfo?.name
                    
                    
                    if self.userFeeds?.feedDetail?.post!.allow_comment == 0 {
                        if let image = UIImage(named: "comments") {
                            cell.btnComment.setImage(image , for: .normal)
                        }
                        
                        if totalComment != nil {
                            cell.btnComment.setTitle("\(totalComment!)", for: .normal)
                        } else {
                            cell.btnComment.setTitle("0".localized(), for: .normal)
                        }
                        
                        
                        if self.userFeeds?.feedDetail?.post?.commentAvatar?.count == 1  {
                            cell.imgOfAvatarSecond.isHidden = true
                            cell.imgOfAvatarThird.isHidden = true
                            cell.imgOfAvatarFourth.isHidden = true
                            cell.imgOfAvatarFirst.isHidden = false
                            
                            guard  let image = self.userFeeds?.feedDetail?.post?.commentAvatar![0].imge  else   {
                                return cell
                            }
                            
                            cell.imgOfAvatarFirst.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: image , imageView: (cell.imgOfAvatarFirst!), placeHolder: "profile2")
                            let cgFloat: CGFloat = cell.imgOfAvatarFirst.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarFirst, radius: CGFloat(someFloat))
                            
                        } else if self.userFeeds?.feedDetail?.post?.commentAvatar?.count == 2  {
                            cell.imgOfAvatarFirst.isHidden = false
                            cell.imgOfAvatarSecond.isHidden = false
                            cell.imgOfAvatarThird.isHidden = true
                            cell.imgOfAvatarFourth.isHidden = true
                            
                            let imge = self.userFeeds?.feedDetail?.post!.commentAvatar![0].imge
                            cell.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: imge! , imageView: (cell.imgOfAvatarFirst!), placeHolder: "profile2")
                            let cgFloats: CGFloat = cell.imgOfAvatarFirst.frame.size.width/2.0
                            let someFloats = Float(cgFloats)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarFirst, radius: CGFloat(someFloats))
                          
                            guard  let image = self.userFeeds?.feedDetail?.post!.commentAvatar![1].imge  else   {
                                return cell
                            }
                            
                            cell.imgOfAvatarSecond.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: image , imageView: (cell.imgOfAvatarSecond!), placeHolder: "profile2")
                            let cgFloat: CGFloat = cell.imgOfAvatarSecond.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarSecond, radius: CGFloat(someFloat))
                            
                        } else if self.userFeeds?.feedDetail?.post!.commentAvatar?.count == 3  {
                            cell.imgOfAvatarFirst.isHidden = false
                            cell.imgOfAvatarSecond.isHidden = false
                            cell.imgOfAvatarThird.isHidden = false
                            cell.imgOfAvatarFourth.isHidden = true
                            
                            let imge = self.userFeeds?.feedDetail?.post!.commentAvatar![0].imge
                            cell.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: imge! , imageView: (cell.imgOfAvatarFirst!), placeHolder: "profile2")
                            let cgFloats: CGFloat = cell.imgOfAvatarFirst.frame.size.width/2.0
                            let someFloats = Float(cgFloats)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarFirst, radius: CGFloat(someFloats))
                            
                            
                            let imgess = self.userFeeds?.feedDetail?.post!.commentAvatar![1].imge
                          
                            cell.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: imgess! , imageView: (cell.imgOfAvatarSecond!), placeHolder: "profile2")
                            let cgFloatss: CGFloat = cell.imgOfAvatarSecond.frame.size.width/2.0
                            let someFloatss = Float(cgFloatss)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                            guard  let image = self.userFeeds?.feedDetail?.post!.commentAvatar![2].imge  else   {
                                return cell
                            }
                            cell.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: image , imageView: (cell.imgOfAvatarThird!), placeHolder: "profile2")
                            let cgFloat: CGFloat = cell.imgOfAvatarThird.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarThird, radius: CGFloat(someFloat))
                            
                        }
                        else if self.userFeeds?.feedDetail?.post!.commentAvatar?.count == 4  {
                            cell.imgOfAvatarFirst.isHidden = false
                            cell.imgOfAvatarSecond.isHidden = false
                            cell.imgOfAvatarThird.isHidden = false
                            cell.imgOfAvatarFourth.isHidden = false
                            
                            let imge = self.userFeeds?.feedDetail?.post!.commentAvatar![0].imge
                            cell.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: imge! , imageView: (cell.imgOfAvatarFirst!), placeHolder: "profile2")
                            let cgFloats: CGFloat = cell.imgOfAvatarFirst.frame.size.width/2.0
                            let someFloats = Float(cgFloats)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarFirst, radius: CGFloat(someFloats))
                            
                            
                            let imgess = self.userFeeds?.feedDetail?.post!.commentAvatar![1].imge
                            cell.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: imgess! , imageView: (cell.imgOfAvatarSecond!), placeHolder: "profile2")
                            let cgFloatss: CGFloat = cell.imgOfAvatarSecond.frame.size.width/2.0
                            let someFloatss = Float(cgFloatss)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                            
                            guard  let image = self.userFeeds?.feedDetail?.post!.commentAvatar![2].imge  else   {
                                return cell
                            }
                            
                            cell.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: image , imageView: (cell.imgOfAvatarThird!), placeHolder: "profile2")
                            let cgFloat: CGFloat = cell.imgOfAvatarThird.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarThird, radius: CGFloat(someFloat))
                            
                            
                            guard  let imagessss = self.userFeeds?.feedDetail?.post!.commentAvatar![3].imge  else   {
                                return cell
                            }
                            cell.imgOfAvatarFourth.setImage(with: imagessss , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring: imagessss , imageView: (cell.imgOfAvatarFourth!), placeHolder: "profile2")
                            let cg : CGFloat = cell.imgOfAvatarFourth.frame.size.width/2.0
                            let someFlo = Float(cg)
                            WAShareHelper.setViewCornerRadius(cell.imgOfAvatarFourth, radius: CGFloat(someFlo))
                        } else {
                            cell.imgOfAvatarSecond.isHidden = true
                            cell.imgOfAvatarThird.isHidden = true
                            cell.imgOfAvatarFourth.isHidden = true
                            cell.imgOfAvatarFirst.isHidden = true
                        }
                    } else {
                        if let image = UIImage(named: "disable_comments") {
                            cell.btnComment.setImage(image , for: .normal)
                            
                        }
                        
                        cell.imgOfAvatarSecond.isHidden = true
                        cell.imgOfAvatarThird.isHidden = true
                        cell.imgOfAvatarFourth.isHidden = true
                        cell.imgOfAvatarFirst.isHidden = true
                        
                        cell.btnComment.setTitle("", for: .normal)

                    }
                    if userReaction == 0 {
                        cell.btnLike.isSelected = true
                        cell.btnDislike.isSelected = false
                        cell.btnLaugh.isSelected = false
                        cell.btnAngry.isSelected = false
                        
                    } else if userReaction == 1 {
                        cell.btnLike.isSelected = false
                        cell.btnDislike.isSelected = true
                        cell.btnLaugh.isSelected = false
                        cell.btnAngry.isSelected = false
                        
                        
                    } else if userReaction == 2 {
                        cell.btnLike.isSelected = false
                        cell.btnDislike.isSelected = false
                        cell.btnLaugh.isSelected = true
                        cell.btnAngry.isSelected = false
                    } else if userReaction == 5  {
                        cell.btnLike.isSelected = false
                        cell.btnDislike.isSelected = false
                        cell.btnLaugh.isSelected = false
                        cell.btnAngry.isSelected = true
                    } else {
                        cell.btnLike.isSelected = false
                        cell.btnDislike.isSelected = false
                        cell.btnLaugh.isSelected = false
                        cell.btnAngry.isSelected = false

                    }

                    if self.userFeeds?.feedDetail?.post?.is_favorite ==  true {
                        cell.btnFav.isSelected = true
                    } else {
                        cell.btnFav.isSelected = false
                    }
                    
                    cell.delegate = self
                    cell.sec = section
                    cell.lblLikeCount.text = "\(likeCount!)"
                    cell.lblDislikeCount.text = "\(disLike!)"
                    cell.lblHappy.text = "\(launghCount!)"
                    
                    if angry != nil {
                        cell.lblAngry.text = "\(angry!)"
                    } else {
                        cell.lblAngry.text = "0"
                    }
                    if vote != nil {
                        cell.lblTotalVoteCast.text = "\(vote!)" + " Vote".localized()
                        
                        
                    } else {
                        cell.lblTotalVoteCast.text = "0".localized() + " Vote".localized()
                    }
                    if userObj?.id == self.userFeeds?.feedDetail?.post?.user_id {
                        cell.btnQuestion1.isHidden = true
                        cell.btnQuestion2.isHidden = true
                        cell.btnQuestion3.isHidden = true
                        cell.btnQuestion4.isHidden = true
                        cell.btnQuestion5.isHidden = true
                    }
                    
                    if userObj?.id == self.userFeeds?.feedDetail?.post!.user_id {
                            cell.lblNAme.text = "Me".localized()
                        if self.userFeeds?.feedDetail?.post!.user_as  == 1 {
                            cell.imgOfUser.image = UIImage(named: "anonymous_icon")
                            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                            
                        } else {
                            guard  let image = self.userFeeds?.feedDetail?.post!.user?.profile_image  else   {
                                return cell
                            }
                            
                            cell.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
                            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                            
                        }

                        
//                        cell.lblNAme.text = "Me"
//                        //                cell.lblNAme.text  = "Annonymous"
//                        cell.imgOfUser.image = UIImage(named: "anonymous_icon")
//                        let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
//                        let someFloat = Float(cgFloat)
//                        WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                        
                    } else {
                        if self.userFeeds?.feedDetail?.post!.user_as  == 1 {
                            cell.lblNAme.text  = "Anonymous".localized()
                            cell.imgOfUser.image = UIImage(named: "anonymous_icon")
                            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                        } else {
                            cell.lblNAme.text = self.userFeeds?.feedDetail?.post!.user?.full_name
                            guard  let image = self.userFeeds?.feedDetail?.post!.user?.profile_image  else   {
                                return cell
                            }
                            cell.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
                            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                            let someFloat = Float(cgFloat)
                            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
                            
                        }
                    }
                    return cell
                }
                return cell
                
            }
            else {
                let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "FeedHeaderCell") as! FeedHeaderCell
//                headerView.lblNAme.text = self.userFeeds?.feedDetail?.post?.user?.full_name
                headerView.lblUni.text = self.userFeeds?.feedDetail?.post?.post_group_name
                headerView.lblPost.text = self.userFeeds?.feedDetail?.post?.comment
//                userFeeds?.feedDetail?.post?.allComment
                headerView.lblDateOfPost.text =  WAShareHelper.getFormattedDate(string: (self.userFeeds?.feedDetail?.post?.created_at)!)
                let totalComment = self.userFeeds?.feedDetail?.post?.total_comments
                let likeCount = self.userFeeds?.feedDetail?.post?.post_like_count
                let disLike = self.userFeeds?.feedDetail?.post?.post_dislike_count
                let launghCount = self.userFeeds?.feedDetail?.post?.post_laugh_count
                let angry = self.userFeeds?.feedDetail?.post?.post_angry_count
                let userReaction = self.userFeeds?.feedDetail?.post?.user_reaction
                
                
                headerView.lblLikeCount.text = "\(likeCount!)"
                headerView.lblDislikeCount.text = "\(disLike!)"
                headerView.lblHappy.text = "\(launghCount!)"
                headerView.lblDescriptiionOfUni.text = self.userFeeds?.feedDetail?.post?.groupInfo?.name
                headerView.delegate = self
                headerView.index = section
                
                
                if self.userFeeds?.feedDetail?.post?.is_edited == true {
                    let updatedDate = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feedDetail?.post!.update_at)!)
                    headerView.lblEdited.isHidden = false
                    headerView.lblEdited.text = "edited" + " \(updatedDate)".localized()
                } else {
                    headerView.lblEdited.isHidden = true
                }

                if self.userFeeds?.feedDetail?.post!.allow_comment == 0 {
                    if let image = UIImage(named: "comments") {
                        headerView.btnComment.setImage(image , for: .normal)
                    }
                    
                    if totalComment != nil {
                        headerView.btnComment.setTitle("\(totalComment!)", for: .normal)
                    } else {
                        headerView.btnComment.setTitle("0".localized(), for: .normal)
                    }
                    if self.userFeeds?.feedDetail?.post?.commentAvatar?.count == 1  {
                        headerView.imgOfAvatarSecond.isHidden = true
                        headerView.imgOfAvatarThird.isHidden = true
                        headerView.imgOfAvatarFourth.isHidden = true
                        headerView.imgOfAvatarFirst.isHidden = false
                        guard  let image = self.userFeeds?.feedDetail?.post?.commentAvatar![0].imge  else   {
                            return headerView
                        }
                        headerView.imgOfAvatarFirst.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: image , imageView: (headerView.imgOfAvatarFirst!), placeHolder: "profile2")
                        let cgFloat: CGFloat = headerView.imgOfAvatarFirst.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarFirst, radius: CGFloat(someFloat))
                        
                    } else if self.userFeeds?.feedDetail?.post?.commentAvatar?.count == 2  {
                        headerView.imgOfAvatarFirst.isHidden = false
                        headerView.imgOfAvatarSecond.isHidden = false
                        headerView.imgOfAvatarThird.isHidden = true
                        headerView.imgOfAvatarFourth.isHidden = true
                        
                        let imge = self.userFeeds?.feedDetail?.post!.commentAvatar![0].imge
                        headerView.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: imge! , imageView: (headerView.imgOfAvatarFirst!), placeHolder: "profile2")
                        let cgFloats: CGFloat = headerView.imgOfAvatarFirst.frame.size.width/2.0
                        let someFloats = Float(cgFloats)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarFirst, radius: CGFloat(someFloats))
                        
                        
                        
                        guard  let image = self.userFeeds?.feedDetail?.post!.commentAvatar![1].imge  else   {
                            return headerView
                        }
                        headerView.imgOfAvatarSecond.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: image , imageView: (headerView.imgOfAvatarSecond!), placeHolder: "profile2")
                        let cgFloat: CGFloat = headerView.imgOfAvatarSecond.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarSecond, radius: CGFloat(someFloat))
                        
                    } else if self.userFeeds?.feedDetail?.post!.commentAvatar?.count == 3  {
                        headerView.imgOfAvatarFirst.isHidden = false
                        headerView.imgOfAvatarSecond.isHidden = false
                        headerView.imgOfAvatarThird.isHidden = false
                        headerView.imgOfAvatarFourth.isHidden = true
                        let imge = self.userFeeds?.feedDetail?.post!.commentAvatar![0].imge
                        headerView.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: imge! , imageView: (headerView.imgOfAvatarFirst!), placeHolder: "profile2")
                        let cgFloats: CGFloat = headerView.imgOfAvatarFirst.frame.size.width/2.0
                        let someFloats = Float(cgFloats)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarFirst, radius: CGFloat(someFloats))
                        
                        
                        let imgess = self.userFeeds?.feedDetail?.post!.commentAvatar![1].imge
                        headerView.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: imgess! , imageView: (headerView.imgOfAvatarSecond!), placeHolder: "profile2")
                        let cgFloatss: CGFloat = headerView.imgOfAvatarSecond.frame.size.width/2.0
                        let someFloatss = Float(cgFloatss)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                        guard  let image = self.userFeeds?.feedDetail?.post!.commentAvatar![2].imge  else   {
                            return headerView
                        }
                        headerView.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: image , imageView: (headerView.imgOfAvatarThird!), placeHolder: "profile2")
                        let cgFloat: CGFloat = headerView.imgOfAvatarThird.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarThird, radius: CGFloat(someFloat))
                        
                    }
                    else if self.userFeeds?.feedDetail?.post!.commentAvatar?.count == 4  {
                        headerView.imgOfAvatarFirst.isHidden = false
                        headerView.imgOfAvatarSecond.isHidden = false
                        headerView.imgOfAvatarThird.isHidden = false
                        headerView.imgOfAvatarFourth.isHidden = false
                        
                        let imge = self.userFeeds?.feedDetail?.post!.commentAvatar![0].imge
                        headerView.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: imge! , imageView: (headerView.imgOfAvatarFirst!), placeHolder: "profile2")
                        let cgFloats: CGFloat = headerView.imgOfAvatarFirst.frame.size.width/2.0
                        let someFloats = Float(cgFloats)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarFirst, radius: CGFloat(someFloats))
                        
                        
                        let imgess = self.userFeeds?.feedDetail?.post!.commentAvatar![1].imge
                        headerView.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: imgess! , imageView: (headerView.imgOfAvatarSecond!), placeHolder: "profile2")
                        let cgFloatss: CGFloat = headerView.imgOfAvatarSecond.frame.size.width/2.0
                        let someFloatss = Float(cgFloatss)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                        
                        guard  let image = self.userFeeds?.feedDetail?.post!.commentAvatar![2].imge  else   {
                            return headerView
                        }
                        headerView.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring: image , imageView: (headerView.imgOfAvatarThird!), placeHolder: "profile2")
                        let cgFloat: CGFloat = headerView.imgOfAvatarThird.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarThird, radius: CGFloat(someFloat))
                        guard  let imagessss = self.userFeeds?.feedDetail?.post!.commentAvatar![3].imge  else   {
                            return headerView
                        }
                        headerView.imgOfAvatarFourth.setImage(with: imagessss , placeholder: UIImage(named: "profile2"))
                        let cg : CGFloat = headerView.imgOfAvatarFourth.frame.size.width/2.0
                        let someFlo = Float(cg)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfAvatarFourth, radius: CGFloat(someFlo))
                    } else {
                        headerView.imgOfAvatarSecond.isHidden = true
                        headerView.imgOfAvatarThird.isHidden = true
                        headerView.imgOfAvatarFourth.isHidden = true
                        headerView.imgOfAvatarFirst.isHidden = true
                    }
                } else {
                    if let image = UIImage(named: "disable_comments") {
                        headerView.btnComment.setImage(image , for: .normal)
                        
                    }
                    
                    headerView.imgOfAvatarSecond.isHidden = true
                    headerView.imgOfAvatarThird.isHidden = true
                    headerView.imgOfAvatarFourth.isHidden = true
                    headerView.imgOfAvatarFirst.isHidden = true

                    headerView.btnComment.setTitle("", for: .normal)
                    
                }
                

//                let groupMember = self.userFeeds?.feedDetail?.memberList?.count
                if userReaction == 0 {
                    headerView.btnUserLike.isSelected = true
                    headerView.btnDislike.isSelected = false
                    headerView.btnHappy.isSelected = false
                    headerView.btnAngry.isSelected = false
                    
                } else if userReaction == 1 {
                    headerView.btnUserLike.isSelected = false
                    headerView.btnDislike.isSelected = true
                    headerView.btnHappy.isSelected = false
                    headerView.btnAngry.isSelected = false
                } else if userReaction == 2 {
                    headerView.btnUserLike.isSelected = false
                    headerView.btnDislike.isSelected = false
                    headerView.btnHappy.isSelected = true
                    headerView.btnAngry.isSelected = false
                } else if userReaction == 5 {
                    headerView.btnUserLike.isSelected = false
                    headerView.btnDislike.isSelected = false
                    headerView.btnHappy.isSelected = false
                    headerView.btnAngry.isSelected = true
                }
                else  {
                    headerView.btnUserLike.isSelected = false
                    headerView.btnDislike.isSelected = false
                    headerView.btnHappy.isSelected = false
                    headerView.btnAngry.isSelected = false
                }
                if self.userFeeds?.feedDetail?.post?.is_favorite ==  true {
                    headerView.btnIsFavSelect.isSelected = true
                } else {
                    headerView.btnIsFavSelect.isSelected = false
                }

//                if groupMember != nil {
//                    headerView.lblMember.text = "\(groupMember!) Members"
//                } else {
//                    headerView.lblMember.text = "0 Members"
//                }
                if angry != nil {
                    headerView.lblAngry.text = "\(angry!)"
                } else {
                    headerView.lblAngry.text = "0".localized()
                }
                if userObj?.id == self.userFeeds?.feedDetail?.post!.user_id {
                    headerView.lblNAme.text = "Me".localized()
                    
                    if self.userFeeds?.feedDetail?.post!.user_as  == 1 {
                        headerView.imgOfUser.image = UIImage(named: "anonymous_icon")
                        let cgFloat: CGFloat = headerView.imgOfUser.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfUser, radius: CGFloat(someFloat))
                        
                    } else {
                        guard  let image = userObj?.profile_image  else   {
                            return headerView
                        }
                        headerView.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring:image , imageView: (headerView.imgOfUser!), placeHolder: "profile2")
                        let cgFloat: CGFloat = headerView.imgOfUser.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfUser, radius: CGFloat(someFloat))

                    }
                    
                } else {
                    if self.userFeeds?.feedDetail?.post!.user_as  == 1 {
                        headerView.lblNAme.text  = "Anonymous".localized()
                        headerView.imgOfUser.image = UIImage(named: "anonymous_icon")
                        let cgFloat: CGFloat = headerView.imgOfUser.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfUser, radius: CGFloat(someFloat))
                    } else {
                        headerView.lblNAme.text = self.userFeeds?.feedDetail?.post!.user?.full_name
                        guard  let image = self.userFeeds?.feedDetail?.post!.user?.profile_image  else   {
                            return headerView
                        }
                        headerView.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                        WAShareHelper.loadImage(urlstring:image , imageView: (headerView.imgOfUser!), placeHolder: "profile2")
                        let cgFloat: CGFloat = headerView.imgOfUser.frame.size.width/2.0
                        let someFloat = Float(cgFloat)
                        WAShareHelper.setViewCornerRadius(headerView.imgOfUser, radius: CGFloat(someFloat))
                        
                    }
                }
                return headerView
            }
        }
       else {
            let  headerCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
//            headerCell.lblName.text = self.userFeeds?.feedDetail?.post?.allComment![section - 1].userInfo?.full_name
            headerCell.lblPostComment.text = self.userFeeds?.feedDetail?.post?.allComment![section - 1].comment
            let date = commentDateForm.date(from:(self.userFeeds?.feedDetail?.post?.allComment![section - 1].created_at)!)
          
            if let timeAgo = WAShareHelper.timeAgoSinceDate(date!) {
                headerCell.lblDate.text = "\(timeAgo)" + " ago".localized()
            } else {
                print("recently")
            }
            if userObj?.id! == self.userFeeds?.feedDetail?.post!.allComment![section - 1].user_id {
              
//                headerCell.btnShare.isHidden = true
                headerCell.lblName.text = "Me".localized()

                if self.userFeeds?.feedDetail?.post!.user_as  == 1 && self.userFeeds?.feedDetail?.post?.user_id == self.userFeeds?.feedDetail?.post!.allComment![section - 1].user_id  {
                    headerCell.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = headerCell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(headerCell.imgOfUser, radius: CGFloat(someFloat))
                    
                } else {
                    
                    
                    guard  let image = userObj?.profile_image  else   {
                        return headerCell
                    }
                    headerCell.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))

//                    WAShareHelper.loadImage(urlstring:image , imageView: (headerCell.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = headerCell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(headerCell.imgOfUser, radius: CGFloat(someFloat))

                }
            } else {
                
                if self.userFeeds?.feedDetail?.post!.user_as  == 1 && self.userFeeds?.feedDetail?.post?.user_id == self.userFeeds?.feedDetail?.post!.allComment![section - 1].user_id  {
                    print("Item")
                    headerCell.lblName.text = "Anonymous".localized()
                    headerCell.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = headerCell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(headerCell.imgOfUser, radius: CGFloat(someFloat))

                } else {
                    headerCell.btnShare.isHidden = false
                    
                    headerCell.lblName.text = self.userFeeds?.feedDetail?.post!.allComment![section - 1].userInfo?.full_name
                    guard  let image = self.userFeeds?.feedDetail?.post!.allComment![section - 1].userInfo?.profile_image  else   {
                        return headerCell
                    }
                    headerCell.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                WAShareHelper.loadImage(urlstring:image , imageView: (headerCell.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = headerCell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(headerCell.imgOfUser, radius: CGFloat(someFloat))

                }
                
            }
//            commentObj = self.userFeeds?.feedDetail?.post?.allComment![section - 1]
            sec = section - 1
            
            headerCell.btnShare.tag = sec!

            headerCell.btnShare.addTarget(self, action: #selector(reposrtPost(sender:)), for: .touchUpInside)

            headerCell.btnReply.tag = sec!
            headerCell.btnReply.addTarget(self, action: #selector(replyCommentOnComment(sender:)), for: .touchUpInside)
            
            headerCell.btnProfile.tag = sec!

            headerCell.btnProfile.addTarget(self, action: #selector(profileUser(sender:)), for: .touchUpInside)

//            guard  let image = self.userFeeds?.feedDetail?.post?.allComment![section - 1].userInfo?.profile_image  else   {
//                return headerCell.contentView
//            }
//            WAShareHelper.loadImage(urlstring:image , imageView: (headerCell.imgOfUser!), placeHolder: "profile2")
//            let cgFloat: CGFloat = headerCell.imgOfUser.frame.size.width/2.0
//            let someFloat = Float(cgFloat)
//            WAShareHelper.setViewCornerRadius(headerCell.imgOfUser, radius: CGFloat(someFloat))
            
            return headerCell.contentView
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isUserPooling == true {
            if section == 0 {
                if self.userFeeds?.feedDetail?.post?.postOption?.count == 5 {
                    let comment = self.userFeeds?.feedDetail?.post?.comment
                    let size =    UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)
                     return 360 + size
                } else if  self.userFeeds?.feedDetail?.post?.postOption?.count == 4 {
                    let comment = self.userFeeds?.feedDetail?.post?.comment
                    let size    =   UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)

                    return 320 + size
                } else if  self.userFeeds?.feedDetail?.post?.postOption?.count == 3 {
                    let comment = self.userFeeds?.feedDetail?.post?.comment
                    let size    =   UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)
                    return 300 + size
                } else {
                    let comment = self.userFeeds?.feedDetail?.post?.comment
                    let size    =   UtilityHelper.requiredHeightForLabelWith(290 , text: comment!)
                    if size < 80.0  {
                        return 240 + size
                    } else {
                        return 240 + size - 50
                    }

//                    return 240 + size
                    
                    

                }
            } else {
                return UITableView.automaticDimension
            }

        } else {
            if section == 0 {
                return UITableView.automaticDimension
            } else {
                return UITableView.automaticDimension
            }

        }
    }
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return self.userFeeds?.feedDetail?.post?.allComment![section - 1].replyComment?.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 0 {
            
            let cell = tableView.dequeueReusableCell(with: ReplyCommentCell.self, for: indexPath)
            cell.lblName.text = self.userFeeds?.feedDetail?.post?.allComment![indexPath.section - 1].replyComment![indexPath.row].userInfo?.full_name
            cell.lblUniName.text = self.userFeeds?.feedDetail?.post?.post_group_name
            let date = commentDateForm.date(from:(self.userFeeds?.feedDetail?.post?.allComment![indexPath.section - 1].replyComment![indexPath.row].created_at)!)
            
            if let timeAgo = WAShareHelper.timeAgoSinceDate(date!) {
                cell.lblDate.text = "\(timeAgo)" + " ago".localized()
            } else {
                print("recently")
            }
            cell.lbltext.text = self.userFeeds?.feedDetail?.post?.allComment![indexPath.section - 1].replyComment![indexPath.row].comment
            cell.delegate = self
            cell.indexSelect = indexPath
            cell.selectionSection = indexPath.section
            
            let commentId = self.userFeeds?.feedDetail?.post?.allComment![indexPath.section - 1 ].replyComment![indexPath.row].user_id

            if userObj?.id! == commentId  {
             if self.userFeeds?.feedDetail?.post!.user_as  == 1 && self.userFeeds?.feedDetail?.post?.user_id == self.userFeeds?.feedDetail?.post!.allComment![indexPath.section - 1].replyComment![indexPath.row].user_id {
                cell.lblName.text  = "Me".localized()
                cell.imgOfUser.image = UIImage(named: "anonymous_icon")
                let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

             }  else {
                    cell.lblName.text = "Me".localized()
                    guard  let image = userObj?.profile_image  else   {
                            return cell
                    }
                    cell.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

                }

                
            } else {
                
                if self.userFeeds?.feedDetail?.post!.user_as  == 1 && self.userFeeds?.feedDetail?.post?.user_id == self.userFeeds?.feedDetail?.post!.allComment![indexPath.section - 1].replyComment![indexPath.row].user_id  {
                    cell.lblName.text  = "Anonymous".localized()
                    cell.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

                } else {
                    cell.lblName.text = self.userFeeds?.feedDetail?.post?.allComment![indexPath.section - 1 ].replyComment![indexPath.row].userInfo?.full_name
                    guard  let image = self.userFeeds?.feedDetail?.post?.allComment![indexPath.section - 1 ].replyComment![indexPath.row].userInfo?.profile_image  else   {
                        return cell
                    }
                    cell.imgOfUser.setImage(with: image , placeholder: UIImage(named: "anonymous_icon"))
                    //                    WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "anonymous_icon")
                    let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: ReplyCommentCell.self, for: indexPath)
            return cell
        }
        
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 0
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
//        if tblViewss.contentOffset.y >= tblViewss.contentSize.height  - tblViewss.contentSize.width  {
//
//            if isPageRefreshing == false {
//                isPageRefreshing = true
//                page = page + 1
//
//                if page <= numberOfPage! {
//                    DispatchQueue.global(qos: .userInitiated).async {
//                        self.makeRequest(pageSize: self.page)
//                        DispatchQueue.main.async {
//                            self.tblViewss.reloadData()
//                        }
//                    }
//
//                } else {
//                    print("Not true")
//                }
//            }
//
//
//
//        }
    }
}

extension UBFeedDetailVC : ReportOnCommentDelegate  {
    func profileSelected(cell: ReplyCommentCell, selectIndex: IndexPath, sec: Int) {
        
        
                let userCommentId = self.userFeeds?.feedDetail?.post?.allComment![sec - 1].replyComment![selectIndex.row].user_id
//                 let userComment = self.userFeeds?.feedDetail?.post?.allComment![sender.tag].userInfo
                if feedObj?.user_as == 1 || userCommentId == self.userObj?.id {
        //            print("Hello")
                } else {
                  let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
                  if #available(iOS 10.0 , *)  {
                   vc?.modalPresentationStyle = .overCurrentContext
                 } else {
                   vc?.modalPresentationStyle = .currentContext
                 }
                   vc?.userInfo = self.userFeeds?.feedDetail?.post?.allComment![sec - 1].replyComment![selectIndex.row].userInfo
                   vc?.providesPresentationContextTransitionStyle = true
                   present(vc!, animated: true) {
                    }

                }

        
//
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
//        if #available(iOS 10.0 , *)  {
//            vc?.modalPresentationStyle = .overCurrentContext
//        } else {
//            vc?.modalPresentationStyle = .currentContext
//        }
//        present(vc!, animated: true) {
//
//        }

    }
    
    func reportOnComment(cell : ReplyCommentCell , selectIndex : IndexPath , sec : Int) {
        isSelectCommentOrReplyComment = true
        self.replyCommentId = self.userFeeds?.feedDetail?.post?.allComment![sec - 1].replyComment![selectIndex.row].id
      
        if userObj?.id == self.userFeeds?.feedDetail?.post?.allComment![sec - 1].replyComment![selectIndex.row].user_id {
            ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                self!.destroyReplyComent(selectIndex: selectIndex, sec: sec)
               
                return
            }, cancel: { (actionStrin ) in
                
            }, origin: cell.btnMore)
        } else {
            if  self.userFeeds?.feedDetail?.post?.user_id == self.userObj?.id {
                
                if isReplyCommentReported.contains((self.replyCommentId)!) {
                    ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Already Reported".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                        if index == 0 {
                            self?.destroyReplyComent(selectIndex: selectIndex , sec: sec)
                        }
                        return
                        }, cancel: { (actionStrin ) in
                            
                    }, origin: cell.btnMore)
                } else {
                    ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                        if index == 0 {
                            self?.destroyReplyComent(selectIndex: selectIndex , sec: sec)
                        } else if index == 1 {
                            self!.viewOfPop.isHidden = false
                        }
                        return
                        }, cancel: { (actionStrin ) in
                            
                    }, origin: cell.btnMore)

                }
        } else {
         if isReplyCommentReported.contains((self.replyCommentId)!) {

            ActionSheetStringPicker.show(withTitle: "", rows: ["Already Reported".localized()] , initialSelection: 0 , doneBlock: {[weak self] (picker, index, value) in
//                    self!.viewOfPop.isHidden  = false
                return
            }, cancel: { (actionStrin ) in
                
            }, origin: cell.btnMore)
         } else {
            ActionSheetStringPicker.show(withTitle: "", rows: ["Report".localized()] , initialSelection: 0 , doneBlock: {[weak self] (picker, index, value) in
                self!.viewOfPop.isHidden  = false
                return
                }, cancel: { (actionStrin ) in
                    
            }, origin: cell.btnMore)
           }
         }
      }
    }
}

extension UBFeedDetailVC : ReplyOnCommentDelegate {
    @objc func replyOnComment(cell : CommentCell , selectIndex : IndexPath , sec : Int) {


    }
}

extension UBFeedDetailVC :  GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self!.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if txtComment.text.count > 0 {
            self.btnComment.isUserInteractionEnabled = true
            self.btnComment.setImage(UIImage(named: "send"), for: .normal)

        } else {
            self.btnComment.isUserInteractionEnabled = false
            self.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)

        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
      if txtComment.text.count > 0 {
            self.btnComment.isUserInteractionEnabled = true
        self.btnComment.setImage(UIImage(named: "send"), for: .normal)

        } else {
            self.btnComment.isUserInteractionEnabled = false
            self.btnComment.setImage(UIImage(named: "sendUn"), for: .normal)

        }
        
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
//        let count =  self.userFeeds?.feedDetail?.post?.allComment!.count
//        let sectionIndex = IndexSet(integer: count!)
//
//        tblViewss.reloadSections(sectionIndex, with: .none)
//        let sectionIndexPath = IndexPath(row: NSNotFound, section: (!)
//        tblViewss.reloadSections(NSIndexSet(index: sectionIndexPath.row) as IndexSet, with: .none)

        
//        let sectionRect = tblViewss.rect(forSection: (self.userFeeds?.feedDetail?.post?.allComment!.count)!)
//        tblViewss.scrollRectToVisible(sectionRect, animated: false)

    }
//    return self.userFeeds?.feedDetail?.post?.allComment![section - 1].replyComment?.count ?? 0
}

extension UBFeedDetailVC :  UserPostDetailDeledate {
    func selectUserOnHeaderPost(cell: FeedHeaderCell, index: Int) {
        
        let feedObj = self.userFeeds?.feedDetail?.post
        if feedObj?.user_as == 1 || feedObj?.user_id == self.userObj?.id {
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
            if #available(iOS 10.0 , *)  {
                vc?.modalPresentationStyle = .overCurrentContext
            } else {
                vc?.modalPresentationStyle = .currentContext
            }
            vc?.feedObj = feedObj
            vc?.providesPresentationContextTransitionStyle = true
            present(vc!, animated: true) {
                
            }
            
        }

    }
    
    
    func isAddToFav(cell : FeedHeaderCell , sec : Int) {
        var feedObj : FeedsObject?
        
        if cell.btnIsFavSelect.isSelected == true {
            DispatchQueue.global().async { [weak self] in
                self!.postFav(post: self!.feedObj!)
                DispatchQueue.main.sync {
                    self!.userFeeds?.feedDetail?.post?.is_favorite = true


                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
             self!.postFav(post: self!.feedObj!)
                DispatchQueue.main.sync {
                    self!.userFeeds?.feedDetail?.post?.is_favorite = false
                }
                
            }
            

        }
    }
    
    func isReportOrShare(cell : FeedHeaderCell , sec : Int) {
         let feedObj = self.feedObj
//        var dropdownOptions: [DropdownView.Option]
        self.txtComment.resignFirstResponder()
        self.viewOfReply.isHidden = true

        isReplySelect = false

        if userObj?.id == self.userFeeds?.feedDetail?.post?.user_id {
            
            ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Edit".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                if index == 0 {
                   self!.postDestroyOnDetail(post: feedObj!, index: sec)
                } else if index == 1 {
                    self!.editPost(post: feedObj!)
                }
                return
                }, cancel: { (actionStrin ) in
                    
            }, origin: cell.btnReport)
        } else {
            
            if self.userFeeds?.feedDetail?.post?.is_reported == true {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Already Reported".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
            } else {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    self!.reportPost(post: feedObj!)
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
            }
        }
    }
    
    func isUserLike(cell : FeedHeaderCell , sec : Int) {
        
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "0", isReactionOnPost: cell)
            
            DispatchQueue.main.sync {
                if cell.btnUserLike.isSelected  == true {
                    self!.setReaction(post: feedObj!  , isClickReaction: "0", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                } else {
                    self!.setReaction(post: feedObj! , isClickReaction: "0", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                }

            }
        }
    }
    
    func isUserDislike(cell : FeedHeaderCell , sec : Int) {
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "1", isReactionOnPost: cell)
            DispatchQueue.main.sync {
                if cell.btnDislike.isSelected  == true {
                    self!.setReaction(post: feedObj!  , isClickReaction: "1", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                } else {
                    self!.setReaction(post: feedObj! , isClickReaction: "1", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                }

            }
        }
    }
    func isUserHappyClick(cell : FeedHeaderCell , sec : Int) {
        
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "2", isReactionOnPost: cell)
            
            DispatchQueue.main.sync {
                if cell.btnHappy.isSelected  == true {
                    self!.setReaction(post: feedObj!  , isClickReaction: "2", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                } else {
                    self!.setReaction(post: feedObj! , isClickReaction: "2", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                    
                }

            }
        }
    }
    func isUserAngry(cell : FeedHeaderCell , sec : Int) {
        
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "5", isReactionOnPost: cell)
            
            DispatchQueue.main.sync {
                if cell.btnAngry.isSelected  == true {
                    self!.setReaction(post: feedObj!  , isClickReaction: "5", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                } else {
                    self!.setReaction(post: feedObj! , isClickReaction: "5", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnUserLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnHappy.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                }

            }
        }
    }
}

extension UBFeedDetailVC :  UserPollingDeledates {
    func selectUserOnHeaderPoll(cell: FeedHeaderPollCell, index: Int) {
        let feedObj = self.userFeeds?.feedDetail?.post
        if feedObj?.user_as == 1 || feedObj?.user_id == self.userObj?.id {
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
            if #available(iOS 10.0 , *)  {
                vc?.modalPresentationStyle = .overCurrentContext
            } else {
                vc?.modalPresentationStyle = .currentContext
            }
            vc?.feedObj = feedObj
            vc?.providesPresentationContextTransitionStyle = true
            present(vc!, animated: true) {
                
            }
            
        }
    }
    
   
    
    func isReportOrSHARE(cell: FeedHeaderPollCell, indexs: Int, sender: UIButton) {
        
//        let feedObj = self.feedObj
        let feedObj = self.feedObj
//        var dropdownOptions: [DropdownView.Option]
        
        self.txtComment.resignFirstResponder()
        isReplySelect = false
        self.viewOfReply.isHidden = true
        if userObj?.id == self.userFeeds?.feedDetail?.post?.user_id {
            
            if  self.userFeeds?.feedDetail?.post?.total_poll_votes != nil {
              
                ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                        self!.postDestroyOnDetail(post: feedObj!, index: indexs)
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)

//                dropdownOptions = [
//                    DropdownView.Option(title: "Delete",      action: { }) ,
//                ]
            } else {
                
                ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Edit".localized() ] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    if index == 0 {
                        self!.postDestroyOnDetail(post: feedObj!, index: indexs)
                    } else if index == 1 {
                        self!.editPost(post: feedObj!)
                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
            }

        } else {
            
            if self.userFeeds?.feedDetail?.post?.is_reported == true {
                
                ActionSheetStringPicker.show(withTitle: "", rows: ["Already Reported".localized() ] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
            } else {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Report".localized() ] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    
                    self!.reportPost(post: feedObj!)
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
            }
        }
    }
    
    
    func isAddToFAV(cell : FeedHeaderPollCell , index : Int) {
        var feedObj : FeedsObject?
        if cell.btnFav.isSelected == true {
            DispatchQueue.global().async { [weak self] in
                self!.postFav(post: (self!.userFeeds?.feedDetail?.post!)!)
                DispatchQueue.main.sync {
                    self!.userFeeds?.feedDetail?.post?.is_favorite = true
                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
                    self!.postFav(post: self!.feedObj!)
                DispatchQueue.main.sync {
                    
                    
                    self!.userFeeds?.feedDetail?.post?.is_favorite = false


                }
            }
        }
    }
    
   func isReportOrSHARE(cell : FeedHeaderPollCell , indexs : Int) {
    
    }
    
    func isUserLIKES(cell : FeedHeaderPollCell , index : Int) {
        
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.reactPoll(post: feedObj!, rection: "0", isReactOnPost: cell)
            DispatchQueue.main.sync {
                if cell.btnLike.isSelected  == true {
                    self!.setReactionOnPoll(post: feedObj!  , isClickReaction: "0", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                } else {
                    self!.setReactionOnPoll(post: feedObj! , isClickReaction: "0", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false

                }
            }
        }
    }
    
   func isUserDISLIKE(cell : FeedHeaderPollCell , index : Int) {
  
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.reactPoll(post: feedObj!, rection: "1", isReactOnPost: cell)
            DispatchQueue.main.sync {
                if cell.btnDislike.isSelected  == true {
                    self!.setReactionOnPoll(post: feedObj!  , isClickReaction: "1", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false
                } else {
                    self!.setReactionOnPoll(post: feedObj! , isClickReaction: "1", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false
                }

            }
        }

    }
    func isUserHappyCLICKS(cell : FeedHeaderPollCell , index : Int) {
        
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.reactPoll(post: feedObj!, rection: "2", isReactOnPost: cell)
            DispatchQueue.main.sync {
                if cell.btnLaugh.isSelected  == true {
                    self!.setReactionOnPoll(post: feedObj!  , isClickReaction: "2", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false
                } else {
                    self!.setReactionOnPoll(post: feedObj! , isClickReaction: "2", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false
                }

            }
        }
    }
     func isUserAngrESS(cell : FeedHeaderPollCell , index : Int) {
      
        let feedObj = self.userFeeds?.feedDetail?.post
        DispatchQueue.global().async { [weak self] in
            self!.reactPoll(post: feedObj!, rection: "5", isReactOnPost: cell)
            DispatchQueue.main.sync {
                if cell.btnAngry.isSelected  == true {
                    self!.setReactionOnPoll(post: feedObj!  , isClickReaction: "5", alreadeReaction: feedObj?.user_reaction, cell: cell, isSelected: true)
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false
                } else {
                    self!.setReactionOnPoll(post: feedObj! , isClickReaction: "5", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false )
                    cell.btnLike.isUserInteractionEnabled = false
                    cell.btnDislike.isUserInteractionEnabled = false
                    cell.btnLaugh.isUserInteractionEnabled = false
                    cell.btnAngry.isUserInteractionEnabled = false
                }

            }
        }
    }
    
    
    func pollQuestion1(cell : FeedHeaderPollCell , index : Int , btnIndex : Int) {
        let optionId = self.userFeeds?.feedDetail?.post!.postOption![btnIndex].id
//        self.voteOnPoll(optionId: optionId!)
        self.voteOnPoll(optionId: optionId! , cell: cell)
        cell.btnQuestion1.isUserInteractionEnabled = false

    }

    func pollQuestion2(cell : FeedHeaderPollCell , index : Int , btnIndex : Int) {
        let optionId = self.userFeeds?.feedDetail?.post!.postOption![btnIndex].id
//        self.voteOnPoll(optionId: optionId!)
        self.voteOnPoll(optionId: optionId! , cell: cell)
        cell.btnQuestion2.isUserInteractionEnabled = false


    }

    func pollQuestion3(cell : FeedHeaderPollCell , index : Int , btnIndex : Int) {
        let optionId = self.userFeeds?.feedDetail?.post!.postOption![btnIndex].id
//        self.voteOnPoll(optionId: optionId!)
        self.voteOnPoll(optionId: optionId! , cell: cell)
        cell.btnQuestion3.isUserInteractionEnabled = false


    }

    func pollQuestion4(cell : FeedHeaderPollCell , index : Int , btnIndex : Int) {
        let optionId = self.userFeeds?.feedDetail?.post!.postOption![btnIndex].id
//        self.voteOnPoll(optionId: optionId!)
        self.voteOnPoll(optionId: optionId! , cell: cell)
        cell.btnQuestion4.isUserInteractionEnabled = false


    }
    
    func pollQuestion5(cell: FeedHeaderPollCell, index: Int, btnIndex: Int) {
        let optionId = self.userFeeds?.feedDetail?.post!.postOption![btnIndex].id
//        self.voteOnPoll(optionId: optionId!)
        self.voteOnPoll(optionId: optionId! , cell: cell)
        cell.btnQuestion5.isUserInteractionEnabled = false



    }
    
}

