//
//  CourseCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 10/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol AddOrRemoveUserDelegate : class {
    func addremoveUser(cell : CourseCell  , selectIndex : IndexPath)
    
}

class CourseCell: UITableViewCell {
    
    @IBOutlet weak var lblCourseName : UILabel!
    weak var delegate : AddOrRemoveUserDelegate?
    var indexSelect : IndexPath?
    @IBOutlet weak var btnRemove : UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnAddOrRemoveUser(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        
        delegate?.addremoveUser(cell: self, selectIndex: indexSelect!)

    }

}
