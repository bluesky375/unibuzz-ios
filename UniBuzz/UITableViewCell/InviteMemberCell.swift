//
//  InviteMemberCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 07/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol CancelInvitationDelegate : class {
    func cancelInvite(cell : InviteMemberCell  , selectIndex : IndexPath)
    
}

class InviteMemberCell: UITableViewCell {

    @IBOutlet weak var lblEmail: UILabel!
    weak var delegate : CancelInvitationDelegate?
    var indexSelect : IndexPath?
    @IBOutlet weak var btnCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnCancel_Pressed(_ sender: UIButton) {
        delegate?.cancelInvite(cell: self, selectIndex: indexSelect!)
    }
}
