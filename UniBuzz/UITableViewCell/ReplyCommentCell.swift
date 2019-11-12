//
//  ReplyCommentCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol ReportOnCommentDelegate  : class {
    func reportOnComment(cell : ReplyCommentCell , selectIndex : IndexPath , sec : Int)
    func profileSelected(cell : ReplyCommentCell , selectIndex : IndexPath , sec : Int)

}


class ReplyCommentCell: UITableViewCell {

    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var lbltext: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    weak var delegate : ReportOnCommentDelegate?
    var indexSelect : IndexPath?
    var selectionSection : Int?
    @IBOutlet weak var btnMore: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnReport_ReplyComment_Pressed(_ sender : UIButton) {
        delegate?.reportOnComment(cell: self , selectIndex: indexSelect! , sec: selectionSection!)
    }
    
    @IBAction private func btnProfile_Pressed(_ sender : UIButton) {
        delegate?.profileSelected(cell: self , selectIndex: indexSelect! , sec: selectionSection!)
    }
    
    
}
