//
//  UBChatFooterCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol SendMessageToFriendListDelegate : class {
    func selectFriend(cell : UBChatFooterCell , indexSelect : IndexPath)
//    func friendProfile(cell : UBChatFooterCell , indexSelect : IndexPath)
    
}

class UBChatFooterCell: UITableViewCell {
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgofUser: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var btnSelect : UIButton!
    
    weak var delegates : SendMessageToFriendListDelegate?
    var selectIndex : IndexPath?
    
    @IBOutlet weak var lblIsUserAdmin: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnSelectFriend(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegates?.selectFriend(cell: self, indexSelect: selectIndex!)
    }
        
//    @IBAction private func btnProfileSelect(_ sender : UIButton) {
//    //        sender.isSelected = !sender.isSelected
//        delegate?.friendProfile(cell: self, indexSelect: selectIndex!)
//    }

    
}
