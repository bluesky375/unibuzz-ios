//
//  ChoseWeekDaysCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol WeekDaysDelegate : class {
    func daySelect(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int)
    func timeFromOrToSelect(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int)
    func timeToSelect(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int)

    func deleteCell(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int)

}

class ChoseWeekDaysCell: UITableViewCell {

    @IBOutlet weak var btnselectTimeTo: UIButton!
    @IBOutlet weak var btnselectTimeFrom : UIButton!
    @IBOutlet weak var btnselectDay: UIButton!
    @IBOutlet weak var btnCross: UIButton!

    weak var delegate : WeekDaysDelegate?
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
    
    @IBAction func btnCross_Pressed(_ sender: UIButton) {
         delegate?.deleteCell(cell: self, indexS: indexSelect! , section: selectSect!)
    }
    @IBAction func btnSelectDay_Pressed(_ sender: UIButton) {
        delegate?.daySelect(cell: self, indexS : indexSelect! , section: selectSect!)

    }
    
    @IBAction func btnSelectTimeFrom_Pressed(_ sender: UIButton) {
        delegate?.timeFromOrToSelect(cell: self, indexS : indexSelect! , section: selectSect!)

    }
    
    @IBAction func btnSelectTimeTo(_ sender: UIButton) {
        delegate?.timeToSelect(cell: self, indexS : indexSelect! , section: selectSect!)

    }
    
}
