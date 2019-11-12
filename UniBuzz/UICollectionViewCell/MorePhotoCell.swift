//
//  MorePhotoCell.swift
//  GARAGE SALE
//
//  Created by Ahmed Durrani on 25/01/2019.
//  Copyright © 2019 TeachEase Solution. All rights reserved.
//

import UIKit

protocol CancelImageDelegate: class {
    func crossImage(cell : MorePhotoCell , index : IndexPath)
}

class MorePhotoCell: UICollectionViewCell {
    @IBOutlet var imagePhoto: UIImageView!
    weak var delegate : CancelImageDelegate?
    var indexSelect : IndexPath?
    @IBOutlet var removebutton: UIButton!

    
    @IBAction private func btnCross(_ sernder : UIButton) {

        delegate?.crossImage(cell: self, index: indexSelect!)

    }
    
}
