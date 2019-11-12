//
//  ChatListCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import BadgeSwift
class ChatListCell: UITableViewCell {
    
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblNAme: UILabel!
    @IBOutlet weak var lblMessage: UILabel!

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgOfCam: UIImageView!
    @IBOutlet weak var imgOfLastSeen: UIImageView!
    @IBOutlet weak var heightOfCam : NSLayoutConstraint!
    @IBOutlet weak var widthOfCameraIcon: NSLayoutConstraint!
    
    @IBOutlet weak var lblBadgeCount: BadgeSwift!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
