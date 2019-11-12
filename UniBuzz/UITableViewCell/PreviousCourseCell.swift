//
//  PreviousCourseCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 31/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol DeleteOrEditPreviousCoruse : class {
    func deleteOrEditPreviousCourse(cell : PreviousCourseCell , isIndex : IndexPath)
    
}

class PreviousCourseCell: UITableViewCell {
    
    @IBOutlet weak var lblCourseName: UILabel!
    @IBOutlet weak var lblCourseCode: UILabel!
    @IBOutlet weak var lblProfessorName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblSemister: UILabel!
    @IBOutlet weak var lblGrade: UILabel!
    @IBOutlet weak var lblFeedBack: UILabel!
    weak var delegate : DeleteOrEditPreviousCoruse?
    var selectIndex : IndexPath?
    @IBOutlet weak var btnMoreBtnClick: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnMore_Pressed(_ sender : UIButton)  {
        delegate!.deleteOrEditPreviousCourse(cell : self , isIndex : selectIndex!)

    }
}
