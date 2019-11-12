//
//  CompanyHeaderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class CompanyHeaderCell: UITableViewCell {
    
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblAddress : UILabel!
    
    @IBOutlet weak var companyLogo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
