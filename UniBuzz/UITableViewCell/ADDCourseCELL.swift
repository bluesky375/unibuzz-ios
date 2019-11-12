//
//  ADDCourseCELL.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol AddCellDelegate : class {
    func addCellDelegate(cell : ADDCourseCELL  , indexSelect : IndexPath , sec : Int )
}
class ADDCourseCELL: UITableViewCell {
    
    weak var delegate : AddCellDelegate?
    var indexSelect : IndexPath?
    var selectSect : Int?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnAddDay_Pressed(_ sender: UIButton) {
        delegate?.addCellDelegate(cell: self, indexSelect: indexSelect! , sec: selectSect!)

    }
    
}
