//
//  RecieverReplyCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol ReceiverSubReplyDelegate : class {
    func receiveSubReply(cell : RecieverReplyCell , checkIndex : IndexPath)
}

class RecieverReplyCell: UITableViewCell {
    
    @IBOutlet weak var forwardLabel: UILabel!
    @IBOutlet weak var lblParentMessage: UILabel!
    @IBOutlet weak var lblReply: UILabel!
    @IBOutlet weak var imgOfReceiver : UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var cardView: CardView!
    
    @IBOutlet weak var lblName: UILabel!
    
    weak var delegate : ReceiverSubReplyDelegate?
    @IBOutlet weak var btnReceiverReply: UIButton!
    var seelectIndex : IndexPath?
    var longGesture = UILongPressGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        btnReceiverReply.isUserInteractionEnabled = false
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(RecieverReplyCell.longPress(_:)))
        longGesture.minimumPressDuration = 0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnReplyOnReplyMessage(_ sender: UIButton) {
      
        
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.receiveSubReply(cell: self, checkIndex: seelectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath, selectedGroup: ChatList?, id: Int?, isReply: Bool) {
        guard  let message = message else { return }
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        forwardLabel.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        lblParentMessage.text = message.parent_message?.message
        seelectIndex = indexPath
        lblReply.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        cardView.isHidden = true
        if let full_name =  message.parent_message?.sender_name?.full_name {
            lblName.text = full_name
            cardView.isHidden = false
        }
        if let identity_type = selectedGroup?.identity_type, identity_type == 1 {
            if selectedGroup?.dtail?.user_id == id {
                if let imgOfSenderss = message.image {
                    WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfReceiver, placeHolder: "profile2")
                }
            }else {
                imgOfReceiver.image = UIImage(named: "anonymous_icon")
            }
        } else {
            if let imgOfSenderss = message.image {
                WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfReceiver, placeHolder: "profile2")
            }
        }
        let cgFloats: CGFloat = imgOfReceiver.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfReceiver, radius: CGFloat(someFloats))
    }
    
}
