//
//  SinglePhotoCellSender.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
protocol PreviewSenderSingleImageDelegate : class {
    func previewOneSenderImagesList(cell : SinglePhotoCellSender , index : IndexPath)
    func sendReplySingleImage(cell : SinglePhotoCellSender , checkIndex : IndexPath)
}

class SinglePhotoCellSender: UITableViewCell {
    
    @IBOutlet weak var imgOfSingle: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    weak var delegate : PreviewSenderSingleImageDelegate?
    var selectIndex : IndexPath?
    @IBOutlet weak var lblReplyMessage: UILabel!
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    @IBOutlet weak var lblForward: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SinglePhotoCellSender.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnReceiverCell(_ sender: UIButton) {
       delegate?.previewOneSenderImagesList(cell: self, index: selectIndex!)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.sendReplySingleImage(cell: self, checkIndex: selectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath, isReply: Bool) {
        guard  let message = message else { return }
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        selectIndex = indexPath
        lblReplyMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        lblForward.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        if let messageFile = message.parent_message?.messageFile, messageFile.count > 0, let file_path = messageFile[0].file_path {
            WAShareHelper.loadImage(urlstring:file_path, imageView: imgOfSingle!, placeHolder: "profile2")
        }
        if let message_files = message.message_files, message_files.count > 0, let file_path = message_files[0].file_path {
            WAShareHelper.loadImage(urlstring: file_path , imageView: imgOfSingle!, placeHolder: "profile2")
        }
        if let imgOfSenderss = message.image {
            WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
        }
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
    
}
