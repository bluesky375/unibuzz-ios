//
//  RecentClassifiedsCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol ClassifiedFavoriteDelegate : class {
    func classfiedFav(cell : RecentClassifiedsCell , selectIndex : IndexPath)
}


class RecentClassifiedsCell: UICollectionViewCell {

    @IBOutlet weak var imgOfUserPost: UIImageView!
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemDescription: UILabel!
    
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblPRice: UILabel!
    @IBOutlet weak var btnFav: UIButton!

    weak var delegate : ClassifiedFavoriteDelegate?
    var indexSelect : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction private func btnAddClassifiedFav(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        delegate!.classfiedFav(cell : self  , selectIndex : indexSelect!)
        
    }

}
