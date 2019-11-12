//
//  HeaderOJobCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol CompanyInfoDelegate : class {
    func companyDetail(cell : HeaderOJobCell )
}
class HeaderOJobCell: UITableViewCell {
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblJobType: UILabel!
    @IBOutlet weak var lblSaalaryRange: UILabel!
    @IBOutlet weak var lblJobAddress: UILabel!
    
    @IBOutlet weak var companyLogo: UIImageView!
    weak var delegate : CompanyInfoDelegate?
    
    @IBOutlet weak var lblPostedDate: UILabel!
    @IBOutlet weak var lblExpiryDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCompanyDetail_Pressed(_ sender: UIButton) {
        delegate?.companyDetail(cell: self)
    }
}
