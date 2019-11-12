//
//  SolutionCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 12/10/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import iosMath

class SolutionCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var viewOfQuestion: MTMathUILabel!
    @IBOutlet weak var lblSubCategoriName: UILabel!
    @IBOutlet weak var lblQuestionType: UILabel!

    @IBOutlet weak var viewOfHeader: CardView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
