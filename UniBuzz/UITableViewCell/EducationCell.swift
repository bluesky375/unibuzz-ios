//
//  EducationCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol EditSkillsObjectiveDelegate : class {
    func editSkills(cell : EducationCell , ind : IndexPath)
}
class EducationCell: UITableViewCell {

    @IBOutlet weak var imgOfIcon: UIImageView!
    @IBOutlet weak var lblDetailText: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    
    weak var delegate : EditSkillsObjectiveDelegate?
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
        delegate?.editSkills(cell: self, ind: index!)
    }
}
