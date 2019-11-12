//
//  FooterMyAccountCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol FooterMyAccountCellDelegate:class {
    func myGPAAction()
    func myCVAction()
    func myCoursesAction()
}

class FooterMyAccountCell: UITableViewCell {
    
    weak var delegate: FooterMyAccountCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func myGPAAction() {
        self.delegate?.myGPAAction()
    }
    
    @IBAction func myCVAction() {
        self.delegate?.myCVAction()
    }
    
    @IBAction func myCoursesAction() {
        self.delegate?.myCoursesAction()
    }
    
}
