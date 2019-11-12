//
//  AcceptRejectRequestCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 07/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol AcceptRejectDelegate : class {
    func acceptRequest(cell : AcceptRejectRequestCell , index : IndexPath)
    func rejectRequest(cell : AcceptRejectRequestCell , index : IndexPath)

}
class AcceptRejectRequestCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgOfUser: UIImageView!
    weak var delegate : AcceptRejectDelegate?
    var selectIndex : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAccept_Pressed(_ sender: UIButton) {
        delegate?.acceptRequest(cell: self, index: selectIndex!)
    }
    @IBAction func btnReject_Pressed(_ sender: UIButton) {
        delegate?.rejectRequest(cell: self, index: selectIndex!)

    }
    
    
}
