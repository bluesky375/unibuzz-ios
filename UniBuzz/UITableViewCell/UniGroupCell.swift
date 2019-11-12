//
//  UniGroupCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol JoinGroupOrCancelRequestDelegate : class {
    func joinOrCanelRequest(cell : UniGroupCell  , selectIndex : IndexPath)
    func acceptRequest(cell : UniGroupCell  , selectIndex : IndexPath)
    func rejectRequest(cell : UniGroupCell  , selectIndex : IndexPath)

}

class UniGroupCell: UITableViewCell {
    @IBOutlet weak var imgOfUni: UIImageView!
    @IBOutlet weak var lblUniGroupName: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var lblMEmber: UILabel!
    @IBOutlet weak var lblPost: UILabel!
    weak var delegate : JoinGroupOrCancelRequestDelegate?
    
    var checkIndex : IndexPath?
    
    @IBOutlet weak var btnJoinGroup: UIButton!
    @IBOutlet weak var requestCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        requestCountLabel.layer.cornerRadius = 10
        requestCountLabel.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func btnJoinOrCancelGroup(_ sender: UIButton) {
        delegate?.joinOrCanelRequest(cell: self, selectIndex: self.checkIndex!)
        
    }
    
    @IBAction func btnAccept_Presed(_ sender: UIButton) {
         delegate?.acceptRequest(cell: self, selectIndex: self.checkIndex!)
        
    }
    
    @IBAction func btnReject_Presed(_ sender: UIButton) {
        delegate?.rejectRequest(cell: self, selectIndex: self.checkIndex!)

        
    }

}
