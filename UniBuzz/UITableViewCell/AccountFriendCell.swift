//
//  AccountFriendCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SDWebImage
  

protocol AccountFriendCellDelegate:class {
    
    //Send request to other user, object will remove from current list and will add in RequestsList [1].
    func sendRequest(index: Int, suggestionObject: SuggestionList)
    // if user cancel friend request, object will remove from list of Requests [1].
    func cancelRequest(index: Int, requestObject: RequestFriendList)
    
    //Accept Friend Request at this method object will remove from this list and will add in All Friend List [0].
    func acceptRequest(index: Int, requestObject: RequestFriendList)
    //at Rejection of object will remove from list [0].
    func rejectRequest(index: Int, requestObject: RequestFriendList)
    
    // Object will be removed from list when this method is called
    func unFriendRequest(index: Int, friendObject: FriendItemList)
    
    //follow and unfollow
    func followRequest(index: Int, friendObject: FriendItemList)
    func unFollowRequest(index: Int, friendObject: FriendItemList)
}

class AccountFriendCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var userImageView: UIImageView! {
        didSet {
            self.userImageView.layer.cornerRadius = 25.5
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userCollegeLabel: UILabel!
    @IBOutlet weak var sendOrAcceptButton: UIButton! // #D89CA2
    @IBOutlet weak var cancelOrRejectButton: UIButton! // unselected = #9CB1DB & selected = #6881C0
    @IBOutlet weak var sendOrAcceptButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelOrRejectButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelOrRejectButtonLeadingConstraint: NSLayoutConstraint!

    //MARK:- Public Variables
    weak var delegate: AccountFriendCellDelegate?
    
    //MARK:- Private Variables
    private var friendObject: FriendItemList?
    private var requestObject: RequestFriendList?
    private var suggestionObject: SuggestionList?
    private var index = 0
    private var isFriendSelected = false
    private var isSuggestion = false
    private var isRequested = false
    
    //MARK:- Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func cellDataSource(friend: FriendItemList, indexPath: IndexPath) {
        
        self.index = indexPath.row
        self.isFriendSelected = true
        self.isSuggestion = false
        self.isRequested = false
        self.friendObject = friend
        
        self.cancelOrRejectButton.isHidden = false
        self.sendOrAcceptButtonWidthConstraint.constant = 60
        self.cancelOrRejectButtonWidthConstraint.constant = 60
        self.cancelOrRejectButtonLeadingConstraint.constant = 10
        
        self.sendOrAcceptButton.setTitleColor(UIColor(hex: "#7B3839"), for: .normal)
        self.sendOrAcceptButton.setBackgroundColor(color: UIColor(hex: "#D89CA2"), forState: .normal)

        self.userImageView.sd_setImage(with: URL(string: friend.friendProfile!.profile_image!)) { (image, error, cache, url) in
            
        }
        
        if friend.is_follow! == 1 {
            //Show Unfollow
            self.sendOrAcceptButton.setTitle("Unfriend".localized(), for: .normal)
            self.cancelOrRejectButton.setTitle("Unfollow".localized(), for: .normal)
            self.cancelOrRejectButton.setBackgroundColor(color: UIColor(hex: "#9CB1DB"), forState: .normal)
        }else {
            //Show Follow
            self.sendOrAcceptButton.setTitle("Unfriend".localized(), for: .normal)
            self.cancelOrRejectButton.setTitle("Follow".localized(), for: .normal)
            self.cancelOrRejectButton.setBackgroundColor(color: UIColor(hex: "#6881C0"), forState: .normal)
        }
        
        self.userNameLabel.text = friend.friendProfile!.full_name
        self.userCollegeLabel.text = friend.friendProfile!.uniObj!.name
    }
    
    @IBAction func btnSendMessageToUser(_ sender: UIButton) {
        
    }
    
    
    func cellDataSource(request: RequestFriendList, indexPath: IndexPath) {
        self.index = indexPath.row
        self.isFriendSelected = false
        self.isSuggestion = false
        self.isRequested = true
        self.requestObject = request
        
        self.userImageView.sd_setImage(with: URL(string: request.profile_image!)) { (image, error, cache, url) in
            
        }
        
        if request.is_sent! {
            self.cancelOrRejectButton.isHidden = true
            self.sendOrAcceptButtonWidthConstraint.constant = 60
            self.cancelOrRejectButtonWidthConstraint.constant = 0
            self.cancelOrRejectButtonLeadingConstraint.constant = 10
            
            self.sendOrAcceptButton.setTitle("Cancel".localized(), for: .normal)
            self.sendOrAcceptButton.setBackgroundColor(color: UIColor(hex: "#D89CA2"), forState: .normal)
            self.sendOrAcceptButton.setTitleColor(UIColor(hex: "#7B3839"), for: .normal)
        }else {
            self.cancelOrRejectButton.isHidden = false
            self.sendOrAcceptButtonWidthConstraint.constant = 60
            self.cancelOrRejectButtonWidthConstraint.constant = 60
            self.cancelOrRejectButtonLeadingConstraint.constant = 10
            
            self.sendOrAcceptButton.setTitle("Accept".localized(), for: .normal)
            self.sendOrAcceptButton.setTitleColor(UIColor.white, for: .normal)
            self.sendOrAcceptButton.setBackgroundColor(color: UIColor(hex: "#6881C0"), forState: .normal)
            self.sendOrAcceptButton.isHidden = false
            self.cancelOrRejectButton.setTitle("Reject".localized(), for: .normal)
            self.cancelOrRejectButton.setBackgroundColor(color: UIColor(hex: "#D89CA2"), forState: .normal)
            self.cancelOrRejectButton.setTitleColor(UIColor(hex: "#7B3839"), for: .normal)
        }
        
        self.userNameLabel.text = request.full_name
        self.userCollegeLabel.text = request.uni_name
    }
    
    func cellDataSource(suggestion: SuggestionList, indexPath: IndexPath) {
        self.index = indexPath.row
        
        self.isFriendSelected = false
        self.isSuggestion = true
        self.isRequested = false
        self.suggestionObject = suggestion
        
        self.sendOrAcceptButton.setTitle("Friend Request".localized(), for: .normal)
        self.sendOrAcceptButtonWidthConstraint.constant = 120
        self.cancelOrRejectButton.isHidden = true
        self.cancelOrRejectButtonWidthConstraint.constant = 0
        self.cancelOrRejectButtonLeadingConstraint.constant = 10
        
        self.sendOrAcceptButton.setTitleColor(UIColor.white, for: .normal)
        self.sendOrAcceptButton.setBackgroundColor(color: UIColor(hex: "#6881C0"), forState: .normal)
        self.userImageView.sd_setImage(with: URL(string: suggestion.friendProfile!.profile_image!)) { (image, error, cache, url) in
            
        }
        self.userNameLabel.text = suggestion.friendProfile!.full_name
        self.userCollegeLabel.text = suggestion.friendProfile!.uniObj!.name
        
    }
    
    @IBAction func sendOrAcceptAction() {
        if self.isFriendSelected {
            // Object will be removed from list when this method is called
            self.delegate?.unFriendRequest(index: self.index, friendObject: self.friendObject!)
        }else if self.isRequested {
            if let sent = self.requestObject {
                if sent.is_sent! {
                    // if user cancel friend request, object will remove from list of Requests [1].
                    self.delegate?.cancelRequest(index: self.index, requestObject: self.requestObject!)
                }else {
                    //Accept Friend Request at this method object will remove from this list and will add in All Friend List [0].
                    self.delegate?.acceptRequest(index: self.index, requestObject: self.requestObject!)
                }
            }else {
                //Accept Friend Request at this method object will remove from this list and will add in All Friend List [0].
                self.delegate?.acceptRequest(index: self.index, requestObject: self.requestObject!)
            }
        }else if self.isSuggestion {
            //Send request to other user, object will remove from current list and will add in RequestsList [1].
            self.delegate?.sendRequest(index: self.index, suggestionObject: self.suggestionObject!)
        }
    }
    
    @IBAction func cancelOrRejectAction() {
        if self.isFriendSelected {
            if let friend = self.friendObject {
                if friend.is_follow! == 1 {
                    self.delegate?.unFollowRequest(index: self.index, friendObject: self.friendObject!)
                }else {
                    self.delegate?.followRequest(index: self.index, friendObject: self.friendObject!)
                }
            }
        }else if self.isRequested {
            //at Rejection of object will remove from list [0].
            self.delegate?.rejectRequest(index: self.index, requestObject: self.requestObject!)
        }else if self.isSuggestion {
//            self.delegate?.sendRequest(index: self.index)
        }
    }
}
