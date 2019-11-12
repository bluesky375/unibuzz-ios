//
//  CommentCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol ReplyOnCommentDelegate  : class {
    func replyOnComment(cell : CommentCell , selectIndex : IndexPath , sec : Int)
//    func clickOnProfile(cell : CommentCell , selectIndex : IndexPath , sec : Int)

}

class CommentCell: UITableViewCell {

    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPostComment: UILabel!
    
    weak var delegate : ReplyOnCommentDelegate?
    var indexSelect : IndexPath?
    var selectionSection : Int?
    
    @IBOutlet weak var btnReply: UIButton!
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnProfile : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnProfileCommenter_Pressed(_ sender: UIButton) {
//        delegate?.clickOnProfile(cell: self, selectIndex: indexSelect!, sec: selectionSection!)
    }
    
    @IBAction private func btnReply(_ sender: UIButton) {
        delegate?.replyOnComment(cell: self, selectIndex: indexSelect! , sec: selectionSection!)
        
    }
    
    @IBAction func btnShare_Pressed(_ sender: UIButton) {
            print("Ahmad")
    }
    @IBAction func btnTap_Pressed(_ sender: Any) {
        print("Ahmadd chck this")
    }
}

