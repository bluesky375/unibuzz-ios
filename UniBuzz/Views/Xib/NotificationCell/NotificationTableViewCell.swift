//
//  NotificationTableViewCell.swift
//  UniBuzz
//
//  Created by unibuss on 29/10/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = 30
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setUpCell(model: IData) {
        if let image = model.posted_by?.profile_image {
            WAShareHelper.loadImage(urlstring: image , imageView: profileImageView, placeHolder: "profile2")
            userNameLabel.text = "\(model.posted_by?.first_name ?? "") \(model.posted_by?.last_name ?? "")"
        }
        desLabel.text = model.comment
        if let type = model.type {
            statusImageView.image = UIImage(named: "type\(type)")
        }
        if let created_at = model.created_at {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let dateValue = dateFormatter.date(from: created_at) {
                dateFormatter.dateFormat = "dd MMM yyyy"
                let date = dateFormatter.string(from: dateValue)
                dateFormatter.dateFormat = "hh:mm a"
                let time = dateFormatter.string(from: dateValue)
                dateAndTimeLabel.text = "\(date)\n\(time)"
            }
        }
        
    }
}
