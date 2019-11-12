//
//  FileCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class FileCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblPrevious: UILabel!
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
