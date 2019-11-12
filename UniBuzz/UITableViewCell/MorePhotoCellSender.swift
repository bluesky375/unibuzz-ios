//
//  MorePhotoCellSender.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
protocol PreviewMoreSenderImageDelegate : class {
    func previewMoreImagesList(cell : MorePhotoCellSender , index : IndexPath)
    func sendReplyMoreImageList(cell : MorePhotoCellSender , checkIndex : IndexPath)
    
}

class MorePhotoCellSender: UITableViewCell {
    @IBOutlet weak var imgOfSender1: UIImageView!
    @IBOutlet weak var imgOfSender2: UIImageView!
    @IBOutlet weak var imgOfSender3: UIImageView!
    @IBOutlet weak var imgOfSender4: UIImageView!
    
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    @IBOutlet weak var lblReplyMessage: UILabel!
    weak var delegate : PreviewMoreSenderImageDelegate?
    var selectIndex : IndexPath?
    @IBOutlet weak var lblForward: UILabel!
    
    @IBOutlet weak var moreLabel: UILabel!
    
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
        delegate?.previewMoreImagesList(cell: self, index: selectIndex!)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.sendReplyMoreImageList(cell: self, checkIndex: selectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath, isReply: Bool) {
        guard  let message = message else { return }
        lblTime.text = WAShareHelper.getFormattedDate(string: message.created_at!)
        lblForward.text = message.is_forward == 1 ? "Forwarded".localized() : "".localized()
        selectIndex = indexPath
        lblReplyMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        var messageFile = [MessageFiles]()
        if let message = message.message_files {
            messageFile = message
        }
        if let message = message.parent_message?.messageFile {
            messageFile = message
        }
        WAShareHelper.loadImage(urlstring:messageFile[0].file_path!, imageView: imgOfSender1!, placeHolder: "profile2")
        WAShareHelper.loadImage(urlstring:messageFile[1].file_path!, imageView: imgOfSender2!, placeHolder: "profile2")
        WAShareHelper.loadImage(urlstring:messageFile[2].file_path!, imageView: imgOfSender3!, placeHolder: "profile2")
        moreLabel.isHidden = !(messageFile.count > 4)
        moreLabel.text = "+\(messageFile.count - 4)"
        if messageFile.count > 3 {
            WAShareHelper.loadImage(urlstring:messageFile[3].file_path!, imageView: imgOfSender4!, placeHolder: "profile2")
        }
        if let imgOfSenderss = message.image {
            WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
        }
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
}
