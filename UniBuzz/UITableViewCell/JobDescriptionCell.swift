//
//  JobDescriptionCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class JobDescriptionCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
