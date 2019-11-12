//
//  BookStoreCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol EditOrDeleteDelegate : class {
    func editOrDelete(cell : BookStoreCell , selectIndex : IndexPath)
    
}
class BookStoreCell: UITableViewCell {

    @IBOutlet weak var btnMore: UIButton!
    @IBOutlet weak var lblPrice: UILabel!

    @IBOutlet weak var imgOfBook: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var imgOfLocation: UIImageView!

    weak var delegate : EditOrDeleteDelegate?
    var indexCheck : IndexPath?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnAddMore(_ sender : UIButton) {
        delegate?.editOrDelete(cell: self, selectIndex: indexCheck!)
    }
    
}
