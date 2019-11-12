//
//  MultiplePhotoReceiverCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

protocol PreviewTwoReceiveImageDelegate : class {
    func previewTwoImagesListReceive(cell : MultiplePhotoReceiverCell , index : IndexPath)
    func receiveReplyTwoPhoto(cell : MultiplePhotoReceiverCell , checkIndex : IndexPath)
    
}

class MultiplePhotoReceiverCell: UITableViewCell {
    
    @IBOutlet weak var imgOfItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    @IBOutlet weak var imgOfSecondItem: UIImageView!
    
    weak var delegate : PreviewTwoReceiveImageDelegate?
    var selectIndex : IndexPath?
    
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    @IBOutlet weak var lblReplyMessage: UILabel!
    
    @IBOutlet weak var lblForwardMsg: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MorePhotoCellSender.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnPreviewImages(_ sender: UIButton) {
        delegate?.previewTwoImagesListReceive(cell: self, index: selectIndex!)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.receiveReplyTwoPhoto(cell: self, checkIndex: selectIndex!)
        }
    }

    func setUPCell(message: AllMessages?, indexPath: IndexPath, selectedGroup: ChatList?, id: Int?,isReply: Bool) {
        guard  let message = message else { return }
        lblName.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        selectIndex = indexPath
        lblReplyMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        lblForwardMsg.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        var messageFile = [MessageFiles]()
        if let message = message.parent_message?.messageFile {
           messageFile = message
        }
        if let message = message.message_files {
            messageFile = message
        }
        WAShareHelper.loadImage(urlstring:messageFile[0].file_path!, imageView: imgOfItem!, placeHolder: "profile2")
        WAShareHelper.loadImage(urlstring:messageFile[1].file_path!, imageView: imgOfSecondItem!, placeHolder: "profile2")
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
