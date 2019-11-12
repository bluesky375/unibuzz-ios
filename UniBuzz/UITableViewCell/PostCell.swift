//
//  PostCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol UserPostDeledate : class {
    func isAddToFav(cell : PostCell , index : IndexPath)
    func isReportOrShare(cell : PostCell , indexxx : IndexPath)
    func isClickOnComment(cell : PostCell , index : IndexPath)
    func isUserLike(cell : PostCell , index : IndexPath)
    func isUserDislike(cell : PostCell , index : IndexPath)
    func isUserHappyClick(cell : PostCell , index : IndexPath)
    func isUserAngry(cell : PostCell , index : IndexPath)
    func selectedArea(cell : PostCell , index : IndexPath)
//    func selectCommet(cell : PostCell , index : IndexPath)
    func selectUser(cell : PostCell , index : IndexPath)
    

}

class PostCell: UITableViewCell {
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblNAme: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUni: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnReport: UIButton!
    @IBOutlet weak var lblLikeCount: UILabel!
    @IBOutlet weak var lblDislikeCount: UILabel!
    @IBOutlet weak var lblAngry: UILabel!
    @IBOutlet weak var lblHappy: UILabel!
    
    
    @IBOutlet weak var btnLike : UIButton!
    @IBOutlet weak var btnLaugh: UIButton!
    @IBOutlet weak var btnDislike: UIButton!
    @IBOutlet weak var btnAngry: UIButton!
    @IBOutlet weak var btnFav: UIButton!

    @IBOutlet weak var imgOfAvatarFirst: UIImageView!
    @IBOutlet weak var imgOfAvatarSecond: UIImageView!
    @IBOutlet weak var imgOfAvatarThird: UIImageView!
    @IBOutlet weak var imgOfAvatarFourth: UIImageView!

    @IBOutlet weak var lblEdited: UILabel!
    weak var delegate : UserPostDeledate?
    var index : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnSelectableArea_Pressed(_ sender: UIButton) {
        delegate?.selectedArea(cell: self , index: index!)
    }
    @IBAction private func btnIsAddToFav(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isAddToFav(cell: self, index: index!)
    }
    
    @IBAction private func btnIsReport_Pressed(_ sender : UIButton) {
        delegate?.isReportOrShare(cell: self, indexxx: index!)
    }
    
    @IBAction private func btnIsClickOnComment_Pressed(_ sender : UIButton) {
        delegate?.isClickOnComment(cell: self, index: index!)
    }
    
    @IBAction private func btnIsUserLike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserLike(cell: self, index: index!)
    }
    
    
    @IBAction private func btnUserDislike_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserDislike(cell: self, index: index!)
    }
    
    @IBAction private func btnIsUserHappy_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserHappyClick(cell: self, index: index!)
    }
    
    @IBAction private func btnIsUserAngry_Pressed(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.isUserAngry(cell: self, index: index!)
    }
    
    @IBAction func profile_Pressed(_ sender: UIButton) {
        delegate?.selectUser(cell: self, index: index!)
    }
    
   
    
    
}
