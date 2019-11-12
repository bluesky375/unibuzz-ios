//
//  CVHeaderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol EditCvInfoDelegate  : class {
    func editInfo(cell : CVHeaderCell , ind : IndexPath)
}


class CVHeaderCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var lblCollegeName: UILabel!
    @IBOutlet weak var lblAboutInfo: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblLinkedProfile: UILabel!
    
    @IBOutlet weak var imgOfUser: UIImageView!
    weak var delegate : EditCvInfoDelegate?
    var index : IndexPath?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnEditInfo_Pressed(_ sender: UIButton) {
        delegate?.editInfo(cell: self, ind: index!)
    }

    
}
