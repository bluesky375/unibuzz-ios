//
//  UBGroupFileMemberCalenderVc.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SJSegmentedScrollView
import HSPopupMenu
import LanguageManager_iOS
import SVProgressHUD
class UBGroupFileMemberCalenderVc : UIViewController {
    var previousVC: UIViewController?
    var showingIndex: Int = 0
    var pageVC: UIPageViewController?
    @IBOutlet var viewOfTop: UIView!
    var pageControl = UIPageControl()
    var groupObj : GroupList?
    @IBOutlet weak var imgOfGroup: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var headerTitle: UILabel!
    @IBOutlet weak var lblGroupDescription: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var postCountLabel: UILabel!
    
    @IBOutlet weak var scrollView: RSBScrollView!
    //------ Constraint Outlets ------
    @IBOutlet weak var topViewCenterConstraints: NSLayoutConstraint!
    
    var type: GroupOptionType = .MyGroup
    var isPost : Bool?
    var isFile : Bool?
    var isMember  : Bool?
    
    fileprivate let segmentedViewController = SJSegmentedViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUPUI(groupObj: groupObj)
        addTopViewScrollAction()
        self.setupSegmentController()
    }
    
    func setUPUI(groupObj: GroupList?) {
        lblGroupName.text = groupObj?.name
        headerTitle.text = groupObj?.name
        headerTitle.alpha = 1.0
        lblGroupDescription.text = groupObj?.university_name
        lblDate.text = groupObj?.description
        if let memberCount = groupObj?.members_count {
            lblMember.text = "\(memberCount)"
        }
        if let memberCount = groupObj?.posts_count {
            postCountLabel.text = "\(memberCount)"
        }
        guard  let logoOfUni = groupObj?.group_thumb  else   {
            return
        }
        WAShareHelper.loadImage(urlstring:logoOfUni , imageView: (imgOfGroup!), placeHolder: "profile2")
        let cgFloats: CGFloat = imgOfGroup.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfGroup, radius: CGFloat(someFloats))
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
        
    }
    
    fileprivate func addTopViewScrollAction(){
        scrollView.observeOffset(forView: viewOfTop) {[weak self] (offset) in
            DispatchQueue.main.async {
                //print("offset.y \(offset.y)")
                self?.topViewCenterConstraints.constant = offset.y+(offset.y*0.2)
                let viewOfTopHeight = self?.viewOfTop.frame.height ?? 155
                let topViewAlpha = (viewOfTopHeight - offset.y) / viewOfTopHeight
                self?.viewOfTop.alpha = topViewAlpha
                
                //------ update top view alpha ------
                if topViewAlpha < 0.2 {
                    if self?.headerTitle.alpha == 1.0{return}
                    UIView.animate(withDuration: 0.2) {
                        self?.headerTitle.alpha = 1.0
                    }
                }else{
                    if self?.headerTitle.alpha == 0.0{return}
                    UIView.animate(withDuration: 0.2) {
                        self?.headerTitle.alpha = 0.0
                    }
                }
            }
        }
    }
    
    @IBAction func moreButtonAction(_ sender: UIButton) {
        var title = "Edit".localized()
        switch type {
        case .leaveGroup :
            title = "Leave Group".localized()
        case .JoinGroup:
            title = "Join Group".localized()
        case .CancelRequest:
            title = "Cancel Request".localized()
        default:
            title = "Edit".localized()
        }
        
        let menu1 = HSMenu(icon: nil, title: title)
        let popupMenu = HSPopupMenu(menuArray: [menu1], arrowPoint: CGPoint(x: sender.center.x , y: sender.center.y + 30), arrowPosition: (LanguageManager.shared.currentLanguage == .ar ? HSPopupMenuArrowPosition.left : HSPopupMenuArrowPosition.right))
        popupMenu.delegate = self
        popupMenu.popUp()
    }
    
    fileprivate func setupSegmentController(){
        let posts = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedsVC" ) as! UBFeedsVC
        posts.groupObj       =  self.groupObj
        posts.isComeFromPost =  "GROUP"
        posts.title = "Posts".localized()
        
        let files = self.storyboard?.instantiateViewController(withIdentifier: "UBFileVC" ) as! UBFileVC
        files.title = "Files".localized()
        files.groupObj  = self.groupObj
        
        let members = self.storyboard?.instantiateViewController(withIdentifier: "UBMemberVC" ) as! UBMemberVC
        members.title = "Members".localized()
        members.groupObj = self.groupObj
        
        let calendar = self.storyboard?.instantiateViewController(withIdentifier: "UBCalenderVC" ) as! UBCalenderVC
        calendar.title = "Calendar".localized()
        calendar.groupObj = self.groupObj
        
        segmentedViewController.segmentedScrollViewColor = UIColor.init(red: 71, green: 92, blue: 179)
        segmentedViewController.segmentBounces = false
        segmentedViewController.selectedSegmentViewHeight = 3
        segmentedViewController.segmentControllers = [posts, members,files, calendar]
        segmentedViewController.segmentTitleColor = .white
        segmentedViewController.segmentSelectedTitleColor = .white
        segmentedViewController.selectedSegmentViewColor = .white
        segmentedViewController.delegate = self
        // segmentedViewController.segmentTitleFont = AppFonts.segmentTitleFont
        segmentedViewController.view.backgroundColor = .clear
        self.addChild(segmentedViewController)
        self.containerView.addSubview(segmentedViewController.view)
        segmentedViewController.view.frame = containerView.bounds
        segmentedViewController.didMove(toParent: self)
        segmentedViewController.segmentBackgroundColor = .clear
    }
    
}


extension UBGroupFileMemberCalenderVc: SJSegmentedViewControllerDelegate{
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
    }
}





class RSBScrollView: UIScrollView {
    
    typealias ChangeOffsetAction = (CGPoint)->()
    // This is a reference to the scroll view's content view
    
    fileprivate var changeOffsetObserversDict = [UIView:ChangeOffsetAction]()
    
    override var contentOffset: CGPoint {
        didSet {
            callObservers()
        }
    }
    
    
    func observeOffset(forView: UIView,changeOffsetAction:@escaping ChangeOffsetAction){
        weak var view = forView
        changeOffsetObserversDict[view!] = changeOffsetAction
    }
    
    fileprivate func callObservers(){
        for (_ , observerAction) in changeOffsetObserversDict{
            observerAction(contentOffset)
        }
    }
    
}


extension UBGroupFileMemberCalenderVc: HSPopupMenuDelegate {
    func popupMenu(_ popupMenu: HSPopupMenu, didSelectAt index: Int) {
        
        switch type {
        case .leaveGroup :
            leaveGroup(apiUrl: LEAVEGROUPOGGROUP)
        case .JoinGroup:
            self.joinOrCanelRequest()
        case .CancelRequest:
            self.joinOrCanelRequest()
        default:
            SVProgressHUD.show()
            WebServiceManager.get(params: nil, serviceName: COURSES, serviceType: "User Feed".localized(), modelType: GroupTypeModel.self, success: { [weak self] (response) in
                guard let self = self else {
                    return
                }
                SVProgressHUD.dismiss()
                if let response = response as? GroupTypeModel {
                    if response.status == true {
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupCreateVC") as? UBGroupCreateVC
                        vc?.delegate = self
                        vc?.data = response.data
                        vc?.isUpdate = true
                        vc?.groupObj = self.groupObj
                        self.navigationController?.pushViewController(vc!, animated: true)
                    } else {
                        self.showAlert(title: KMessageTitle, message: response.message ?? "", controller: self)
                    }
                }
            }) { (error) in
                
            }
        }
    }
    
    func joinOrCanelRequest() {
        if self.groupObj?.is_requested == true {
            SVProgressHUD.show()
            let param =    [ : ] as [String : Any]
            let serviceURl = "\(CANCELGROUPREQUEST)\(self.groupObj?.id ?? 0)"
            WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { [weak self](responseData) in
                guard let self = self else {return}
               DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if  let post = responseData as? UserResponse {
                        if post.status == true {
                            self.groupObj?.is_requested = false
                            self.type = .JoinGroup
                        } else {
                            self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                        }
                    }
                }
                }, fail: { (error) in
            }, showHUD: true)
        } else {
            cancelOrJoinRequest(apiUrl: JOINGROUPREQUEST)
        }
    }
    
    func leaveGroup(apiUrl : String) {
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to Leave this group".localized()) {
            let param =    [ : ] as [String : Any]
            let serviceURl = "\(apiUrl)\(self.groupObj?.id ?? 0)"
            SVProgressHUD.show()
            WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post", modelType: UserResponse.self, success: { [weak self](responseData) in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                    if  let post = responseData as? UserResponse {
                        if post.status == true {
                            self.groupObj?.is_member = false
                            self.type = .JoinGroup
                        } else {
                            self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                        }
                    }
                }
                
                }, fail: { (error) in
            }, showHUD: true)
            
        }
    }
    
    func cancelOrJoinRequest(apiUrl : String) {
        SVProgressHUD.show()
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(apiUrl)\(self.groupObj?.id ?? 0)"
        WebServiceManager.put(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { [weak self] (responseData) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
                if  let post = responseData as? UserResponse {
                    if post.status == true {
                        self.groupObj?.is_requested = true
                        self.type = .CancelRequest
                    } else {
                        self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    }
                }
            }
            }, fail: { (error) in
                //            self.showAlert(title: "OPENSPOT", message: error.description , controller: self)
        }, showHUD: true)
    }
    
    
    
}

extension UBGroupFileMemberCalenderVc : GroupObjectDelegate  {
    func createGroup(obj : GroupList) {
        self.setUPUI(groupObj: groupObj)
    }
}
