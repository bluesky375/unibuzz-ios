//
//  BookOrClassifiedReceiverCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
protocol BookOrClassifiedReceiverDetail : class {
    func bookOrClassifiedDetail(cell : BookOrClassifiedReceiverCell , index : IndexPath )
    func forwardBookOrClassifiedReceiverMessage(cell : BookOrClassifiedReceiverCell , checkIndex : IndexPath)
    
}

class BookOrClassifiedReceiverCell: UITableViewCell {
    
    @IBOutlet weak var lblBookTitleOrClassified: UILabel!
    @IBOutlet weak var imgOfBookOrClassified: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    weak var delegate : BookOrClassifiedReceiverDetail?
    var selectIndex : IndexPath?
    
    @IBOutlet weak var btnSenderReply: UIButton!
    var longGesture = UILongPressGestureRecognizer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(BookOrClassifiedReceiverCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnReceiverBookDetail(_ sender: UIButton) {
       delegate?.bookOrClassifiedDetail(cell: self, index: selectIndex!)
    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.forwardBookOrClassifiedReceiverMessage(cell: self, checkIndex: selectIndex!)
        }
    }

    func setUPCell(message: AllMessages?, indexPath: IndexPath, selectedGroup: ChatList?, id: Int?) {
        guard  let message = message else { return }
        lblBookTitleOrClassified.text = message.details?.titleOfBookOrClassified
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        lblMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        selectIndex = indexPath
        guard  let imgStr = message.details?.image else { return}
        WAShareHelper.loadImage(urlstring:imgStr , imageView: imgOfBookOrClassified!, placeHolder: "profile2")
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
