//
//  CategorieHeaderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 18/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol CategorieCellDelegate : class {
    func categorieSelect(cell : CategorieHeaderCell , selectIndex : IndexPath)
}


class CategorieHeaderCell: UITableViewCell {
    weak var delegate : CategorieCellDelegate?
    var indexSelect : IndexPath?
    
    @IBOutlet weak var btnCategorie: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnSelectCategories(_ sender : UIButton) {
        delegate?.categorieSelect(cell: self, selectIndex: indexSelect!)
        
    }
    
}
