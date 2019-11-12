//
//  UBFeedsVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
//import FirebasePerformance
import SCLAlertView
import iosMath
import SlideMenuControllerSwift

class UBFeedsVC: UIViewController  , UIGestureRecognizerDelegate {
    @IBOutlet weak var tblViewss: UITableView!
    var userObj : Session?
    
    @IBOutlet weak var topNabView: UIView!
    @IBOutlet weak var profileImage : UIImageView!
    var userFeeds : UserResponse?
    private let refreshControl = UIRefreshControl()
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    private var isPostFav  : [Int] = []
    private var postReaction  : [Int] = []
    private var postReactionId  : [Int] = []
    private var postReactionOfNull  : [Int] = []
    private var postReported  : [Int] = []
    private var userPostOrPoll  : [Int] = []
    var index: Int?
    
    var isUserLikeOrDislike = false
    //    private var reactionItem : [FeedItem] = []
    var pollIndexCheck : Int?
    var groupObj : GroupList?
    
    @IBOutlet weak var postButton: UIButton!
    var isComeFromPost : String?
    @IBOutlet weak var topConstraintOfTbleView: NSLayoutConstraint!
    
    @IBOutlet weak var viewOfPop: UIView!
    var postInfo : FeedsObject?
    @IBOutlet weak var btnSexualContent: UIButton!
    @IBOutlet weak var btnHateFull: UIButton!
    @IBOutlet weak var btnSpam: UIButton!
    var isRepot  = ""
    
    @IBOutlet weak var imgOfSexualContent : UIImageView!
    @IBOutlet weak var imgOfHateFul : UIImageView!
    @IBOutlet weak var imgOfSpam : UIImageView!
    
    var isSelectIndex : Int?
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var  group = DispatchGroup()
    
    var reportFeedObj : FeedsObject?
    var reportIndex : IndexPath?
    var isSearch  : Bool?
    var sectionMessage : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isSearch = false
        searchBar.showsCancelButton = false
        if isComeFromPost == "GROUP"  {
            topNabView.updateConstraintsIfNeeded()
            topNabView.layoutIfNeeded()
            topNabView.isHidden = true
            if #available(iOS 11.0, *) {
                let window = UIApplication.shared.keyWindow
                if let topPadding = window?.safeAreaInsets.top {
                    topConstant.constant = -(topNabView.frame.size.height - topPadding)
                }
            }
        } else {
            postButton.isHidden = true
        }
        tblViewss.rowHeight = 0.0
        tblViewss.estimatedRowHeight = 0.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didLoadFeed(_:)), name: NSNotification.Name(rawValue: "PostNewCreate"), object: nil)
        getAllGroupList(page: 1)
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        
        tblViewss.registerCells([
            PostCell.self , PollingPostCell.self
        ])
        
    }
    
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @objc func didLoadFeed(_ notification: NSNotification) {
        getAllGroupList(page: 1)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.tabBarController?.selectedIndex = appDelegate.tabBarSelect
        
        if isComeFromPost == "GROUP"  {
            topConstraintOfTbleView.constant = 0
        } else if isComeFromPost == "MY POST" {
            topConstraintOfTbleView.constant = 120
            self.searchBar.isHidden = true
        } else if isComeFromPost == "SAVED" {
            topConstraintOfTbleView.constant = 120
            self.searchBar.isHidden = true
        }
        else {
            if #available(iOS 10.0, *) {
                tblViewss.refreshControl = refreshControl
            } else {
                tblViewss.addSubview(refreshControl)
            }
            topConstraintOfTbleView.constant = 0.0
            self.searchBar.isHidden = false
            refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
            //self.revealController.recognizesPanningOnFrontView = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tblViewss.reloadData()
        self.viewWillLayoutSubviews()
        self.refreshControl.endRefreshing()
    }
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet()  {
            tblViewss.isUserInteractionEnabled = false
            getAllGroupList(page: 1)
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
            
            //            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)
            
        }
    }
    
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("<<<<<<<<< UBFeedsVC delloc")
    }
    
    
    // API Calling
    
    
    func getAllGroupList(page : Int) {
        //        if Connectivity.isConnectedToInternet() {
        var serviceURL : String?
        if isComeFromPost == "GROUP" {
            if groupObj?.is_member == false && groupObj?.is_private_group == false {
                tblViewss.delegate = self
                self.searchBar.isHidden = true
                self.postButton.isHidden = true
                sectionMessage = "No access.".localized()
                tblViewss.dataSource = self
                tblViewss.reloadData()
                return
            } else if groupObj?.is_private_group == true && groupObj?.is_member == false && groupObj?.is_my_group == false {
                self.searchBar.isHidden = true
                self.postButton.isHidden = true
                tblViewss.delegate = self
                tblViewss.dataSource = self
                sectionMessage = "No access.".localized()
                tblViewss.reloadData()
                return
            }
            else {
                SVProgressHUD.show()
                let groupId = groupObj?.id
                self.postButton.isHidden = false
                self.searchBar.isHidden = false
                sectionMessage = "There are currently no Feeds in this group.".localized()
                serviceURL =  "\(GROUPVIEW)\(groupId!)"
            }
        } else if isComeFromPost == "MY POST" {
            serviceURL = USERPOST
        } else if isComeFromPost == "SAVED" {
            serviceURL = FAVOURITE
        }
        else {
            serviceURL = USERWALL
        }
        postReaction = []
        postReactionId = []
        postReported = []
        WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "User Feed".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
            guard let self = self else {return}
            SVProgressHUD.dismiss()
            self.userFeeds = (response as! UserResponse)
            self.page = 1
            self.isPageRefreshing = false
            self.searchBar.showsCancelButton = false
            self.numberOfPage = self.userFeeds?.feeds?.post?.last_page
            self.searchBar.resignFirstResponder()
            //self.revealController.recognizesPanningOnFrontView = true
            if self.userFeeds?.status == true {
                for (_ , feed) in ((self.userFeeds?.feeds?.post?.feedsObject?.enumerated())!) {
                    if feed.is_favorite == true {
                        self.isPostFav.append(feed.id!)
                    }
                    if feed.user_reaction != nil {
                        self.postReactionId.append(feed.id!)
                        self.postReaction.append(feed.user_reaction!)
                    }
                    if feed.user_reaction == nil {
                        self.postReactionOfNull.append(feed.id!)
                    }
                    
                    if feed.user_id == self.userObj?.id {
                        self.userPostOrPoll.append(feed.id!)
                    }
                    if feed.is_reported == true {
                        self.postReported.append(feed.id!)
                    }
                }
                self.searchBar.text = ""
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.reloadData()
                self.refreshControl.endRefreshing()
                self.tblViewss.isUserInteractionEnabled = true
                self.page = self.page + 1
            } else {
                self.showAlert(title: KMessageTitle, message: (self.userFeeds?.message!)!, controller: self)
                self.refreshControl.endRefreshing()
                self.tblViewss.isUserInteractionEnabled = true
            }
        }) { (error) in
            self.tblViewss.isUserInteractionEnabled = true
        }
        
    }
   
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        var serviceUrl = "\(USERWALL)?q=\(allSearch)"
        if isComeFromPost == "GROUP" {
            let groupId = groupObj?.id
            serviceUrl =  "\(GROUPVIEW)\(groupId!)?q=\(allSearch)"
        }
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
            
            self.userFeeds = (response as! UserResponse)
            if self.userFeeds?.status == true {
                self.page = 1
                self.numberOfPage = self.userFeeds?.feeds?.post?.last_page
                for (_ , feed) in ((self.userFeeds?.feeds?.post?.feedsObject?.enumerated())!) {
                    if feed.is_favorite == true {
                        self.isPostFav.append(feed.id!)
                    }
                    
                    if feed.user_reaction != nil {
                        self.postReactionId.append(feed.id!)
                        self.postReaction.append(feed.user_reaction!)
                    }
                    
                    if feed.user_id == self.userObj?.id {
                        self.userPostOrPoll.append(feed.id!)
                    }
                    
                    if feed.is_reported == true {
                        self.postReported.append(feed.id!)
                    }
                }
                
                self.tblViewss.reloadData()
                self.refreshControl.endRefreshing()
            } else {
                self.showAlert(title: KMessageTitle, message: (self.userFeeds?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
    
    
    func removeDuplicates<T: Equatable>(accumulator: [T], element: T) -> [T] {
        return accumulator.contains(element) ?
            accumulator :
            accumulator + [element]
    }
    
    func makeRequest(pageSize : Int)  {
        print("page Size \(pageSize)")
        let serviceURL : String?
        if isComeFromPost == "GROUP" {
            let groupId = groupObj?.id
            serviceURL =  "\(GROUPVIEW)\(groupId!)?page=\(page)"
        } else if isComeFromPost == "MY POST" {
            serviceURL = "\(USERPOST)?page=\(page)"
        } else if isComeFromPost == "SAVED" {
            serviceURL = "\(FAVOURITE)?page=\(page)"
        } else {
            serviceURL = "\(USERWALL)?page=\(page)"
        }
        WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: UserResponse.self , success: { [weak self] (response) in
            
            guard let self = self else {return}
            
            let responeOfPagination = (response as? UserResponse)!
            self.numberOfPage = responeOfPagination.feeds?.post?.last_page
            if responeOfPagination.status == true {
                self.isPageRefreshing = false
                DispatchQueue.main.async {
                    for (_ , obj) in ((responeOfPagination.feeds?.post?.feedsObject?.enumerated())!) {
                        self.userFeeds?.feeds?.post?.feedsObject?.append(obj)
                    }
                    for (_ , feed) in ((responeOfPagination.feeds?.post?.feedsObject?.enumerated())!) {
                        if feed.is_favorite == true {
                            self.isPostFav.append(feed.id!)
                        }
                        if feed.user_reaction != nil {
                            self.postReactionId.append(feed.id!)
                            self.postReaction.append(feed.user_reaction!)
                        }
                        if feed.user_reaction == nil {
                            self.postReactionOfNull.append(feed.id!)
                        }
                        if feed.user_id == self.userObj?.id {
                            self.userPostOrPoll.append(feed.id!)
                        }
                        if feed.is_reported == true {
                            self.postReported.append(feed.id!)
                            
                        }
                    }
                    
                    self.tblViewss.tableFooterView?.isHidden = true
                    self.activity.stopAnimating()
                    self.tblViewss.reloadData()
                    self.tblViewss.layoutIfNeeded()
                    self.refreshControl.endRefreshing()
                    
                    self.page = self.page + 1
                    
                }
            }
            else
            {
                
            }
        }) { (error) in
        }
    }
    
    
    
    
    // Reaction  on Post
    
    func rectOnPoll(post : FeedsObject , rection : String , index  : Int , isReactOnPost : PollingPostCell) {
        let postId = post.id
        //        group.enter()
        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.reactOnPost(postId: "\(postId!)", reaction: rection)
        NetworkLayer.fetchPost(endPointss , url: endPoint, with: LoginResponse.self) { [weak self](result) in
            switch result {
                
            case .success(let response):
                //                CFRunLoopStop(CFRunLoopGetCurrent())
                if response.status == true {
                    self!.postReaction.append((postId)!)
                    
                    if post.user_reaction != nil {
                        self!.postReaction.append((post.user_reaction)!)
                    }
                    
                    isReactOnPost.btnLike.isUserInteractionEnabled    = true
                    isReactOnPost.btnDislike.isUserInteractionEnabled = true
                    isReactOnPost.btnLaugh.isUserInteractionEnabled   = true
                    isReactOnPost.btnAngry.isUserInteractionEnabled   = true
                }
            case .failure(let error):
                break
            }
            
        }
    }
    
    
    func rectOnPost(post : FeedsObject , rection : String , index  : Int , isReactOnPost : PostCell) {
        let postId = post.id
        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.reactOnPost(postId: "\(postId!)", reaction: rection)
        NetworkLayer.fetchPost(endPointss , url: endPoint, with: LoginResponse.self) {[weak self] (result) in
            switch result {
            case .success(let response):
                if response.status == true {
                    self!.postReaction.append((post.id)!)
                    if post.user_reaction != nil {
                        self!.postReaction.append((post.user_reaction)!)
                    }
                    isReactOnPost.btnLike.isUserInteractionEnabled = true
                    isReactOnPost.btnDislike.isUserInteractionEnabled = true
                    isReactOnPost.btnLaugh.isUserInteractionEnabled = true
                    isReactOnPost.btnAngry.isUserInteractionEnabled = true
                }
            case .failure(let error):
                break
            }
            
        }
    }
    
    
    func postFav(fedObj : FeedsObject , index : IndexPath) {
        
        let postId = fedObj.id
        let endPoint = "\(POSTFAV)/\(postId!)"
        //        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.fav(postId: "\(postId!)")
        //        group.enter()
        NetworkLayer.fetchPost(endPointss , url: endPoint , with: LoginResponse.self) {[weak self] (result) in
            switch result {
            case .success(let response):
                //                CFRunLoopStop(CFRunLoopGetCurrent())
                
                if response.status == true {
                    //                    self.group.leave()
                }
            case .failure(let error):
                break
            }
            
        }
    }
    
    func editPost(post : FeedsObject , index : Int) {
        if post.is_poll == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditPollVC") as? UBEditPollVC
            vc?.post = post
            vc?.selectIndex = index
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditPostVC") as? UBEditPostVC
            vc?.post = post
            vc?.selectIndex = index
            vc?.delegate = self
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    
    func confirm(post : FeedsObject , index : IndexPath) {
        let postId = post.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(POSTDESTROY)\(postId!)"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: {[weak self ] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
            }, fail: { (error) in
        }, showHUD: true)
        
    }
    
    
    func postDestroy(post : FeedsObject , index : IndexPath) {
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this ?".localized()) {
            self.userFeeds?.feeds?.post?.feedsObject?.remove(at: index.row)
            self.tblViewss.reloadData()
            self.confirm(post: post, index: index)
        }
    }
    
    
    @IBAction private func chreatePostBtn_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCreatePostVC") as? UBCreatePostVC
        vc?.groupObj = self.groupObj
        vc?.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction func btnSexualContent_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent.image = UIImage(named: "selected_ic")
        imgOfHateFul.image = UIImage(named: "checkUn")
        imgOfSpam.image = UIImage(named: "checkUn")
        
        isRepot = "Sexual content"
    }
    
    
    @IBAction func btnHateFull_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        imgOfSexualContent.image = UIImage(named: "checkUn")
        imgOfHateFul.image = UIImage(named: "selected_ic")
        imgOfSpam.image = UIImage(named: "checkUn")
        
        isRepot = "Hateful or abusive content"
        
    }
    
    @IBAction func btnSpam(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        imgOfSexualContent.image = UIImage(named: "checkUn")
        imgOfHateFul.image = UIImage(named: "checkUn")
        imgOfSpam.image = UIImage(named: "selected_ic")
        
        isRepot = "Spam or misleading"
        
    }
    
    func reportPost(post : FeedsObject , index : IndexPath) {
        postInfo = post
        reportFeedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        self.reportIndex = index
        viewOfPop.isHidden = false
        //
        //        let  feed = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        //        var feeds : FeedsObjects?
    }
    
    
    @IBAction func btnDone_Pressed(_ sender: UIButton) {
        
        if self.isRepot.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Please select the option".localized(), controller: self)
        } else {
            let postId = self.postInfo!.id
            let deviceParam =     ["post_id"            : "\(postId!)",
                "reason"                : self.isRepot
                ] as [String : Any]
            self.postReported.append(postId!)
            self.userFeeds?.feeds?.post?.feedsObject![self.reportIndex!.row].is_reported = true
            
            WebServiceManager.postJson(params:deviceParam as Dictionary<String, AnyObject> , serviceName: REPORT, serviceType: "Login".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
                if  let post = responseData as? UserResponse {
                    if post.status == true {
                        self!.viewOfPop.isHidden = true
                        self!.isRepot = ""
                        self!.imgOfSexualContent.image = UIImage(named: "checkUn")
                        self!.imgOfHateFul.image = UIImage(named: "checkUn")
                        self!.imgOfSpam.image = UIImage(named: "checkUn")
                        self!.tblViewss.reloadData()
                    } else {
                        self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    }
                }
                
                }, fail: { (error) in
            }, showHUD: true)
        }
    }
    
    @IBAction func btnCancel_Pressed(_ sender: UIButton) {
        viewOfPop.isHidden = true
        
        isRepot = ""
        imgOfSexualContent.image = UIImage(named: "checkUn")
        self.imgOfHateFul.image = UIImage(named: "checkUn")
        self.imgOfSpam.image = UIImage(named: "checkUn")
        
    }
    
    func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
        
    }
    
    
    
    func setReaction(post : FeedsObject , isClickReaction : String , alreadeReaction : Int?  , cell : PostCell , isSelected : Bool , index : IndexPath) {
        
        var feedObj : FeedsObject?
        if post.user_reaction != nil {
            if isClickReaction == "0" {
                if isSelected == true {
                    let  like = Int(cell.lblLikeCount.text!)
                    print("likeCount\(like!)")
                    let likeCount = like! + 1
                    cell.lblLikeCount.text = "\(likeCount)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = true
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                    
                    if alreadeReaction == 1 {
                        let  disL = Int(cell.lblDislikeCount.text!)
                        let disLikeCount = disL! - 1
                        cell.lblDislikeCount.text = "\(disLikeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        cell.btnDislike.isSelected    = false
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 2 {
                        let  hpy = Int(cell.lblHappy.text!)
                        let happyCount = hpy! - 1
                        cell.lblHappy.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyCount
                        
                        cell.btnLaugh.isSelected    = false
                    } else if alreadeReaction == 5 {
                        let  angr = Int(cell.lblAngry.text!)
                        let angryCount = angr! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        
                        cell.btnLaugh.isSelected    = false
                    }
                    
                } else {
                    let  like = Int(cell.lblLikeCount.text!)
                    let likeCount = like! - 1
                    print("Dislike\(like!)")
                    
                    cell.lblLikeCount.text = "\(likeCount)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                }
            }
            else if isClickReaction == "1" {
                if isSelected == true {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disLikeCount = like! + 1
                    cell.lblDislikeCount.text = "\(disLikeCount)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = true
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                    
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                        
                        cell.btnLike.isSelected    = false
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let happyCount = like! - 1
                        cell.lblHappy.text = "\(happyCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                        cell.btnLaugh.isSelected    = false
                        
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                        
                        cell.btnLaugh.isSelected    = false
                    }
                    
                } else {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disL = like! - 1
                    cell.lblDislikeCount.text = "\(disL)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disL
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                    
                }
            }
            else if isClickReaction == "2" {
                if isSelected == true {
                    let  hpy = Int(cell.lblHappy.text!)
                    let happyMode = hpy! + 1
                    cell.lblHappy.text = "\(happyMode)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = true
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyMode
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        //                        cell.btnLike.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyMode
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        cell.btnLike.isSelected    = false
                        
                        
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLikeCheck = like! - 1
                        cell.lblDislikeCount.text = "\(disLikeCheck)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        cell.btnDislike.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyMode
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCheck
                        
                        
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        cell.btnAngry.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyMode
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                        
                    }
                    
                } else {
                    let  like = Int(cell.lblHappy.text!)
                    let hpY = like! - 1
                    cell.lblHappy.text = "\(hpY)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = hpY
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                }
            }
            else if isClickReaction == "5" {
                if isSelected == true {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! + 1
                    cell.lblAngry.text = "\(angryCount)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       =     false
                    cell.btnLaugh.isSelected      =     false
                    cell.btnDislike.isSelected    =     false
                    cell.btnAngry.isSelected      =     true
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        cell.btnLike.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLike = like! - 1
                        cell.lblDislikeCount.text = "\(disLike)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        cell.btnDislike.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLike
                        //                        cell.btnLaugh.isSelected    = false
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let hpyCount = like! - 1
                        cell.lblHappy.text = "\(hpyCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        cell.btnLaugh.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = hpyCount
                    }
                    
                } else {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! - 1
                    cell.lblAngry.text = "\(angryCount)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                }
            }
        } else {
            
            if isClickReaction == "0" {
                let  like = Int(cell.lblLikeCount.text!)
                let likeCount = like! + 1
                cell.lblLikeCount.text = "\(likeCount)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                
                cell.btnLike.isSelected       = true
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "1" {
                let  like = Int(cell.lblDislikeCount.text!)
                let disLike = like! + 1
                cell.lblDislikeCount.text = "\(disLike)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLike
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = true
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "2" {
                let  like = Int(cell.lblHappy.text!)
                let laugh = like! + 1
                cell.lblHappy.text = "\(laugh)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = true
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = laugh
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                
                
            } else if isClickReaction == "5" {
                let  like = Int(cell.lblAngry.text!)
                let angryCount = like! + 1
                cell.lblAngry.text = "\(angryCount)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = true
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                
                //                feedObj = FeedsObjects(id: post.id, user_id: post.user_id, user_as: post.user_as, student_group_id: post.student_group_id , parent_id: post.parent_id , slug: post.slug, comment: post.comment, status: post.status, is_delete: post.is_delete, announcement: post.announcement, allow_comment: post.allow_comment, post_like_count: post.post_like_count   , post_dislike_count : post.post_dislike_count  , post_laugh_count: post.post_laugh_count , post_angry_count: angryCount , is_favorite: post.is_favorite, user_reaction: 5  , post_group_name: post.post_group_name , created_at: post.created_at, is_poll: post.is_poll, total_poll_votes: post.total_poll_votes, total_comments: post.total_comments, is_voted: post.is_voted, is_reported: post.is_reported , is_edited: post.is_edited ,   user: post.user , postOption: post.postOption, allComment: post.allComment, commentAvatar: post.commentAvatar, groupInfo: post.groupInfo)
                //                self.userFeeds?.feeds?.post?.feedsObject![index.row] = feedObj!
                
                
            }
            
        }
        
    }
    
    func setReactionOnPoll(post : FeedsObject , isClickReaction : String , alreadeReaction : Int?  , cell : PollingPostCell , isSelected : Bool , index : IndexPath) {
        //        var feedObj : FeedsObject?
        if post.user_reaction != nil {
            if isClickReaction == "0" {
                if isSelected == true {
                    let  like = Int(cell.lblLikeCount.text!)
                    let likeCount = like! + 1
                    cell.lblLikeCount.text = "\(likeCount)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = true
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                    if alreadeReaction == 1 {
                        let  disL = Int(cell.lblDislikeCount.text!)
                        let disLikeCount = disL! - 1
                        cell.lblDislikeCount.text = "\(disLikeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                        cell.btnDislike.isSelected    = false
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 2 {
                        let  hpy = Int(cell.lblHappy.text!)
                        let happyCount = hpy! - 1
                        cell.lblHappy.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                        cell.btnLaugh.isSelected    = false
                    } else if alreadeReaction == 5 {
                        let  angr = Int(cell.lblAngry.text!)
                        let angryCount = angr! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                        cell.btnLaugh.isSelected    = false
                    }
                    
                } else {
                    let  like = Int(cell.lblLikeCount.text!)
                    let likeCount = like! - 1
                    cell.lblLikeCount.text = "\(likeCount)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnLike.isSelected       = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                    //                    self.userFeeds?.feeds?.post?.feedsObject![index.row] = post!
                    
                    
                }
            }
            else if isClickReaction == "1" {
                if isSelected == true {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disLikeCount = like! + 1
                    cell.lblDislikeCount.text = "\(disLikeCount)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = true
                    cell.btnAngry.isSelected      = false
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                    
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count = likeCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let happyCount = like! - 1
                        cell.lblHappy.text = "\(happyCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disLikeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count = angryCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                    }
                    
                } else {
                    let  like = Int(cell.lblDislikeCount.text!)
                    let disL = like! - 1
                    cell.lblDislikeCount.text = "\(disL)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnDislike.isSelected    = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count = disL
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                }
            }
            else if isClickReaction == "2" {
                if isSelected == true {
                    let  hpy = Int(cell.lblHappy.text!)
                    let happyMode = hpy! + 1
                    cell.lblHappy.text = "\(happyMode)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = true
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count = happyMode
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                    
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = happyMode
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count  = likeCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                        
                        
                        //                        cell.btnAngry.isSelected      = false
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLikeCheck = like! - 1
                        cell.lblDislikeCount.text = "\(disLikeCheck)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        //                        cell.btnLaugh.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = happyMode
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count  = disLikeCheck
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                    } else if alreadeReaction == 5 {
                        let  like = Int(cell.lblAngry.text!)
                        let angryCount = like! - 1
                        cell.lblAngry.text = "\(angryCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        //                        cell.btnLaugh.isSelected    = false
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = happyMode
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                    }
                    
                } else {
                    let  like = Int(cell.lblHappy.text!)
                    let hpY = like! - 1
                    cell.lblHappy.text = "\(hpY)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    //                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = hpY
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                    
                    
                    
                    
                    
                }
            }
            else if isClickReaction == "5" {
                if isSelected == true {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! + 1
                    cell.lblAngry.text = "\(angryCount)"
                    self.postReactionId.append((post.id!))
                    if post.user_reaction != nil {
                        self.postReaction.append(post.user_reaction!)
                    }
                    cell.btnLike.isSelected       = false
                    cell.btnLaugh.isSelected      = false
                    cell.btnDislike.isSelected    = false
                    cell.btnAngry.isSelected      = true
                    
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                    
                    
                    if alreadeReaction == 0 {
                        let  like = Int(cell.lblLikeCount.text!)
                        let likeCount = like! - 1
                        cell.lblLikeCount.text = "\(likeCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count  = likeCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                        
                    } else if alreadeReaction == 1 {
                        let  like = Int(cell.lblDislikeCount.text!)
                        let disLike = like! - 1
                        cell.lblDislikeCount.text = "\(disLike)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count  = disLike
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                        
                        
                        //                        cell.btnLaugh.isSelected    = false
                    } else if alreadeReaction == 2 {
                        let  like = Int(cell.lblHappy.text!)
                        let hpyCount = like! - 1
                        cell.lblHappy.text = "\(hpyCount)"
                        if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                            self.postReactionId.remove(at: index)
                        }
                        //                        cell.btnAngry.isSelected    = false
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = hpyCount
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                        
                    }
                    
                } else {
                    let  like = Int(cell.lblAngry.text!)
                    let angryCount = like! - 1
                    cell.lblAngry.text = "\(angryCount)"
                    if let index  = self.postReactionId.index(where: {$0 == userObj?.id}) {
                        self.postReactionId.remove(at: index)
                    }
                    cell.btnAngry.isSelected      = false
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                    //                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = hpyCount
                    self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = -1
                }
            }
        } else {
            
            if isClickReaction == "0" {
                let  like = Int(cell.lblLikeCount.text!)
                let likeCount = like! + 1
                cell.lblLikeCount.text = "\(likeCount)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_like_count  = likeCount
                //                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = hpyCount
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 0
                
                cell.btnLike.isSelected       = true
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "1" {
                let  like = Int(cell.lblDislikeCount.text!)
                let disLike = like! + 1
                cell.lblDislikeCount.text = "\(disLike)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_dislike_count  = disLike
                //                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = hpyCount
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 1
                
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = true
                cell.btnAngry.isSelected      = false
                
            } else if isClickReaction == "2" {
                let  like = Int(cell.lblHappy.text!)
                let laugh = like! + 1
                cell.lblHappy.text = "\(laugh)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = true
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = false
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = laugh
                //                    self.userFeeds?.feeds?.post?.feedsObject![index.row].post_laugh_count  = hpyCount
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 2
                
            } else if isClickReaction == "5" {
                let  like = Int(cell.lblAngry.text!)
                let angryCount = like! + 1
                cell.lblAngry.text = "\(angryCount)"
                self.postReactionId.append((post.id!))
                if post.user_reaction != nil {
                    self.postReaction.append(post.user_reaction!)
                }
                cell.btnLike.isSelected       = false
                cell.btnLaugh.isSelected      = false
                cell.btnDislike.isSelected    = false
                cell.btnAngry.isSelected      = true
                
                self.userFeeds?.feeds?.post?.feedsObject![index.row].post_angry_count  = angryCount
                self.userFeeds?.feeds?.post?.feedsObject![index.row].user_reaction = 5
                
            }
            
        }
        
    }
}



extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}



extension UBFeedsVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  self.userFeeds?.feeds?.post?.feedsObject!.isEmpty == false {
            numOfSections = 1
            tblViewss.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            
            if self.isComeFromPost == "GROUP" {
                noDataLabel.text = sectionMessage
                
            } else {
                noDataLabel.text = "There are currently no Feeds in your wall.".localized()
                
            }
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tblViewss.backgroundView = noDataLabel
            tblViewss.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //            return self.userFeeds?.feeds?.post?.feedsObject?.count ?? 0
        return self.userFeeds?.feeds?.post?.feedsObject?.count ?? 0
        
        
        //            return self.userFeeds?.feeds?.post?.feedsObject?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count != 0 {
            //            let cell = tableView.dequeueReusableCell(with: PollingPostCell.self, for: indexPath)
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "PollingPostCell") as? PollingPostCell
            if cell == nil {
                cell = PollingPostCell(style: .default, reuseIdentifier: "PollingPostCell")
            }
            cell!.lblUni.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_group_name
            cell!.lblDate.text = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].created_at)!)
            cell!.lblPost.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
            let totalComment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].total_comments
            let likeCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_like_count
            let disLike = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_dislike_count
            let launghCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_laugh_count
            let angry = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_angry_count
            let vote = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].total_poll_votes
            let userReaction = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_reaction
            if isComeFromPost == "SAVED" {
                cell!.btnReport.isHidden = true
            } else {
                cell!.btnReport.isHidden = false
            }
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].is_edited == true {
                let updatedDate = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].update_at)!)
                cell?.lblEdited.isHidden = false
                cell?.lblEdited.text = "edited".localized() + " \(updatedDate)"
            } else {
                cell?.lblEdited.isHidden = true
                
            }
            
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].allow_comment == 0 {
                if let image = UIImage(named: "comments") {
                    cell!.btnComment.setImage(image , for: .normal)
                }
                
                if totalComment != nil {
                    cell!.btnComment.setTitle("\(totalComment!)", for: .normal)
                } else {
                    cell!.btnComment.setTitle("0".localized(), for: .normal)
                }
                
                if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 1  {
                    cell!.imgOfAvatarSecond.isHidden = true
                    cell!.imgOfAvatarThird.isHidden = true
                    cell!.imgOfAvatarFourth.isHidden = true
                    cell!.imgOfAvatarFirst.isHidden = false
                    
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge  else   {
                        return cell!
                    }
                    cell!.imgOfAvatarFirst.setImage(with: image, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloat))
                    
                } else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 2  {
                    cell!.imgOfAvatarFirst.isHidden = false
                    cell!.imgOfAvatarSecond.isHidden = false
                    cell!.imgOfAvatarThird.isHidden = true
                    cell!.imgOfAvatarFourth.isHidden = true
                    
                    let imge = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge
                    cell!.imgOfAvatarFirst.setImage(with: imge, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imge! , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloats: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloats = Float(cgFloats)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloats))
                    
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![1].imge  else   {
                        return cell!
                    }
                    
                    cell!.imgOfAvatarSecond.setImage(with: image, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarSecond!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarSecond.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarSecond, radius: CGFloat(someFloat))
                    
                } else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 3  {
                    cell!.imgOfAvatarFirst.isHidden = false
                    cell!.imgOfAvatarSecond.isHidden = false
                    cell!.imgOfAvatarThird.isHidden = false
                    cell!.imgOfAvatarFourth.isHidden = true
                    
                    let imge = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge
                    
                    cell!.imgOfAvatarFirst.setImage(with: imge, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imge! , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloats: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloats = Float(cgFloats)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloats))
                    
                    
                    let imgess = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![1].imge
                    cell!.imgOfAvatarSecond.setImage(with: imgess, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imgess! , imageView: (cell!.imgOfAvatarSecond!), placeHolder: "profile2")
                    let cgFloatss: CGFloat = cell!.imgOfAvatarSecond.frame.size.width/2.0
                    let someFloatss = Float(cgFloatss)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![2].imge  else   {
                        return cell!
                    }
                    
                    cell!.imgOfAvatarThird.setImage(with: image, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarThird!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarThird.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarThird, radius: CGFloat(someFloat))
                    
                }
                else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 4  {
                    cell!.imgOfAvatarFirst.isHidden = false
                    cell!.imgOfAvatarSecond.isHidden = false
                    cell!.imgOfAvatarThird.isHidden = false
                    cell!.imgOfAvatarFourth.isHidden = false
                    
                    let imge = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge
                    cell!.imgOfAvatarFirst.setImage(with: imge, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imge! , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloats: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloats = Float(cgFloats)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloats))
                    
                    
                    let imgess = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![1].imge
                    cell!.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imgess! , imageView: (cell!.imgOfAvatarSecond!), placeHolder: "profile2")
                    let cgFloatss: CGFloat = cell!.imgOfAvatarSecond.frame.size.width/2.0
                    let someFloatss = Float(cgFloatss)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                    
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![2].imge  else   {
                        return cell!
                    }
                    
                    cell!.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarThird!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarThird.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarThird, radius: CGFloat(someFloat))
                    
                    
                    guard  let imagessss = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![3].imge  else   {
                        return cell!
                    }
                    
                    cell!.imgOfAvatarFourth.setImage(with: imagessss , placeholder: UIImage(named: "profile2"))
                    let cg : CGFloat = cell!.imgOfAvatarFourth.frame.size.width/2.0
                    let someFlo = Float(cg)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFourth, radius: CGFloat(someFlo))
                } else {
                    cell!.imgOfAvatarSecond.isHidden = true
                    cell!.imgOfAvatarThird.isHidden = true
                    cell!.imgOfAvatarFourth.isHidden = true
                    cell!.imgOfAvatarFirst.isHidden = true
                }
            } else {
                if let image = UIImage(named: "disable_comments") {
                    cell!.btnComment.setImage(image , for: .normal)
                    cell!.btnComment.setTitle("0", for: .normal)
                    
                }
                
                cell!.imgOfAvatarSecond.isHidden = true
                cell!.imgOfAvatarThird.isHidden = true
                cell!.imgOfAvatarFourth.isHidden = true
                cell!.imgOfAvatarFirst.isHidden = true
                
                cell!.btnComment.setTitle("0", for: .normal)
            }
            if isPostFav.contains((self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].id)!) {
                cell!.btnFav.isSelected = true
            } else {
                cell!.btnFav.isSelected = false
            }
            if postReactionId.contains((self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].id)!) {
                if userReaction != nil {
                    if postReaction.contains((userReaction)!) {
                        if userReaction == 0 {
                            cell!.btnLike.isSelected = true
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = false
                        } else if userReaction == 1 {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = true
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = false
                            
                            
                        } else if userReaction == 2 {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = true
                            cell!.btnAngry.isSelected = false
                        } else if  userReaction == 5 {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = true
                        } else  {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = false
                        }
                        
                    }
                } else {
                    cell!.btnLike.isSelected = false
                    cell!.btnDislike.isSelected = false
                    cell!.btnLaugh.isSelected = false
                    cell!.btnAngry.isSelected = false
                    
                }
            } else {
                if postReactionOfNull.contains((self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].id)!) {
                    cell!.btnLike.isSelected = false
                    cell!.btnDislike.isSelected = false
                    cell!.btnLaugh.isSelected = false
                    cell!.btnAngry.isSelected = false
                    
                }
                
            }
            
            
            
            cell!.lblLikeCount.text = "\(likeCount!)"
            cell!.lblDislikeCount.text = "\(disLike!)"
            cell!.lblHappy.text = "\(launghCount!)"
            //            cell!.lblAngry.text = "\(angry!)"
            
            cell!.delegate = self
            cell!.index = indexPath
            if angry != nil {
                cell!.lblAngry.text = "\(angry!)"
            } else {
                cell!.lblAngry.text = "0"
                cell!.btnAngry.isSelected = false
            }
            if vote != nil {
                cell!.lblTotalVoteCast.text = "\(vote!)" + " Vote".localized()
            } else {
                cell!.lblTotalVoteCast.text = "0".localized() + " Vote".localized()
            }
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 2 {
                cell!.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell!.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                
                cell!.progressOfFirstPoll.animateTo(progress: 0.0)
                cell!.progressOfSecondPoll.animateTo(progress: 0.0)
                cell!.progressOfThidPoll.animateTo(progress: 0.0)
                cell!.progressOfFourthPoll.animateTo(progress: 0.0)
                cell!.progressFifth.animateTo(progress: 0.0)
                
                let totalVoteCountOfFirstsss = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                
                let totalVoteCountOfFirstssssss : Float?
                if vote == nil {
                    totalVoteCountOfFirstssssss = 0
                } else {
                    totalVoteCountOfFirstssssss  = Float(totalVoteCountOfFirstsss) / Float(vote!)
                }
                
                cell!.heightOfThirdLabel.constant = 0.0
                cell!.heightofFirstProgress.constant = 0.0
                
                cell!.heightOfFourthLabel.constant = 0.0
                cell!.heightofSecondProgress.constant = 0.0
                
                cell!.heightofFirstProgress.constant = 0.0
                cell!.heightOfFifthLabel.constant = 0.0
                cell!.heightofThirdProgress.constant = 0.0
                
                
                
                
                cell!.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstssssss!))
                
                let totalVoteCountSecondss = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                
                let totalVoteCountSecondsssss : Float?
                if vote == nil {
                    totalVoteCountSecondsssss = 0
                } else {
                    totalVoteCountSecondsssss  = Float(totalVoteCountSecondss) / Float(vote!)
                }
                cell!.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondsssss!))
                
                
                cell!.lblThirdPollQuestion.isHidden = true
                cell!.lblFourthQuestion.isHidden = true
                cell!.lblFifthQuestion.isHidden = true
                
                cell!.progressOfThidPoll.isHidden = true
                cell!.progressOfFourthPoll.isHidden = true
                
                cell!.progressFifth.isHidden = true
                
                
                
            }
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 3 {
                
                cell!.lblThirdPollQuestion.isHidden = false
                cell!.lblFourthQuestion.isHidden = true
                
                cell!.progressOfThidPoll.isHidden = false
                cell!.progressOfFourthPoll.isHidden = true
                
                cell!.lblFifthQuestion.isHidden = true
                cell!.progressFifth.isHidden = true
                cell!.progressOfFirstPoll.animateTo(progress: 0.0)
                cell!.progressOfSecondPoll.animateTo(progress: 0.0)
                cell!.progressOfThidPoll.animateTo(progress: 0.0)
                cell!.progressOfFourthPoll.animateTo(progress: 0.0)
                cell!.progressFifth.animateTo(progress: 0.0)
                
                cell!.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell!.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                cell!.lblThirdPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].name
                
                let totalVoteCountOfFirst = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                let totalVoteCountSecond = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                let totalVoteCount = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].post_votes_count)!
                
                let totalVoteCountOfFirstsss : Float?
                let totalVoteCountSecondssss : Float?
                let totalVoteCountsss : Float?
                
                cell!.heightOfThirdLabel.constant = 14.0
                cell!.heightofFirstProgress.constant = 10.0
                cell!.heightOfFourthLabel.constant = 0.0
                cell!.heightofSecondProgress.constant = 0.0
                cell!.heightofThirdProgress.constant = 0.0
                cell!.heightOfFifthLabel.constant = 0.0
                
                
                if vote == nil {
                    totalVoteCountOfFirstsss = 0
                    totalVoteCountSecondssss = 0
                    totalVoteCountsss = 0
                    
                } else {
                    totalVoteCountOfFirstsss  = Float(totalVoteCountOfFirst) / Float(vote!)
                    totalVoteCountSecondssss  = Float(totalVoteCountSecond) / Float(vote!)
                    totalVoteCountsss  = Float(totalVoteCount) / Float(vote!)
                    
                }
                
                
                cell!.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss!))
                //                let totalVoteCountSecondssss  =
                cell!.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondssss!))
                cell!.progressOfThidPoll.animateTo(progress: CGFloat(totalVoteCountsss!))
                
            }
                
            else  if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 4 {
                
                cell!.lblThirdPollQuestion.isHidden = false
                cell!.lblFourthQuestion.isHidden = false
                
                cell!.progressOfThidPoll.isHidden = false
                cell!.progressOfFourthPoll.isHidden = false
                
                cell!.lblFifthQuestion.isHidden = true
                cell!.progressFifth.isHidden = true
                cell!.progressOfFirstPoll.animateTo(progress: 0.0)
                cell!.progressOfSecondPoll.animateTo(progress: 0.0)
                cell!.progressOfThidPoll.animateTo(progress: 0.0)
                cell!.progressOfFourthPoll.animateTo(progress: 0.0)
                cell!.progressFifth.animateTo(progress: 0.0)
                
                
                cell!.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell!.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                cell!.lblThirdPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].name
                cell!.lblFourthQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![3].name
                
                
                let first = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                let second = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                let third = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].post_votes_count)!
                let fourht = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![3].post_votes_count)!
                
                cell!.heightOfThirdLabel.constant = 14.0
                cell!.heightofFirstProgress.constant = 10.0
                
                
                cell!.heightOfFourthLabel.constant = 14.0
                cell!.heightofSecondProgress.constant = 10.0
                
                cell!.heightofThirdProgress.constant = 0.0
                cell!.heightOfFifthLabel.constant = 0.0
                
                
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
                cell!.progressOfFirstPoll.animateTo(progress: CGFloat(VoteCountOfFirstsss!))
                //                let totalVoteCountSecond = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                cell!.progressOfThidPoll.animateTo(progress: CGFloat(VoteCountThird!))
                
                cell!.progressOfFourthPoll.animateTo(progress: CGFloat(VoteCountFourth!))
                cell!.progressOfSecondPoll.animateTo(progress: CGFloat(VoteCountSecondssss!))
                
            } else  if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 5 {
                
                cell!.lblThirdPollQuestion.isHidden = false
                cell!.lblFourthQuestion.isHidden = false
                
                cell!.progressOfThidPoll.isHidden = false
                cell!.progressOfFourthPoll.isHidden = false
                
                cell!.lblFifthQuestion.isHidden = false
                cell!.progressFifth.isHidden = false
                
                
                cell!.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell!.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                cell!.lblThirdPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].name
                cell!.lblFourthQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![3].name
                cell!.lblFifthQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![4].name
                
                
                let first = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                let second = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                let third = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].post_votes_count)!
                let fourht = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![3].post_votes_count)!
                let fifth = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![4].post_votes_count)!
                
                cell!.heightOfThirdLabel.constant = 14.0
                cell!.heightofFirstProgress.constant = 10.0
                
                
                cell!.heightOfFourthLabel.constant = 14.0
                cell!.heightofSecondProgress.constant = 10.0
                
                
                cell!.heightofThirdProgress.constant = 14.0
                cell!.heightOfFifthLabel.constant = 10.0
                
                
                
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
                cell!.progressOfFirstPoll.animateTo(progress: CGFloat(VoteCountOfFirstsss!))
                cell!.progressOfThidPoll.animateTo(progress: CGFloat(VoteCountThird!))
                cell!.progressOfFourthPoll.animateTo(progress: CGFloat(VoteCountFourth!))
                cell!.progressOfSecondPoll.animateTo(progress: CGFloat(VoteCountSecondssss!))
                cell!.progressFifth.animateTo(progress: CGFloat(VoteCountFifth!))
            }
            
            if userObj?.id == self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_id {
                
                cell!.lblNAme.text = "Me".localized()
                
                if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_as  == 1 {
                    cell!.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                    
                } else {
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.profile_image  else   {
                        return cell!
                    }
                    
                    cell!.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    cell!.imgOfUser.setImage(with: image, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring:image , imageView: (cell!.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                    
                }
                
                
            } else {
                if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_as  == 1 {
                    cell!.lblNAme.text  = "Anonymous".localized()
                    cell!.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                } else {
                    cell!.lblNAme.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.full_name
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.profile_image  else   {
                        return cell!
                    }
                    cell!.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    cell!.imgOfUser.setImage(with: image, placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring:image , imageView: (cell!.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                    
                }
            }
            return cell!
        }
            
        else {
            
            var cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell
            if cell == nil {
                cell = PostCell(style: .default, reuseIdentifier: "PostCell")
            }
            cell!.lblUni.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_group_name
            cell!.lblDate.text = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].created_at)!)
            cell!.lblPost.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
            let totalComment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].total_comments
            let likeCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_like_count
            let disLike = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_dislike_count
            let launghCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_laugh_count
            let angry = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_angry_count
            let userReaction = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_reaction
            cell!.lblLikeCount.text = "\(likeCount!)"
            cell!.lblDislikeCount.text = "\(disLike!)"
            cell!.lblHappy.text = "\(launghCount!)"
            cell!.delegate = self
            cell!.index = indexPath
            if isComeFromPost == "SAVED" {
                cell!.btnReport.isHidden = true
            } else {
                cell!.btnReport.isHidden = false
            }
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].is_edited == true {
                let updatedDate = WAShareHelper.getFormattedDate(string: (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].update_at)!)
                cell?.lblEdited.isHidden = false
                cell?.lblEdited.text = "edited".localized() + " \(updatedDate)"
            } else {
                cell?.lblEdited.isHidden = true
                
            }
            
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].allow_comment == 0 {
                if let image = UIImage(named: "comments") {
                    cell!.btnComment.setImage(image , for: .normal)
                }
                
                if totalComment != nil {
                    cell!.btnComment.setTitle("\(totalComment!)", for: .normal)
                } else {
                    cell!.btnComment.setTitle("0".localized(), for: .normal)
                }
                
                if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 1  {
                    cell!.imgOfAvatarSecond.isHidden = true
                    cell!.imgOfAvatarThird.isHidden = true
                    cell!.imgOfAvatarFourth.isHidden = true
                    cell!.imgOfAvatarFirst.isHidden = false
                    
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge  else   {
                        return cell!
                    }
                    cell!.imgOfAvatarFirst.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloat))
                    
                } else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 2  {
                    cell!.imgOfAvatarFirst.isHidden = false
                    cell!.imgOfAvatarSecond.isHidden = false
                    cell!.imgOfAvatarThird.isHidden = true
                    cell!.imgOfAvatarFourth.isHidden = true
                    
                    let imge = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge
                    cell!.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imge! , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloats: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloats = Float(cgFloats)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloats))
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![1].imge  else   {
                        return cell!
                    }
                    cell!.imgOfAvatarSecond.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarSecond!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarSecond.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarSecond, radius: CGFloat(someFloat))
                    
                } else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 3  {
                    cell!.imgOfAvatarFirst.isHidden = false
                    cell!.imgOfAvatarSecond.isHidden = false
                    cell!.imgOfAvatarThird.isHidden = false
                    cell!.imgOfAvatarFourth.isHidden = true
                    
                    
                    let imge = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge
                    cell!.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imge! , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloats: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloats = Float(cgFloats)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloats))
                    
                    
                    let imgess = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![1].imge
                    cell!.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imgess! , imageView: (cell!.imgOfAvatarSecond!), placeHolder: "profile2")
                    let cgFloatss: CGFloat = cell!.imgOfAvatarSecond.frame.size.width/2.0
                    let someFloatss = Float(cgFloatss)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![2].imge  else   {
                        return cell!
                    }
                    
                    cell!.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarThird!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarThird.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarThird, radius: CGFloat(someFloat))
                    
                }
                else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar?.count == 4  {
                    cell!.imgOfAvatarFirst.isHidden = false
                    cell!.imgOfAvatarSecond.isHidden = false
                    cell!.imgOfAvatarThird.isHidden = false
                    cell!.imgOfAvatarFourth.isHidden = false
                    
                    let imge = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![0].imge
                    cell!.imgOfAvatarFirst.setImage(with: imge , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imge! , imageView: (cell!.imgOfAvatarFirst!), placeHolder: "profile2")
                    let cgFloats: CGFloat = cell!.imgOfAvatarFirst.frame.size.width/2.0
                    let someFloats = Float(cgFloats)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFirst, radius: CGFloat(someFloats))
                    let imgess = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![1].imge
                    cell!.imgOfAvatarSecond.setImage(with: imgess , placeholder: UIImage(named: "profile2"))
                    
                    let cgFloatss: CGFloat = cell!.imgOfAvatarSecond.frame.size.width/2.0
                    let someFloatss = Float(cgFloatss)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarSecond, radius: CGFloat(someFloatss))
                    
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![2].imge  else   {
                        return cell!
                    }
                    cell!.imgOfAvatarThird.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: image , imageView: (cell!.imgOfAvatarThird!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfAvatarThird.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarThird, radius: CGFloat(someFloat))
                    
                    
                    guard  let imagessss = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].commentAvatar![3].imge  else   {
                        return cell!
                    }
                    
                    cell!.imgOfAvatarFourth.setImage(with: imagessss , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring: imagessss , imageView: (cell!.imgOfAvatarFourth!), placeHolder: "profile2")
                    let cg : CGFloat = cell!.imgOfAvatarFourth.frame.size.width/2.0
                    let someFlo = Float(cg)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfAvatarFourth, radius: CGFloat(someFlo))
                } else {
                    cell!.imgOfAvatarSecond.isHidden = true
                    cell!.imgOfAvatarThird.isHidden = true
                    cell!.imgOfAvatarFourth.isHidden = true
                    cell!.imgOfAvatarFirst.isHidden = true
                }
            } else {
                if let image = UIImage(named: "disable_comments") {
                    cell!.btnComment.setImage(image , for: .normal)
                    
                }
                
                cell!.imgOfAvatarSecond.isHidden = true
                cell!.imgOfAvatarThird.isHidden = true
                cell!.imgOfAvatarFourth.isHidden = true
                cell!.imgOfAvatarFirst.isHidden = true
                
                cell!.btnComment.setTitle("", for: .normal)
            }
            if isPostFav.contains((self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].id)!) {
                cell!.btnFav.isSelected = true
            } else {
                cell!.btnFav.isSelected = false
            }
            if postReactionId.contains((self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].id)!) {
                if userReaction != nil {
                    if postReaction.contains((userReaction)!) {
                        if userReaction == 0 {
                            cell!.btnLike.isSelected = true
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = false
                        } else if userReaction == 1 {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = true
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = false
                            
                            
                        } else if userReaction == 2 {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = true
                            cell!.btnAngry.isSelected = false
                        } else if userReaction == 5 {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = true
                        } else {
                            cell!.btnLike.isSelected = false
                            cell!.btnDislike.isSelected = false
                            cell!.btnLaugh.isSelected = false
                            cell!.btnAngry.isSelected = false
                        }
                    }
                } else {
                    cell!.btnLike.isSelected = false
                    cell!.btnDislike.isSelected = false
                    cell!.btnLaugh.isSelected = false
                    cell!.btnAngry.isSelected = false
                    
                }
            } else {
                if postReactionOfNull.contains((self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].id)!) {
                    cell!.btnLike.isSelected = false
                    cell!.btnDislike.isSelected = false
                    cell!.btnLaugh.isSelected = false
                    cell!.btnAngry.isSelected = false
                    
                }
            }
            
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].is_favorite ==  true {
                cell!.btnFav.isSelected = true
            } else {
                cell!.btnFav.isSelected = false
            }
            if angry != nil {
                cell!.lblAngry.text = "\(angry!)"
            } else {
                cell!.lblAngry.text = "0"
                cell!.btnAngry.isSelected = false
            }
            
            if userObj?.id == self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_id {
                cell!.lblNAme.text = "Me".localized()
                //                cell!.lblNAme.text  = "Annonymous"
                if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_as  == 1 {
                    cell!.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                    
                } else {
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.profile_image  else   {
                        return cell!
                    }
                    cell!.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring:image , imageView: (cell!.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                    
                }
                
            } else {
                if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user_as  == 1 {
                    cell!.lblNAme.text  = "Anonymous".localized()
                    cell!.imgOfUser.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                } else {
                    cell!.lblNAme.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.full_name
                    guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.profile_image  else   {
                        return cell!
                    }
                    cell!.imgOfUser.setImage(with: image , placeholder: UIImage(named: "profile2"))
                    
                    //                    WAShareHelper.loadImage(urlstring:image , imageView: (cell!.imgOfUser!), placeHolder: "profile2")
                    let cgFloat: CGFloat = cell!.imgOfUser.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(cell!.imgOfUser, radius: CGFloat(someFloat))
                    
                }
            }
            return cell!
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count != 0 {
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 5 {
                //             let comment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
                //              let size =   UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)
                return 367
            } else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 4 {
                //                let comment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
                //                let size =   UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)
                
                return 330
            }
            else if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 3 {
                //                let comment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
                //                let size =         UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)
                return 300
            } else {
                //                let comment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
                //                let size    = UtilityHelper.requiredHeightForLabelWith(308.0 , text: comment!)
                
                return 270
                
            }
        } else {
            let comment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
            let size = UtilityHelper.requiredHeightForLabelWith(SCREEN_WIDTH  - 20  , text: comment!)
            if size < 80.0  {
                return 120.0 + 80.0
            } else {
                return 120.0 + 80.0
            }
            
            //            return UITableView.automaticDimension
        }
        //        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == (self.userFeeds?.feeds?.post?.feedsObject?.count)!-2 { //you might decide to load sooner than -1 I guess...
            if isSearch == false  {
                if isPageRefreshing == false {
                    isPageRefreshing = true
                    if page <= numberOfPage! {
                        self.makeRequest(pageSize: self.page)
                        self.tblViewss.tableFooterView = self.activity
                        self.activity.startAnimating()
                        self.tblViewss.tableFooterView?.isHidden = false
                        
                    } else {
                        
                    }
                    
                }  else {
                }
                
            }
        }
        
    }
    
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    //    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    //        if scrollView == tblViewss {
    //            if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
    //
    //                if isPageRefreshing == false {
    //                    isPageRefreshing = true
    //                    if page <= numberOfPage! {
    //                        self.makeRequests(pageSize: self.page)
    //                        self.tblViewss.tableFooterView = self.activity
    //                        self.activity.startAnimating()
    //                        self.tblViewss.tableFooterView?.isHidden = false
    //                    } else {
    //
    //                    }
    //
    //                }  else {
    //                }
    //            } else {
    //            }
    //
    //        }
    //
    //    }
    
    
    //    func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
    //        if scrollView == tblViewss {
    //            if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
    //
    //                if isPageRefreshing == false {
    //                    isPageRefreshing = true
    //                    if page <= numberOfPage! {
    //                        self.makeRequests(pageSize: self.page)
    //                        self.tblViewss.tableFooterView = self.activity
    //                        self.activity.startAnimating()
    //                        self.tblViewss.tableFooterView?.isHidden = false
    //                    } else {
    //
    //                    }
    //
    //                 }  else {
    //                }
    //            } else {
    //            }
    //
    //        }
    //
    //    }
    //    }
}


extension UBFeedsVC : UserPostDeledate {
    func selectUser(cell: PostCell, index: IndexPath) {
        
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        if feedObj?.user_as == 1 || feedObj?.user_id == self.userObj?.id {
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
            if #available(iOS 10.0 , *)  {
                vc?.modalPresentationStyle = .overCurrentContext
            } else {
                vc?.modalPresentationStyle = .currentContext
            }
            vc?.delegate = self
            vc?.indexSelect  = index
            
            vc?.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
            vc?.providesPresentationContextTransitionStyle = true
            present(vc!, animated: true) {
                
            }
            
        }
    }
    
    func selectCommet(cell: PostCell, index: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC
        if self.userFeeds?.feeds?.post?.feedsObject![index.row].postOption?.count != 0 {
            vc?.isUserPooling = true
            vc?.indexSelect = index.row
            vc?.delegate = self
        } else {
            vc?.isUserPooling = false
            vc?.indexSelect = index.row
            vc?.delegate = self
        }
        vc!.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        vc!.userObj = self.userObj
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func selectedArea(cell: PostCell, index: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC
        if self.userFeeds?.feeds?.post?.feedsObject![index.row].postOption?.count != 0 {
            vc?.isUserPooling = true
            vc?.indexSelect = index.row
            vc?.delegate = self
        } else {
            vc?.isUserPooling = false
            vc?.indexSelect = index.row
            vc?.delegate = self
        }
        vc!.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        vc!.userObj = self.userObj
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func isAddToFav(cell: PostCell, index: IndexPath) {
        var post : FeedsObject?
        
        let  feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        
        if isComeFromPost == "SAVED" {
            DispatchQueue.global().async {
                self.postFav(fedObj: feedObj! , index: index)
                DispatchQueue.main.sync { [weak self] in
                    if let index  = self!.isPostFav.index(where: {$0 == feedObj?.id}) {
                        self!.userFeeds?.feeds?.post?.feedsObject?.remove(at: index)
                        self!.isPostFav.remove(at: index)
                        
                    }
                    self?.tblViewss.reloadData()
                }
            }
        } else {
            
            if cell.btnFav.isSelected == true {
                DispatchQueue.global().async {
                    
                    self.postFav(fedObj: feedObj! , index: index)
                    DispatchQueue.main.sync {
                        self.isPostFav.append((feedObj?.id!)!)
                        
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].is_favorite  = true
                        
                        
                    }
                    
                }
            } else {
                DispatchQueue.global().async {
                    self.postFav(fedObj: feedObj! , index: index)
                    DispatchQueue.main.sync {
                        if let index  = self.isPostFav.index(where: {$0 == feedObj?.id}) {
                            self.isPostFav.remove(at: index)
                        }
                        self.userFeeds?.feeds?.post?.feedsObject![index.row].is_favorite  = false
                        
                    }
                }
            }
        }
    }
    
    func isReportOrShare(cell: PostCell, indexxx: IndexPath) {
        //        var dropdownOptions: [DropdownView.Option]
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![indexxx.row]
        print(indexxx.row)
        if userPostOrPoll.contains((self.userFeeds?.feeds?.post?.feedsObject![indexxx.row].id)!) {
            ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Edit".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                if index == 0 {
                    self!.postDestroy(post: feedObj!, index: indexxx)
                } else if index == 1 {
                    self!.editPost(post: feedObj!, index: indexxx.row)
                }
                return
                }, cancel: { (actionStrin ) in
                    
            }, origin: cell.btnReport)
        } else {
            if postReported.contains((feedObj?.id)!)  {
                
                ActionSheetStringPicker.show(withTitle: "", rows: ["Already Reported".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
                
                //                dropdownOptions = [
                //                    DropdownView.Option(title: "Already Reported",      action: { })
                //                ]
            }
            else {
                
                ActionSheetStringPicker.show(withTitle: "", rows: ["Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    if index == 0 {
                        self!.reportPost(post: feedObj! , index: indexxx )
                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
                
                //                dropdownOptions = [
                //                    DropdownView.Option(title: "Report",      action: { })
                //                ]
            }
            
            self.isSelectIndex = indexxx.row
            //            var dropdown1: DropdownView = {
            //                let dropdown = DropdownView(options: dropdownOptions, target: self)
            //                return dropdown
            //            }()
            //            dropdown1.attachTo(cell.btnReport, openDirection: .leftDown)
            
        }
        //        if userObj?.id == self.userFeeds?.feeds?.post?.feedsObject![indexxx.row].user_id {
        //
        //        }
        //        else {
        //
        //
        //        }
        
    }
    
    func isClickOnComment(cell: PostCell, index: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC
        if self.userFeeds?.feeds?.post?.feedsObject![index.row].postOption?.count != 0 {
            vc?.isUserPooling = true
            vc?.indexSelect = index.row
            vc?.delegate = self
        } else {
            vc?.isUserPooling = false
            vc?.indexSelect = index.row
            vc?.delegate = self
        }
        vc!.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        vc!.userObj = self.userObj
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func isUserLike(cell: PostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "0", index: index.row, isReactOnPost: cell)
        }
        if cell.btnLike.isSelected  == true {
            self.setReaction(post: feedObj!, isClickReaction: "0", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        } else {
            self.setReaction(post: feedObj!, isClickReaction: "0", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index )
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
    func isUserDislike(cell: PostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "1", index: index.row , isReactOnPost: cell)
        }
        
        if cell.btnDislike.isSelected  == true {
            self.setReaction(post: feedObj!, isClickReaction: "1", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
            
        } else {
            self.setReaction(post: feedObj!, isClickReaction: "1", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
    
    func isUserHappyClick(cell: PostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "2", index: index.row , isReactOnPost: cell )
        }
        
        if cell.btnLaugh.isSelected  == true {
            self.setReaction(post: feedObj!, isClickReaction: "2", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            //            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
            
        } else {
            self.setReaction(post: feedObj!, isClickReaction: "2", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
    
    func isUserAngry(cell: PostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPost(post: feedObj! , rection: "5", index: index.row , isReactOnPost: cell )
            //            DispatchQueue.main.sync {
            //
        }
        
        if cell.btnAngry.isSelected  == true {
            self.setReaction(post: feedObj!, isClickReaction: "5", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        } else {
            self.setReaction(post: feedObj!, isClickReaction: "5", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
}


extension UBFeedsVC : UserPollingDeledate {
    func selectUserOnPoll(cell: PollingPostCell, index: IndexPath) {
        
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        if feedObj?.user_as == 1 || feedObj?.user_id == self.userObj?.id {
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddSendFreiendRequetPop") as? UBAddSendFreiendRequetPop
            if #available(iOS 10.0 , *)  {
                vc?.modalPresentationStyle = .overCurrentContext
            } else {
                vc?.modalPresentationStyle = .currentContext
            }
            vc?.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
            vc?.providesPresentationContextTransitionStyle = true
            present(vc!, animated: true) {
                
            }
            
        }
        
    }
    
    func selectedPollArea(cell: PollingPostCell, index: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC
        if self.userFeeds?.feeds?.post?.feedsObject![index.row].postOption?.count != 0 {
            vc?.isUserPooling = true
            vc?.indexSelect = index.row
            vc?.delegate = self
        } else {
            vc?.isUserPooling = false
            vc?.indexSelect = index.row
            vc?.delegate = self
        }
        vc!.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        vc!.userObj = self.userObj
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func isAddToFavss(cell: PollingPostCell, index: IndexPath) {
        //        var post : FeedsObject?
        let  feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        if isComeFromPost == "SAVED" {
            DispatchQueue.global().async {
                self.postFav(fedObj: feedObj! , index: index)
                
                DispatchQueue.main.sync { [weak self] in
                    if let index  = self!.isPostFav.index(where: {$0 == feedObj?.id}) {
                        self!.isPostFav.remove(at: index)
                        self!.userFeeds?.feeds?.post?.feedsObject?.remove(at: index)
                    }
                    //                    self!.userFeeds?.feeds?.post?.feedsObject![index.row].is_favorite  = false
                    self!.tblViewss.reloadData()
                }
            }
        } else {
            
            
            
            
            if cell.btnFav.isSelected == true {
                self.isPostFav.append((feedObj?.id!)!)
                
                DispatchQueue.global().async { [weak self] in
                    self!.postFav(fedObj: feedObj! , index: index)
                    DispatchQueue.main.sync {
                        
                        self!.userFeeds?.feeds?.post?.feedsObject![index.row].is_favorite  = true
                    }
                    
                }
            } else {
                DispatchQueue.global().async {
                    self.postFav(fedObj: feedObj! , index: index)
                    
                    DispatchQueue.main.sync { [weak self] in
                        if let index  = self!.isPostFav.index(where: {$0 == feedObj?.id}) {
                            self!.isPostFav.remove(at: index)
                        }
                        self!.userFeeds?.feeds?.post?.feedsObject![index.row].is_favorite  = false
                        
                    }
                }
            }
            
        }
    }
    
    func isReportOrSharess(cell: PollingPostCell, indexs : IndexPath) {
        
        var dropdownOptions: [DropdownView.Option]
        var feedObj = self.userFeeds?.feeds?.post?.feedsObject![indexs.row]
        
        if userPostOrPoll.contains((feedObj!.id)!) {
            if  self.userFeeds?.feeds?.post?.feedsObject![indexs.row].total_poll_votes != nil {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    if index == 0 {
                        self!.postDestroy(post: feedObj!, index: indexs)
                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
                
                
                //                dropdownOptions = [
                //                    DropdownView.Option(title: "Delete",      action: {}) ,
                //                ]
            } else {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized()  , "Edit".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    if index == 0 {
                        self!.postDestroy(post: feedObj!, index: indexs)
                    } else if index == 1 {
                        self!.editPost(post: feedObj!, index: indexs.row)
                    }
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
                
                //                dropdownOptions = [
                //                    DropdownView.Option(title: "Delete",      action: { }) ,
                //                    DropdownView.Option(title: "Edit"  ,    action: {  })
                //                ]
            }
            
            //            let dropdown1: DropdownView = {
            //                let dropdown = DropdownView(options: dropdownOptions, target: self)
            //                return dropdown
            //            }()
            //            dropdown1.attachTo(cell.btnReport, openDirection: .leftDown)
            
        } else {
            
            
            if postReported.contains(((feedObj?.id)!)!)  {
                ActionSheetStringPicker.show(withTitle: "", rows: ["Already Reported".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
                
                //                dropdownOptions = [
                //                    DropdownView.Option(title: "Already Reported", action: { })
                //                ]
            } else {
                
                ActionSheetStringPicker.show(withTitle: "", rows: ["Report".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                    self!.reportPost(post: feedObj!, index: indexs)
                    
                    return
                    }, cancel: { (actionStrin ) in
                        
                }, origin: cell.btnReport)
                
                //                dropdownOptions = [
                //                    DropdownView.Option(title: "Report",      action: { })
                //                ]
            }
            //            let dropdown1: DropdownView = {
            //                let dropdown = DropdownView(options: dropdownOptions, target: self)
            //                return dropdown
            //            }()
            //            dropdown1.attachTo(cell.btnReport, openDirection: .leftDown)
            //
        }
        
        //        if userObj?.id == self.userFeeds?.feeds?.post?.feedsObject![indexs.row].user_id {
        //
        //
        //        } else {
        //
        //
        //        }
    }
    
    func isClickOnCommentss(cell: PollingPostCell, index: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC
        if self.userFeeds?.feeds?.post?.feedsObject![index.row].postOption?.count != 0 {
            vc?.isUserPooling = true
            vc?.indexSelect = index.row
            vc?.delegate = self
        } else {
            vc?.isUserPooling = false
            vc?.indexSelect = index.row
            vc?.delegate = self
        }
        vc!.feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        vc!.userObj = self.userObj
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func isUserLikess(cell: PollingPostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPoll(post: feedObj!, rection: "0", index: index.row, isReactOnPost: cell)
        }
        
        if cell.btnLike.isSelected  == true {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "0", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        } else {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "0", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
    
    func isUserDislikess(cell: PollingPostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPoll(post: feedObj!, rection: "1", index: index.row, isReactOnPost: cell)
        }
        
        if cell.btnDislike.isSelected  == true {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "1", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
        } else {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "1", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
    
    func isUserHappyClickss(cell: PollingPostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPoll(post: feedObj!, rection: "2", index: index.row, isReactOnPost: cell)
        }
        
        if cell.btnLaugh.isSelected  == true {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "2", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        } else {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "2", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
    
    func isUserAngryss(cell: PollingPostCell, index: IndexPath) {
        let feedObj = self.userFeeds?.feeds?.post?.feedsObject![index.row]
        
        DispatchQueue.global().async { [weak self] in
            self!.rectOnPoll(post: feedObj!, rection: "5", index: index.row, isReactOnPost: cell)
        }
        
        if cell.btnAngry.isSelected  == true {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "5", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: true , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
        } else {
            self.setReactionOnPoll(post: feedObj! , isClickReaction: "5", alreadeReaction: feedObj?.user_reaction , cell: cell , isSelected: false , index: index)
            cell.btnLike.isUserInteractionEnabled = false
            cell.btnDislike.isUserInteractionEnabled = false
            cell.btnLaugh.isUserInteractionEnabled = false
            cell.btnAngry.isUserInteractionEnabled = false
            
        }
    }
}

// #Search Bar Delegate


extension UBFeedsVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getSearchResult(search: searchBar.text!)
        isSearch = true
    }
}


extension UBFeedsVC : CreatePostDelegate {
    
    func createPost(obj : FeedsObject) {
        if obj.user_reaction != nil {
            self.postReactionId.append(obj.id!)
            self.postReaction.append(obj.user_reaction!)
        }
        if obj.user_reaction == nil {
            self.postReactionOfNull.append(obj.id!)
        }
        
        if obj.user_id == self.userObj?.id {
            self.userPostOrPoll.append(obj.id!)
        }
        self.userFeeds?.feeds?.post?.feedsObject?.insert(obj, at: 0)
        tblViewss.reloadData()
    }
}


extension UBFeedsVC : FriendRequestDelegate {
    func isRequestSendOrAccept(updateFeed : FeedsObject  , index : IndexPath) {
        self.userFeeds?.feeds?.post?.feedsObject![index.row] = updateFeed
        self.tblViewss.reloadData()
    }
}


extension UBFeedsVC : UpdateVoteDelegate {
    
    func update(obj: FeedsObject, checkIndex: Int) {
        self.userFeeds?.feeds?.post?.feedsObject![checkIndex] = obj
        //        let indexPath = IndexPath(item: checkIndex, section: 0)
        //        self.tblViewss.reloadRows(at: [indexPath], with: .none)
        self.tblViewss.reloadData()
    }
    
    
    func deleteObj(obj: FeedsObject, checkIndex: Int) {
        let postId = obj.id
        if let index  =   self.userFeeds?.feeds?.post?.feedsObject?.index(where: {$0.id == postId}) {
            self.userFeeds?.feeds?.post?.feedsObject?.remove(at: index)
            self.tblViewss.reloadData()
        }
        
        
    }
    
    func updateFav(obj: FeedsObject, checkIndex: Int) {
        //        self.feedList?.posts?.feedsObject![checkIndex] = obj
        //        self.isPostFav.append(obj.id!)
        //        let indexPath = IndexPath(item: checkIndex, section: 0)
        //        self.tblViewss.reloadRows(at: [indexPath], with: .none)
        
    }
    
    func reportOrHidePost(obj: FeedsObject, checkIndex: Int) {
        let postId = obj.id
        //        if let index  = self.userFeeds?.feeds?.post?.feedsObject?.index(where: {$0.id == postId}) {
        //
        //            self.feedList?.posts?.feedsObject?.remove(at: index)
        //            self.tblViewss.reloadData()
        //        }
    }
    
    func updateReact(obj: FeedsObject, checkIndex: Int) {
        self.userFeeds?.feeds?.post?.feedsObject![checkIndex] = obj
        if obj.user_reaction != nil {
            self.postReaction.append(obj.user_reaction!)
            self.postReactionId.append(obj.id!)
        }
        if obj.is_reported == true {
            self.postReported.append(obj.id!)
        }
        
        let indexPath = IndexPath(item: checkIndex, section: 0)
        self.tblViewss.reloadRows(at: [indexPath], with: .none)
        
    }
    
    
    //    func update(obj : FeedsObject , checkIndex : Int) {
    //
    ////        self.tblViewss.reloadData()
    //    }
    
    
}

extension UBFeedsVC : EditPostDelegate {
    func editPost(obj: FeedsObject, index: Int) {
        self.userFeeds?.feeds?.post?.feedsObject![index] = obj
        let indexPath = IndexPath(item: index, section: 0)
        self.tblViewss.reloadRows(at: [indexPath], with: .none)
        
    }
    
    
}


extension UBFeedsVC : EditPollDelegate {
    func editPoll(obj: FeedsObject, index: Int) {
        self.userFeeds?.feeds?.post?.feedsObject![index] = obj
        let indexPath = IndexPath(item: index, section: 0)
        self.tblViewss.reloadRows(at: [indexPath], with: .none)
    }
}

extension Array {
    func unique<T:Hashable>(map: ((Element) -> (T)))  -> [Element] {
        var set = Set<T>() //the unique list kept in a Set for fast retrieval
        var arrayOrdered = [Element]() //keeping the unique list of elements but ordered
        for value in self {
            if !set.contains(map(value)) {
                set.insert(map(value))
                arrayOrdered.append(value)
            }
        }
        return arrayOrdered
    }
}




