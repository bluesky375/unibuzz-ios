//
//  CurrentCourseHeaderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol CurrentCourseDelegate : class {
    func selectCourse(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int)
    func selectProfessor(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int)
    func selectYear(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int)
    func selectSemister(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int)
    func selectCouldNotFindLoc(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int)


}
class CurrentCourseHeaderCell: UITableViewCell {

    @IBOutlet weak var lblWeekDays: UILabel!
    @IBOutlet weak var txtLocation: UITextField!
    weak var delegate : CurrentCourseDelegate?
    var indexSelect : IndexPath?
    var selectSect : Int?
    @IBOutlet weak var btnCourse: UIButton!
    
    @IBOutlet weak var btnselectCourse: UIButton!
    @IBOutlet weak var btnSelectProfessor : UIButton!
    @IBOutlet weak var btnselectYear: UIButton!
    @IBOutlet weak var btnSelectSemister: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func btnSelectCourse_Pressed(_ sender: UIButton) {
        delegate?.selectCourse(cell: self, index: indexSelect! , section: selectSect!)
    }
    
    @IBAction func btnSelectProfessor_Pressed(_ sender: UIButton) {
        delegate?.selectProfessor(cell: self, index: indexSelect! , section: selectSect!)

        
    }
    
    @IBAction func btnSelectYear_Pressed(_ sender: UIButton) {
        delegate?.selectYear(cell: self, index: indexSelect! , section: selectSect!)

    }
    
    @IBAction func btnSemister_Pressed(_ sender: UIButton) {
        delegate?.selectSemister(cell: self, index: indexSelect! , section: selectSect!)

    }
    @IBAction func btnCouldntFindLocation_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.selectCouldNotFindLoc(cell: self, index: indexSelect! , section: selectSect!)

    }
}
