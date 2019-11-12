//
//  CourseAddCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class CourseAddCell: UITableViewCell {

    @IBOutlet weak var txtCourseName: UITextField!
    
    @IBOutlet weak var txtCourseCode: UITextField!
    @IBOutlet weak var txtCreditHour: UITextField!
    @IBOutlet weak var lblChoseWekkDay: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
