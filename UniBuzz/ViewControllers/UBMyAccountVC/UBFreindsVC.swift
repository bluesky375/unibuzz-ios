//
//  UBFreindsVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBFreindsVC: UIViewController {
    @IBOutlet weak var allFiends: UIButton!
    @IBOutlet weak var suggestions: UIButton!
    @IBOutlet weak var requests: UIButton!
    @IBOutlet weak var tblViewss: UITableView!
    var index: Int?
    var friendList : UserResponse?
    var isFriendSelected = false
    var isSuggestion = false
    var isRequested = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isFriendSelected = true
        tblViewss.delegate = self
        tblViewss.dataSource = self
        self.allFiends.setBackgroundColor(color: UIColor(hex: "#3745a3"), forState: .normal)
        self.allFiends.setTitleColor(UIColor.white, for: .normal)
        self.requests.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.requests.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        self.suggestions.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.suggestions.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllFriendList()
    }
    
}

extension UBFreindsVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFriendSelected {
            if let friendsList = self.friendList,
                let friendsItem = friendsList.friendsItem,
                let listOfFriend = friendsItem.listOfFriend {
                
                return listOfFriend.listOfFriend!.count
                
            }
        }else if isRequested {
            if let friendsList = self.friendList,
                let friendsItem = friendsList.friendsItem,
                let listOFRequest = friendsItem.listOfRequest {
                
                return listOFRequest.listOFRequest!.count
                
            }
        }else if isSuggestion {
            if let friendsList = self.friendList,
                let friendsItem = friendsList.friendsItem,
                let listOFSuggestion = friendsItem.listOfSujjestion {
                
                return listOFSuggestion.listOFSuggestion!.count
                
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(with: AccountFriendCell.self, for: indexPath)
        
        if isFriendSelected {
            if let friendsList = self.friendList,
                let friendsItem = friendsList.friendsItem,
                let listOfFriend = friendsItem.listOfFriend {
                
                cell.cellDataSource(friend: listOfFriend.listOfFriend![indexPath.row], indexPath:indexPath)
                
            }
        }else if isRequested {
            if let friendsList = self.friendList,
                let friendsItem = friendsList.friendsItem,
                let listOFRequest = friendsItem.listOfRequest {
                
                cell.cellDataSource(request: listOFRequest.listOFRequest![indexPath.row], indexPath:indexPath)
                
            }
        }else if isSuggestion {
            if let friendsList = self.friendList,
                let friendsItem = friendsList.friendsItem,
                let listOFSuggestion = friendsItem.listOfSujjestion {
                
                cell.cellDataSource(suggestion: listOFSuggestion.listOFSuggestion![indexPath.row], indexPath:indexPath)
                
            }
        }
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
      return 81.0
    }
}

extension UBFreindsVC {
    @IBAction func allFriendsAction(_ sender: UIButton) {
        self.isSuggestion = false
        self.isRequested = false
        self.isFriendSelected = true
        self.allFiends.setBackgroundColor(color: UIColor(hex: "#3745a3"), forState: .normal)
        self.allFiends.setTitleColor(UIColor.white, for: .normal)
        self.requests.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.requests.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        self.suggestions.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.suggestions.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        self.tblViewss.reloadData()
        self.getAllFriendList()

    }
    
    @IBAction func requestAction(_ sender: UIButton) {
        self.isSuggestion = false
        self.isRequested = true
        self.isFriendSelected = false
        
        self.requests.setBackgroundColor(color: UIColor(hex: "#3745a3"), forState: .normal)
        self.requests.setTitleColor(UIColor.white, for: .normal)
        
        self.allFiends.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.allFiends.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        
        self.suggestions.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.suggestions.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        
        self.tblViewss.reloadData()
        self.getAllFriendList()

    }
    
    @IBAction func suggestionsAction(_ sender: UIButton) {
        self.isSuggestion = true
        self.isRequested = false
        self.isFriendSelected = false
        
        self.suggestions.setBackgroundColor(color: UIColor(hex: "#3745a3"), forState: .normal)
        self.suggestions.setTitleColor(UIColor.white, for: .normal)
        
        self.requests.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.requests.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        
        self.allFiends.setBackgroundColor(color: UIColor.white, forState: .normal)
        self.allFiends.setTitleColor(UIColor(hex: "#3745a3"), for: .normal)
        
        self.tblViewss.reloadData()
        self.getAllFriendList()
    }
}

extension UBFreindsVC: AccountFriendCellDelegate {
    
    func sendRequest(index: Int, suggestionObject: SuggestionList) {
        //Call on Suggestion Button
        let obj = self.friendList!.friendsItem!.listOfSujjestion!.listOFSuggestion![index]
        let endPoint = SEND + String(obj.friend_user_id!)
        self.performAPICall(endPoint: endPoint)
        
        var json = obj.friendProfile!.toJSON()
        json["user_id"] = obj.user_id!
        json["is_sent"] = true
        json["university_name"] = obj.friendProfile!.uniObj!.name
        
        let requestobj = RequestFriendList(JSON: json)
        
        self.friendList!.friendsItem!.listOfRequest!.listOFRequest!.insert(requestobj!, at: 0)
        self.friendList!.friendsItem!.listOfSujjestion!.listOFSuggestion?.remove(at: index)
        
        self.tblViewss.reloadData()
    }
    
    func cancelRequest(index: Int, requestObject: RequestFriendList) {
        //Call when user at Suggestion tab
        let obj = self.friendList!.friendsItem!.listOfRequest!.listOFRequest![index]
        let endPoint = CANCEL + String(obj.user_id!)
        self.performAPICall(endPoint: endPoint)
        self.friendList!.friendsItem!.listOfRequest!.listOFRequest!.remove(at: index)
        self.tblViewss.reloadData()
    }

    func acceptRequest(index: Int, requestObject: RequestFriendList) {
    
        let userObj = Persistence(with: .user)
        let user: Session? = userObj.load()
        
        //Call when user will be at Requests tab
        let obj = self.friendList!.friendsItem!.listOfRequest!.listOFRequest![index]
        let endPoint = ACCEPT + String(obj.user_id!)
        self.performAPICall(endPoint: endPoint)
        
        let profileJson = obj.toJSON()
        let friendObj = FriendItemList(JSON: ["":""])
        friendObj?.user_id = user?.id
        friendObj?.friend_user_id = obj.user_id
        friendObj?.friendProfile = FriendProfile(JSON: profileJson)
        let uniObj = UniversityObj(JSON: ["name":obj.uni_name!])
        friendObj?.friendProfile?.uniObj = uniObj
        friendObj?.is_read = 1
        friendObj?.is_follow = 1
        
        self.friendList!.friendsItem!.listOfFriend!.listOfFriend!.insert(friendObj!, at: 0)
        self.friendList!.friendsItem!.listOfRequest!.listOFRequest!.remove(at: index)
        self.tblViewss.reloadData()
        
    }
    
    func rejectRequest(index: Int, requestObject: RequestFriendList) {
        //Call when user will be at Requests tab
        let obj = self.friendList!.friendsItem!.listOfRequest!.listOFRequest![index]
        let endPoint = REJECT + String(obj.user_id!)
        self.performAPICall(endPoint: endPoint)
        self.friendList!.friendsItem!.listOfRequest!.listOFRequest!.remove(at: index)
        self.tblViewss.reloadData()
    }
    
    func unFriendRequest(index: Int, friendObject: FriendItemList) {
        
        //Call when user will be at All Friends tab
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure you want to Unfriend ?".localized()) {
            let obj = self.friendList!.friendsItem!.listOfFriend!.listOfFriend![index]
            let endPoint = UNFRIEND + String(obj.friend_user_id!)
            self.performAPICall(endPoint: endPoint)
            self.friendList!.friendsItem!.listOfFriend!.listOfFriend!.remove(at: index)
            self.tblViewss.reloadData()

        }

    }
    
    func followRequest(index: Int, friendObject: FriendItemList) {
        //Call when user will be at All Friends tab
        let obj = self.friendList!.friendsItem!.listOfFriend!.listOfFriend![index]
        let endPoint = FOLLOWFRIEND + String(obj.friend_user_id!)
        self.performAPICall(endPoint: endPoint)
        
        obj.is_follow = 1
        self.tblViewss.reloadData()
    }
    
    func unFollowRequest(index: Int, friendObject: FriendItemList) {
        //Call when user will be at All Friends tab
        let obj = self.friendList!.friendsItem!.listOfFriend!.listOfFriend![index]
        let endPoint = UNFOLLOWFRIEND + String(obj.friend_user_id!)
        self.performAPICall(endPoint: endPoint)
        obj.is_follow = 0
        self.tblViewss.reloadData()
    }
}

//MARK:- Private Methods
extension UBFreindsVC {
    private func performAPICall(endPoint: String) {
        if Connectivity.isConnectedToInternet() {
            WebServiceManager.put(params: ["":"" as AnyObject], serviceName: endPoint, isLoaderShow: true, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
                // Perform Logic here
            }, fail: { (error) in
                
            }, showHUD: true)
        }else {
            self.showAlert(title: KMessageTitle, message: "No internet connection!".localized(), controller: self)
        }
    }
    
    
    private func getAllFriendList() {
        
        WebServiceManager.get(params: nil, serviceName: ALLFRIENDLIST , serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
            self.friendList = (response as! UserResponse)
            self.tblViewss.reloadData()
            if self.friendList?.status == true {
            } else {
                self.showAlert(title: KMessageTitle, message: (self.friendList?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
}
