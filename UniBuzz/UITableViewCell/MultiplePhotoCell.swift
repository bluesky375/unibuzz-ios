//
//  MultiplePhotoCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

protocol PreviewSenderImageDelegate : class {
    func previewTwoImagesList(cell : MultiplePhotoCell , index : IndexPath)
    func sendReplyImage(cell : MultiplePhotoCell , checkIndex : IndexPath)
    
}

class MultiplePhotoCell: UITableViewCell {
    
    @IBOutlet weak var imgOfItem: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    @IBOutlet weak var imgOfSecondItem: UIImageView!
    weak var delegate : PreviewSenderImageDelegate?
    var selectIndex : IndexPath?
    @IBOutlet weak var lblReplyMessage: UILabel!
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    @IBOutlet weak var lblForwardMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(MultiplePhotoCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    @IBAction func btnPreviewImages(_ sender: UIButton) {
        delegate?.previewTwoImagesList(cell: self, index: selectIndex!)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.sendReplyImage(cell: self, checkIndex: selectIndex!)
        }
    }

    func setUPCell(message: AllMessages?, indexPath: IndexPath, isReply: Bool) {
        guard  let message = message else { return }
        lblName.text = WAShareHelper.getFormattedDate(string: message.created_at!)
        lblForwardMsg.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        selectIndex = indexPath
        lblReplyMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        var messageFile = [MessageFiles]()
        
        if let message = message.parent_message?.messageFile, messageFile.count == 2 {
            messageFile = message
        }
        if let message = message.message_files, messageFile.count == 2 {
            messageFile = message
        }
        WAShareHelper.loadImage(urlstring:messageFile[0].file_path!, imageView: imgOfItem!,  placeHolder: "profile2")
        WAShareHelper.loadImage(urlstring:messageFile[1].file_path!, imageView: imgOfSecondItem!, placeHolder: "profile2")
        
        if let imgOfSender  = message.parent_message?.messageFile?[0].file_path {
            WAShareHelper.loadImage(urlstring:imgOfSender , imageView: imgOfItem!, placeHolder: "profile2")
        }
        if let imgOfSender  = message.message_files?[0].file_path {
            WAShareHelper.loadImage(urlstring:imgOfSender , imageView: imgOfItem!, placeHolder: "profile2")
        }
        if let imgOfSenderss = message.image {
            WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
        }
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
}
