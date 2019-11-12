//
//  AvatarCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 06/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var imgOfAvatar: UIImageView!

    override func awakeFromNib() {
        layer.cornerRadius = 5
        layer.masksToBounds = true
    }

}
