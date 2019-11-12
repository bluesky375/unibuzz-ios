//
//  MorePhotoReceiverCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
protocol PreviewImageDelegate : class {
    func previewImageList(cell : MorePhotoReceiverCell , index : IndexPath)
    func receiverMorePhot(cell : MorePhotoReceiverCell , checkIndex : IndexPath)
    
}

class MorePhotoReceiverCell: UITableViewCell {
    
    @IBOutlet weak var imgOfSender1: UIImageView!
    @IBOutlet weak var imgOfSender2: UIImageView!
    @IBOutlet weak var imgOfSender3: UIImageView!
    @IBOutlet weak var imgOfSender4: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    weak var delegate : PreviewImageDelegate?
    var selectIndex : IndexPath?
    
    @IBOutlet weak var lblReplyMessage: UILabel!
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    @IBOutlet weak var lblForwardMssg: UILabel!
    @IBOutlet weak var moreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MorePhotoReceiverCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnPreviewImage(_ sender: UIButton) {
        delegate?.previewImageList(cell: self, index: selectIndex!)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.receiverMorePhot(cell: self, checkIndex: selectIndex!)
        }
    }

    func setUPCell(message: AllMessages?, indexPath: IndexPath, selectedGroup: ChatList?, id: Int?, isReply: Bool) {
        guard  let message = message else { return }
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        selectIndex = indexPath
        lblReplyMessage.text = (message.message ?? "").count > 0 ? message.message ?? "".localized() : "".localized()
        lblForwardMssg.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        var messageFile = [MessageFiles]()
        if let message = message.parent_message?.messageFile {
            messageFile = message
        }
        if let message = message.message_files {
            messageFile = message
        }
        WAShareHelper.loadImage(urlstring:messageFile[0].file_path!, imageView: imgOfSender1!, placeHolder: "profile2")
        WAShareHelper.loadImage(urlstring:messageFile[1].file_path!, imageView: imgOfSender2!, placeHolder: "profile2")
        WAShareHelper.loadImage(urlstring:messageFile[1].file_path!, imageView: imgOfSender3!, placeHolder: "profile2")
        moreLabel.isHidden = !(messageFile.count > 4)
        moreLabel.text = "+\(messageFile.count - 4)"
        if messageFile.count > 3 {
            WAShareHelper.loadImage(urlstring:messageFile[3].file_path!, imageView: imgOfSender4!, placeHolder: "profile2")
        }
        if let identity_type = selectedGroup?.identity_type, identity_type == 1 {
            if selectedGroup?.dtail?.user_id == id {
                if let imgOfSenderss = message.image {
                    WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
                }
            }else {
                imgOfSender.image = UIImage(named: "anonymous_icon")
            }
        } else {
            if let imgOfSenderss = message.image {
                WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
            }
        }
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
}
