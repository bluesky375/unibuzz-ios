//
//  ClassifiedMoreCategoriesCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol  CategoriesListDelegate : class {
    func categoriesList(cell : ClassifiedMoreCategoriesCell)
}

class ClassifiedMoreCategoriesCell: UICollectionViewCell {
    
    weak var delegate : CategoriesListDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnMoreCategories_Pressed(_ sender: UIButton) {
        delegate?.categoriesList(cell: self)
        
    }
}
