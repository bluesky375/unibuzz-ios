//
//  AllJobCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol JobFavoruiteDelegate : class {
    func jobfav(cell : AllJobCell , selectIndex : IndexPath)
    func jobDetail(cell : AllJobCell , selectIndex : IndexPath)
}

class AllJobCell: UITableViewCell {
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblJobType: UILabel!
    @IBOutlet weak var lblNationality: UILabel!
    
    @IBOutlet weak var lblSaalaryRange: UILabel!
    
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var lblJobCategori: UILabel!
    @IBOutlet weak var lblDatePosted: UILabel!
    
    @IBOutlet weak var companyLogo: UIImageView!
    @IBOutlet weak var btnFav: UIButton!
    
    weak var delegate : JobFavoruiteDelegate?
    var checkIndex : IndexPath?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func btnIsFavOrUnFav_PRessed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        delegate?.jobfav(cell: self, selectIndex: checkIndex!)
    }
    
    @IBAction private func btnJobDetail(_ sender : UIButton) {
        delegate?.jobDetail(cell: self, selectIndex: checkIndex!)
        
    }
    
}


