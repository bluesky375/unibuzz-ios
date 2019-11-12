//
//  UBGroupListVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class UBGroupListVC: UIViewController {
    @IBOutlet weak var tblViewss    : UITableView!
    var listOfChat : UserResponse?
    var userObj : Session?
    var isRequested = [Int]()
    var joined: String = "1"
    //    var isPrivate = [Int]()
    var isMember = [Int]()
    var isMyGroup = [Int]()
    var isRequestedForMember = [Int]()
    var isInvited = [Int]()
    var isLeave = [Int]()
    private let refreshControl = UIRefreshControl()
    var isPrivateGroup = [Int]()
    
    @IBOutlet var searchBar: UISearchBar!
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!
    var isSearch  : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSearch = false
        searchBar.showsCancelButton = false
        self.tblViewss.delegate = self
        self.tblViewss.dataSource = self
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        tblViewss.registerCells([
            UniGroupCell.self
        ])
        tblViewss.rowHeight = 0.0
        tblViewss.estimatedRowHeight = 0.0
        
        getGroupList()
        
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tblViewss.reloadData()
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        // Fetch Weather Data
        //        getAllGroupList(page: 1)
        if Connectivity.isConnectedToInternet()  {
            getGroupList()
        } else {
            
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getGroupList() {
        var url = ""
        if joined == "1" {
            url = "\(GROUPLIST)joined?page=1"
        } else {
            url = "\(GROUPLIST)other"
        }
        WebServiceManager.get(params: nil, serviceName: url, serviceType: "Group List".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
            self!.listOfChat = (response as! UserResponse)
            if self!.listOfChat?.status == true {
               self!.numberOfPage = self!.listOfChat?.groupObject?.last_page
                self!.page = 1
                self!.isPageRefreshing = false
                self!.refreshControl.endRefreshing()
                self!.tblViewss.reloadData()
                self!.tblViewss.contentOffset = CGPoint(x: 0, y: 0)
                self!.page = self!.page + 1
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfChat?.message!)!, controller: self)
            }
        }) { (error) in
        }
        
    }
    
    func makeRequest(pageSize : Int)  {
        var serviceURL : String = ""
        if joined == "1" {
            serviceURL = "\(GROUPLIST)joined?page=\(page)"
        } else {
            serviceURL = "\(GROUPLIST)other?page=\(page)"
        }
        WebServiceManager.get(params: nil, serviceName: serviceURL , serviceType: "", modelType: UserResponse.self , success: { [weak self] (response) in
            guard let self = self else {return}
            let responeOfPagination = (response as? UserResponse)!
            self.numberOfPage = responeOfPagination.groupObject?.last_page
            if responeOfPagination.status == true {
                self.isPageRefreshing = false
                if let listOfGroup = responeOfPagination.groupObject?.listOfGroup {
                     self.listOfChat?.groupObject?.listOfGroup?.append(contentsOf: listOfGroup)
                }
                self.refreshControl.endRefreshing()
                self.tblViewss.tableFooterView?.isHidden = true
                self.activity.stopAnimating()
                self.page = self.page + 1
                DispatchQueue.main.async {
                    self.tblViewss.reloadData()
                }
            }
         }) { (error) in
        }
    }
    
    func cancelOrJoinRequest(apiUrl : String , groupId : Int , indexCheck : IndexPath) {
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(apiUrl)\(groupId)"
        WebServiceManager.put(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.isRequested.append(groupId)
                    if let index  = self.isRequestedForMember.firstIndex(where: {$0 == groupId}) {
                        self.isRequestedForMember.remove(at: index)
                    }
                    
                    self.listOfChat?.groupObject?.listOfGroup![indexCheck.row] = post.createGroup!
                    let indexPath = IndexPath(item: indexCheck.row , section: 0)
                    self.tblViewss.reloadRows(at: [indexPath], with: .none)
                    
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
            //            self.showAlert(title: "OPENSPOT", message: error.description , controller: self)
        }, showHUD: true)
    }
    
    func acceptRequest(apiUrl : String , groupId : Int , indexCheck : IndexPath , isRejectOrAccept : Bool) {
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(apiUrl)\(groupId)"
        let groupInfo = self.listOfChat?.groupObject?.listOfGroup![indexCheck.row]
        WebServiceManager.put(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.listOfChat?.groupObject?.listOfGroup![indexCheck.row].is_member = true
                    self.isLeave.append(groupInfo!.id!)
                    if let index  = self.isInvited.index(where: {$0 == groupInfo?.id}) {
                        self.isInvited.remove(at: index)
                    }
                    let indexPath = IndexPath(item: indexCheck.row , section: 0)
                    self.tblViewss.reloadRows(at: [indexPath], with: .none)
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    func RejectRequest(apiUrl : String , groupId : Int , indexCheck : IndexPath , isRejectOrAccept : Bool) {
        
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to reject this group invitation ?".localized()) {
            let param =    [ : ] as [String : Any]
            let serviceURl = "\(apiUrl)\(groupId)"
            let groupInfo = self.listOfChat?.groupObject?.listOfGroup![indexCheck.row]
            WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
                if  let post = responseData as? UserResponse {
                    if post.status == true {
                        if let index  = self.isInvited.index(where: {$0 == groupInfo?.id}) {
                            self.isInvited.remove(at: index)
                        }
                        self.isRequestedForMember.append(groupInfo!.id!)
                        let indexPath = IndexPath(item: indexCheck.row , section: 0)
                        self.tblViewss.reloadRows(at: [indexPath], with: .none)
                        
                    } else {
                        self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    }
                }
            }, fail: { (error) in
            }, showHUD: true)
            
        }
    }
    
    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        var serviceURL : String = ""
        if joined == "1" {
            serviceURL = "\(GROUPLIST)joined?q=\(allSearch)"
        } else {
            serviceURL = "\(GROUPLIST)other?q=\(allSearch)"
        }
        
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "Group List".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
            self!.listOfChat = (response as! UserResponse)
            if self!.listOfChat?.status == true {
                DispatchQueue.global(qos: .utility).async {
                    DispatchQueue.main.async {
                        self!.tblViewss.delegate = self
                        self!.tblViewss.dataSource = self
                        self!.tblViewss.reloadData()
                    }
                }}
            else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfChat?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    func leaveGroup(apiUrl : String , groupId : Int , indexCheck : IndexPath) {
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to Leave this group".localized()) {
            let param =    [ : ] as [String : Any]
            let serviceURl = "\(apiUrl)\(groupId)"
            WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post", modelType: UserResponse.self, success: { (responseData) in
                if  let post = responseData as? UserResponse {
                    if post.status == true {
                        self.listOfChat?.groupObject?.listOfGroup?.remove(at: indexCheck.row)
                        self.tblViewss.deleteRows(at: [indexCheck], with: .fade)
                    } else {
                        self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    }
                }
            }, fail: { (error) in
            }, showHUD: true)
            
        }
    }
}
extension UBGroupListVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfChat?.groupObject?.listOfGroup?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let groupList = self.listOfChat?.groupObject?.listOfGroup?[indexPath.row] {
            let cell = tableView.dequeueReusableCell(with: UniGroupCell.self, for: indexPath)
            cell.lblUniName.text =  groupList.name
            cell.lblUniGroupName.text =  groupList.university_name
            let memberCount = groupList.members_count
            let postCount = groupList.posts_count
            cell.requestCountLabel.isHidden = true
            cell.btnJoinGroup.isHidden = false
            if let is_private_group = groupList.is_private_group, is_private_group {
                if let is_requested = groupList.is_requested, is_requested {
                    cell.btnJoinGroup.setTitle("Cancel Request".localized(), for: .normal)
                    cell.btnJoinGroup.isHidden = false
                    cell.btnJoinGroup.isUserInteractionEnabled = true
                } else if let is_member = groupList.is_member,  let is_my_group = groupList.is_my_group {
                    var title = "Leave Group".localized()
                    if is_my_group {
                        title = "My Group".localized()
                        if let count = groupList.requests_count, count > 0 {
                            cell.requestCountLabel.isHidden = false
                            cell.requestCountLabel.text = "\(count)"
                        }
                      cell.btnJoinGroup.isUserInteractionEnabled = false
                    } else if is_member {
                        cell.btnJoinGroup.isUserInteractionEnabled = true
                        title = "Leave Group".localized()
                    } else if !is_member{
                        cell.btnJoinGroup.isUserInteractionEnabled = true
                        title = "Join Group".localized()
                    }
                    cell.btnJoinGroup.setTitle(title, for: .normal)
                    cell.btnJoinGroup.isHidden = false
                }  else if let is_invited = groupList.is_invited, is_invited {
                    cell.btnJoinGroup.isHidden = true
                } else if let is_member = groupList.is_member, is_member {
                    cell.btnJoinGroup.isHidden = true
                }
            } else {
                cell.btnJoinGroup.isHidden = true
            }
            
            if memberCount != nil {
                cell.lblMEmber.text = "\(memberCount!)"
            }
            if postCount != nil {
                cell.lblPost.text = "\(postCount!)"
            }
            cell.delegate = self
            cell.checkIndex = indexPath
            guard  let image = groupList.group_thumb  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: cell.imgOfUni, placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfUni.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUni, radius: CGFloat(someFloat))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? UniGroupCell {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupFileMemberCalenderVc") as? UBGroupFileMemberCalenderVc
                  vc?.groupObj = self.listOfChat?.groupObject?.listOfGroup![indexPath.row]
            switch cell.btnJoinGroup.titleLabel!.text {
            case "Leave Group".localized():
                vc?.type = .leaveGroup
            case "Join Group".localized():
                vc?.type = .JoinGroup
            case "My Group".localized():
                 vc?.type = .MyGroup
            default:
                vc?.type = .CancelRequest
            }
          self.navigationController?.pushViewController(vc!, animated: true)
        }
      
    }
    
    func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
        if isSearch == false  {
            if scrollView == tblViewss {
                if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
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
                } else {
                }
            }
        }
    }
}

extension UBGroupListVC : JoinGroupOrCancelRequestDelegate {
    func acceptRequest(cell: UniGroupCell, selectIndex: IndexPath) {
        let groupId = self.listOfChat?.groupObject?.listOfGroup![selectIndex.row].invitation_id
        acceptRequest(apiUrl: ACCEPTINVITATION , groupId: groupId! , indexCheck: selectIndex, isRejectOrAccept: true)
    }
    
    func rejectRequest(cell: UniGroupCell, selectIndex: IndexPath) {
        let groupInfo = self.listOfChat?.groupObject?.listOfGroup![selectIndex.row]
        if groupInfo?.is_member == true {
            leaveGroup(apiUrl: LEAVEGROUPOGGROUP , groupId: (groupInfo?.id!)! , indexCheck: selectIndex)
        } else {
            RejectRequest(apiUrl: REJECTREQUEST , groupId: (groupInfo?.invitation_id!)! , indexCheck: selectIndex, isRejectOrAccept: false)
        }
    }
    
    func joinOrCanelRequest(cell: UniGroupCell, selectIndex: IndexPath) {
        if cell.btnJoinGroup.titleLabel!.text == "Leave Group".localized() {
            let groupInfo = self.listOfChat?.groupObject?.listOfGroup![selectIndex.row]
            leaveGroup(apiUrl: LEAVEGROUPOGGROUP , groupId: (groupInfo?.id!)! , indexCheck: selectIndex)
        } else {
            let groupId = self.listOfChat?.groupObject?.listOfGroup![selectIndex.row].id
                   if self.listOfChat?.groupObject?.listOfGroup![selectIndex.row].is_requested == true {
                       let param =    [ : ] as [String : Any]
                       let serviceURl = "\(CANCELGROUPREQUEST)\(groupId!)"
                       WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
                           if  let post = responseData as? UserResponse {
                               if post.status == true {
                                   self.isRequestedForMember.append(groupId!)
                                   if let index  = self.isRequested.firstIndex(where: {$0 == groupId}) {
                                       self.isRequested.remove(at: index)
                                   }
                                   self.listOfChat?.groupObject?.listOfGroup![selectIndex.row] = post.createGroup!
                                   let indexPath = IndexPath(item: selectIndex.row , section: 0)
                                   self.tblViewss.reloadRows(at: [indexPath], with: .none)
                                   
                               } else {
                                   self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                               }
                           }
                       }, fail: { (error) in
                       }, showHUD: true)
                   } else {
                       cancelOrJoinRequest(apiUrl: JOINGROUPREQUEST , groupId: groupId! , indexCheck: selectIndex)
                   }
        }
    }
}

extension UBGroupListVC : GroupObjectDelegate  {
    func createGroup(obj : GroupList) {
        self.listOfChat?.groupObject?.listOfGroup?.insert(obj, at: 0)
        self.isMyGroup.append(obj.id!)
        self.isPrivateGroup.append(obj.id!)
        tblViewss.reloadData()
    }
    
}
extension UBGroupListVC : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        getGroupList()
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        isSearch = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getSearchResult(search: searchBar.text!)
        isSearch = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        isSearch = false
        
        return true
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        
    }
}

