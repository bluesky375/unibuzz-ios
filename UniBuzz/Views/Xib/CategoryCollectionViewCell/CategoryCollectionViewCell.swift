//
//  CategoryCollectionViewCell.swift
//  UniBuzz
//
//  Created by MobikasaNight on 29/10/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var categoryCountLabel: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var imageView: UIImageView!
    static let cellIdentifier = "CategoryCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        categoryCountLabel.layer.cornerRadius = 10
        categoryCountLabel.clipsToBounds = true
        // Initialization code
    }
    
    func setUpCell(model: Categories, baseURL: String) {
        if let image = model.icon {
            let url = "\(baseURL)/\(image)"
            WAShareHelper.loadImage(urlstring: url , imageView: imageView, placeHolder: "profile2")
        }
        titleLabel.text = AppDelegate.isArabic() ? model.name_ar : model.name
        if let count = model.category_notes_count {
            categoryCountLabel.text = "\(count)"
        }
    }
    
}
