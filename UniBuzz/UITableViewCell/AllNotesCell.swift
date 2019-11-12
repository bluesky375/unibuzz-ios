//
//  AllNotesCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 03/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import Cosmos
protocol BookMarkNotesDeelegate : class {
    func addedToBookMarked(cell : AllNotesCell  , index : IndexPath )
}

class AllNotesCell: UITableViewCell {

    @IBOutlet weak var lblNoteCode: UILabel!
    @IBOutlet weak var lblCourseTitle: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblIsReviewQuestion: UILabel!
    @IBOutlet weak var lblSubjectOfNote: UILabel!
    @IBOutlet weak var lblSemisterOfNotes: UILabel!
    @IBOutlet weak var viewOfRating: CosmosView!
    @IBOutlet weak var imgOfUni: UIImageView!
    @IBOutlet weak var imgOFType: UIImageView!
    
    @IBOutlet weak var btnSave: UIButton!

    @IBOutlet weak var viewOfHeader: UIView!
    @IBOutlet weak var btnIsSave: UIButton!
    weak var delegate : BookMarkNotesDeelegate?
    var selectIndex  : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnIsAddToBookMark_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.addedToBookMarked(cell: self , index: selectIndex!)
    }
}
