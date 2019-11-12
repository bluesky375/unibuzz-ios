//
//  FeedHeaderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol UserPostDetailDeledate : class {
    func isAddToFav(cell : FeedHeaderCell , sec : Int)
    func isReportOrShare(cell : FeedHeaderCell , sec : Int)
    func isUserLike(cell : FeedHeaderCell , sec : Int)
    func isUserDislike(cell : FeedHeaderCell , sec : Int)
    func isUserHappyClick(cell : FeedHeaderCell , sec : Int)
    func isUserAngry(cell : FeedHeaderCell , sec : Int)
    func selectUserOnHeaderPost(cell : FeedHeaderCell , index : Int)
}

class FeedHeaderCell: UITableViewHeaderFooterView {

    @IBOutlet weak var logoOfUni: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblDescriptiionOfUni: UILabel!
    @IBOutlet weak var lblMember: UILabel!
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblNAme: UILabel!
    @IBOutlet weak var lblDateOfPost: UILabel!
    @IBOutlet weak var lblUni: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    @IBOutlet weak var lblAngry: UILabel!
    @IBOutlet weak var lblHappy: UILabel!
    @IBOutlet weak var btnIsFavSelect: UIButton!
    @IBOutlet weak var btnHappy: UIButton!
    @IBOutlet weak var btnUserLike: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnAngry: UIButton!
    
    weak var delegate : UserPostDetailDeledate?
    var index : Int?
    @IBOutlet weak var imgOfAvatarFirst: UIImageView!
    @IBOutlet weak var imgOfAvatarSecond: UIImageView!
    @IBOutlet weak var imgOfAvatarThird: UIImageView!
    @IBOutlet weak var imgOfAvatarFourth: UIImageView!
    
    @IBOutlet weak var lblEdited: UILabel!

    @IBAction func btnShare_Pressed(_ sender: UIButton) {
        print("Ahmad")
    }
    
    @IBAction func btnShareOrHide_Pressed(_ sender: UIButton) {
        delegate?.isReportOrShare(cell: self, sec: index!)
    }
    @IBAction func btnFav_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isAddToFav(cell: self, sec: index!)

    }

    @IBAction private func btnProfile(_ sender : UIButton) {
        delegate?.selectUserOnHeaderPost(cell: self, index: index!)
        //        delegate?.isClickOnComment(cell: self, index: index!)
    }

    
    @IBAction private func btnIsClickOnComment_Pressed(_ sender : UIButton) {
//        delegate?.isClickOnComment(cell: self, index: index!)
    }
    
    @IBAction private func btnIsUserLike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserLike(cell: self, sec: index!)
    }
    
    
    @IBAction private func btnUserDislike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserDislike(cell: self, sec: index!)
    }
    
    @IBAction private func btnIsUserHappy_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserHappyClick(cell: self, sec: index!)
    }
    
    @IBAction private func btnIsUserAngry_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserAngry(cell: self, sec: index!)
    }

    
}

