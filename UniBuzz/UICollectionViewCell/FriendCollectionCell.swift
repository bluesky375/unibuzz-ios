//
//  FriendCollectionCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 25/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol RemoveFriendDelegate : class {
    func removeItem(cell : FriendCollectionCell , selectIndex : IndexPath)
}

class FriendCollectionCell: UICollectionViewCell {
    
    weak var delegate : RemoveFriendDelegate?
    var indexSelect : IndexPath?
    
    @IBOutlet weak var imgOfFriend: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func btnCross_pressed(_ sender: UIButton) {
        self.delegate?.removeItem(cell: self, selectIndex: indexSelect!)
        
    }
    
}
