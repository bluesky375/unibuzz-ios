//
//  GroupInfoHeaderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class GroupInfoHeaderCell: UITableViewCell {
    
    @IBOutlet weak var imgOfGroup: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var lblTotalParticipant: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
