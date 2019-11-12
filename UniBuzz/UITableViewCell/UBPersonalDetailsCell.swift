//
//  UBPersonalDetailsCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol UBPersonalDetailsCellDelegate:class {
    func editProfileAction()
    func addPrimaryEmail(cell : UBPersonalDetailsCell)
    func referalCode(cell : UBPersonalDetailsCell)
}

class UBPersonalDetailsCell: UITableViewCell {

    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    
    @IBOutlet weak var lblCollegeName: UILabel!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblMobileNum: UILabel!
    
    @IBOutlet weak var lblJoinedDate: UILabel!
    
    @IBOutlet weak var lblPrimaryEmail: UILabel!
    @IBOutlet weak var btnEmail: UIButton!

    @IBOutlet weak var lblReferalCode: UILabel!
    //Variables
    weak var delegate: UBPersonalDetailsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func editProfileAction(_ sender: AnyObject) {
        self.delegate?.editProfileAction()
    }
    
    @IBAction private func btnAddPrimaryEmail(_ sender: AnyObject) {
        self.delegate?.addPrimaryEmail(cell: self)
        
    }
    
    @IBAction private func btnReferalCode_Pressed(_ sender : UIButton) {
        delegate?.referalCode(cell: self)
    }
    
}
