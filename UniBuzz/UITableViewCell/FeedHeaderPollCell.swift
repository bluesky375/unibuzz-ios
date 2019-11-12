//
//  FeedHeaderPollCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 31/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import GTProgressBar

protocol UserPollingDeledates : class {
    func isAddToFAV(cell : FeedHeaderPollCell , index : Int)
    func isReportOrSHARE(cell : FeedHeaderPollCell , indexs : Int  , sender : UIButton)
//    func isClickOnCOMMENTS(cell : FeedHeaderPollCell , index : Int)
    func isUserLIKES(cell : FeedHeaderPollCell , index : Int)
    func isUserDISLIKE(cell : FeedHeaderPollCell , index : Int)
    func isUserHappyCLICKS(cell : FeedHeaderPollCell , index : Int)
    func isUserAngrESS(cell : FeedHeaderPollCell , index : Int)
    
    func pollQuestion1(cell : FeedHeaderPollCell , index : Int , btnIndex : Int)
    func pollQuestion2(cell : FeedHeaderPollCell , index : Int , btnIndex : Int )
    func pollQuestion3(cell : FeedHeaderPollCell , index : Int , btnIndex : Int )
    func pollQuestion4(cell : FeedHeaderPollCell , index : Int , btnIndex : Int)
    func pollQuestion5(cell : FeedHeaderPollCell , index : Int , btnIndex : Int)
    func selectUserOnHeaderPoll(cell : FeedHeaderPollCell , index : Int)


}


class FeedHeaderPollCell: UITableViewHeaderFooterView {
    
    @IBOutlet weak var logoOfUni: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblDescriptiionOfUni: UILabel!
    @IBOutlet weak var lblMember: UILabel!

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
    @IBOutlet weak var progressOfFifthPoll: GTProgressBar!

    weak var delegate : UserPollingDeledates?
    var sec : Int?
    @IBOutlet weak var btnReport: UIButton!
    
    
    @IBOutlet weak var lblFirstPollQuestion: UILabel!
    @IBOutlet weak var lblSecondPollQuestion: UILabel!
    @IBOutlet weak var lblThirdPollQuestion: UILabel!
    @IBOutlet weak var lblFourthQuestion: UILabel!
    @IBOutlet weak var lblFifthQues: UILabel!

    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLaugh: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnAngry: UIButton!
    @IBOutlet weak var btnFav: UIButton!
    
    @IBOutlet weak var btnQuestion1: UIButton!
    @IBOutlet weak var btnQuestion2: UIButton!
    @IBOutlet weak var btnQuestion3: UIButton!
    @IBOutlet weak var btnQuestion4: UIButton!
    @IBOutlet weak var btnQuestion5: UIButton!

    
    @IBOutlet weak var imgOfAvatarFirst: UIImageView!
    @IBOutlet weak var imgOfAvatarSecond: UIImageView!
    @IBOutlet weak var imgOfAvatarThird: UIImageView!
    @IBOutlet weak var imgOfAvatarFourth: UIImageView!

    
    @IBOutlet weak var heightofFirstProgress: NSLayoutConstraint!
    @IBOutlet weak var heightofSecondProgress: NSLayoutConstraint!
    @IBOutlet weak var heightOfThirdPreogres: NSLayoutConstraint!

    @IBOutlet weak var heightOfThirdLabel: NSLayoutConstraint!
    @IBOutlet weak var heightOfFourthLabel: NSLayoutConstraint!
    @IBOutlet weak var heightOfFiftLabel: NSLayoutConstraint!
    @IBOutlet weak var lblEdited: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func btnPollQuestion5_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.pollQuestion5(cell: self, index: sec!, btnIndex: 4)
    }
    
    @IBAction private func btnProfile(_ sender : UIButton) {
        delegate?.selectUserOnHeaderPoll(cell: self, index: sec!)
        //        delegate?.isClickOnComment(cell: self, index: index!)
    }

    
    @IBAction func btnPollQuestion4_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.pollQuestion4(cell: self, index: sec!, btnIndex: 3)
    }
    
    @IBAction func btnPollQuestion3_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.pollQuestion3(cell: self, index: sec! , btnIndex: 2)

    }
    
    @IBAction func btnPollQuestion2(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.pollQuestion2(cell: self, index: sec! , btnIndex: 1)

    }
    
    @IBAction func btnPollQuestion1(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.pollQuestion1(cell: self, index: sec! , btnIndex: 0)

    }
    
    @IBAction private func btnIsAddToFav(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isAddToFAV(cell: self , index: sec!)
    }
    
    @IBAction private func btnIsReport_Pressed(_ sender : UIButton) {
        delegate?.isReportOrSHARE(cell: self, indexs: sec! , sender: sender)
    }
    @IBAction private func btnIsClickOnComment_Pressed(_ sender : UIButton) {
//        delegate?.isClickOnCOMMENTS(cell: self, index: sec!)
    }
    @IBAction private func btnIsUserLike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserLIKES(cell: self, index: sec!)
    }
    @IBAction private func btnUserDislike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserDISLIKE(cell: self, index: sec!)
    }
    
    @IBAction private func btnIsUserHappy_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserHappyCLICKS(cell: self, index: sec!)
    }
    
    @IBAction private func btnIsUserAngry_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserAngrESS(cell: self, index: sec!)
    }
    

    
}
