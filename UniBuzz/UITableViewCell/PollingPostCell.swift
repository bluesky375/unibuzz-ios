//
//  PollingPostCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import GTProgressBar

protocol UserPollingDeledate : class {
    func isAddToFavss(cell : PollingPostCell , index : IndexPath)
    func isReportOrSharess(cell : PollingPostCell , indexs : IndexPath)
    func isClickOnCommentss(cell : PollingPostCell , index : IndexPath)
    func isUserLikess(cell : PollingPostCell , index : IndexPath)
    func isUserDislikess(cell : PollingPostCell , index : IndexPath)
    func isUserHappyClickss(cell : PollingPostCell , index : IndexPath)
    func isUserAngryss(cell : PollingPostCell , index : IndexPath)
    func selectedPollArea(cell : PollingPostCell , index : IndexPath)
    func selectUserOnPoll(cell : PollingPostCell , index : IndexPath)

}


class PollingPostCell: UITableViewCell {
    
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblNAme: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUni: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    @IBOutlet weak var lblAngry: UILabel!
    @IBOutlet weak var lblHappy: UILabel!
    @IBOutlet weak var lblTotalVoteCast : UILabel!

    @IBOutlet weak var progressOfFirstPoll: GTProgressBar!
    @IBOutlet weak var progressOfSecondPoll: GTProgressBar!
    @IBOutlet weak var progressOfThidPoll: GTProgressBar!
    @IBOutlet weak var progressOfFourthPoll: GTProgressBar!
    @IBOutlet weak var progressFifth: GTProgressBar!
    
    weak var delegate : UserPollingDeledate?
    var index : IndexPath?
    @IBOutlet weak var btnReport: UIButton!

    
    @IBOutlet weak var lblFirstPollQuestion: UILabel!
    @IBOutlet weak var lblSecondPollQuestion: UILabel!
    @IBOutlet weak var lblThirdPollQuestion: UILabel!
    @IBOutlet weak var lblFourthQuestion: UILabel!
    @IBOutlet weak var lblFifthQuestion: UILabel!
    
    
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLaugh: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnAngry: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    
    
    @IBOutlet weak var imgOfAvatarFirst: UIImageView!
    @IBOutlet weak var imgOfAvatarSecond: UIImageView!
    @IBOutlet weak var imgOfAvatarThird: UIImageView!
    @IBOutlet weak var imgOfAvatarFourth: UIImageView!

    @IBOutlet weak var heightofFirstProgress: NSLayoutConstraint!
    @IBOutlet weak var heightofSecondProgress: NSLayoutConstraint!
    @IBOutlet weak var heightofThirdProgress: NSLayoutConstraint!

    @IBOutlet weak var heightOfThirdLabel: NSLayoutConstraint!
    @IBOutlet weak var heightOfFourthLabel: NSLayoutConstraint!
    @IBOutlet weak var heightOfFifthLabel: NSLayoutConstraint!
    @IBOutlet weak var viewOfEmoji: CardView!
    
    @IBOutlet weak var lblEdited: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
//        layer.shouldRasterize = true
//        layer.rasterizationScale = UIScreen.main.scale

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func btnSelectableArea_Pressed(_ sender: UIButton) {
        delegate?.selectedPollArea(cell: self , index: index!)
    }
    @IBAction private func btnIsAddToFav(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isAddToFavss(cell: self, index: index!)
    }
    
    @IBAction private func btnIsReport_Pressed(_ sender : UIButton) {
        delegate?.isReportOrSharess(cell: self, indexs: index!)
    }
    @IBAction private func btnIsClickOnComment_Pressed(_ sender : UIButton) {
        delegate?.isClickOnCommentss(cell: self, index: index!)
    }
    @IBAction private func btnIsUserLike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserLikess(cell: self, index: index!)
    }
    @IBAction private func btnUserDislike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserDislikess(cell: self, index: index!)
    }
    
    @IBAction private func btnIsUserHappy_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserHappyClickss(cell: self, index: index!)
    }
    
    @IBAction private func btnIsUserAngry_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserAngryss(cell: self, index: index!)
    }
    
    @IBAction private func btnSendMessagePoll(_ sender : UIButton) {
        delegate?.selectUserOnPoll(cell: self, index: index!)
    }
    
    
    

    
}

//func selectUserOnPoll(cell: PollingPostCell, index: IndexPath) {
//    <#code#>
//}
