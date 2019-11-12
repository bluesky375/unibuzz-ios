//
//  SinglePhotoReceiverCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

protocol PreviewOneReceiveImageDelegate : class {
    func previewOneImagesListReceive(cell : SinglePhotoReceiverCell , index : IndexPath)
    func reciverReplySingleImage(cell : SinglePhotoReceiverCell , checkIndex : IndexPath)
    
}

class SinglePhotoReceiverCell: UITableViewCell {
    
    @IBOutlet weak var imgOfItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    weak var delegate : PreviewOneReceiveImageDelegate?
    var selectIndex : IndexPath?
    
    @IBOutlet weak var lblReplyMessage: UILabel!
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    
    @IBOutlet weak var lblForward: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SinglePhotoReceiverCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnPreviewImages(_ sender: UIButton) {
        delegate?.previewOneImagesListReceive(cell: self, index: selectIndex!)
        
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .ended {
            delegate?.reciverReplySingleImage(cell: self, checkIndex: selectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath, selectedGroup: ChatList?, id: Int?, isReply: Bool) {
        guard  let message = message else { return }
        lblName.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        selectIndex = indexPath
        lblReplyMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        lblForward.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        if  let messageFile  = message.parent_message?.messageFile, messageFile.count > 0, let imgOfSender  = messageFile[0].file_path {
            WAShareHelper.loadImage(urlstring:imgOfSender , imageView: imgOfItem!, placeHolder: "profile2")
        }
        
        if let message_files =  message.message_files, message_files.count > 0,  let imgOfSender  = message_files[0].file_path {
            WAShareHelper.loadImage(urlstring:imgOfSender , imageView: imgOfItem!, placeHolder: "profile2")
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
