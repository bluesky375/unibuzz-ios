//
//  SenderReplyCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol SenderSubReplyDelegate : class {
    func sendSubReply(cell : SenderReplyCell , checkIndex : IndexPath)
}

class SenderReplyCell: UITableViewCell {
    
    @IBOutlet weak var forwardLabel: UILabel!
    @IBOutlet weak var lblParentMessage: UILabel!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var lblName: UILabel!
    weak var delegate : SenderSubReplyDelegate?
    @IBOutlet weak var btnSenderReply: UIButton!
    var seelectIndex : IndexPath?
    var longGesture = UILongPressGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnSenderReply.isUserInteractionEnabled = false
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(RecieverReplyCell.longPress(_:)))
        longGesture.minimumPressDuration = 0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnReplyOnReplyMessage(_ sender: UIButton) {

    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.sendSubReply(cell: self, checkIndex: seelectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath) {
        guard  let message = message else { return }
        cardView.isHidden = true
        forwardLabel.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        if let full_name =  message.parent_message?.sender_name?.full_name {
            lblName.text = full_name
            cardView.isHidden = false
        }
        lblParentMessage.text = message.parent_message?.message
        lblTime.text = WAShareHelper.getFormattedDate(string: message.created_at!)
        seelectIndex = indexPath
        lblReply.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        if let imgOfSenderss = message.image {
            WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
        }
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
}
