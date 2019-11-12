//
//  GroupCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 25/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol selectFriendFromListDelegate : class {
    func selectFriend(cell : GroupCell , indexSelect : IndexPath)
    func friendProfile(cell : GroupCell , indexSelect : IndexPath)
    
}

class GroupCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgofUser: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var btnSelect : UIButton!
    
    weak var delegate : selectFriendFromListDelegate?
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
        delegate?.selectFriend(cell: self, indexSelect: selectIndex!)
    }
    
    @IBAction private func btnProfileSelect(_ sender : UIButton) {
//        sender.isSelected = !sender.isSelected
        delegate?.friendProfile(cell: self, indexSelect: selectIndex!)
    }

}


