//
//  AppliedJobsCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol AppliedJobDelegate : class {
    func jobDetail(cell : AppliedJobsCell , selectIndex : IndexPath)
}

class AppliedJobsCell: UITableViewCell {
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblIsJobOpen: UILabel!
    @IBOutlet weak var lblJobType: UILabel!
    @IBOutlet weak var lblJobStatus: UILabel!
    @IBOutlet weak var lblCoverLetter: UILabel!
    @IBOutlet weak var viewOfJobStatus: CardView!
    weak var delegate : AppliedJobDelegate?
    var checkIndex : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnJobDetail(_ sender : UIButton) {
        delegate?.jobDetail(cell: self, selectIndex: checkIndex!)
    }
    
}
