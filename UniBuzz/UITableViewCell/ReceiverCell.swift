//
//  ReceiverCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
protocol ReciverReplyDelegate : class {
    func receiverReply(cell : ReceiverCell  , checkIndex : IndexPath)
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var lblForward: UILabel!

//    @IBOutlet weak var lblReceiverMessage: UILabel!
    @IBOutlet weak var imgOfReceiver: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    weak var delegate : ReciverReplyDelegate?
    @IBOutlet weak var btnReceiverReply: UIButton!

    @IBOutlet weak var lblReceiverMessage: UILabel!
    var seelectIndex : IndexPath?
    var longGesture = UILongPressGestureRecognizer()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction private func btnReceiverReply(_ sender : UIButton) {
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(ReceiverCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        btnReceiverReply.addGestureRecognizer(longGesture)
    }

    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
             delegate?.receiverReply(cell: self, checkIndex: seelectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath, selectedGroup: ChatList?, id: Int?) {
        guard  let message = message else { return }
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        seelectIndex = indexPath
        lblReceiverMessage.text = message.message ?? " "
        lblForward.isHidden = !(message.is_forward == 1)
       
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
