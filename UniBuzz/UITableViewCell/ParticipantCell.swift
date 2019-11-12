//
//  ParticipantCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol AddParticipantDelegate : class {
    func RemoveParticipant(cell : ParticipantCell , selectIndex : IndexPath)
    
}

class ParticipantCell: UITableViewCell {
    
    @IBOutlet weak var imgOfUser: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var btnAdmin: UIButton!
    @IBOutlet weak var btnRemoveParticipant: UIButton!
    weak var delegate : AddParticipantDelegate?
    var selectIndex : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnRemoveParticipant_Pressed(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
        delegate?.RemoveParticipant(cell: self, selectIndex: selectIndex!)
        
    }
    
}
