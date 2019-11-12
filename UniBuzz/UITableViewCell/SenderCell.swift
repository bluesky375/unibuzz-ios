//
//  SenderCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol SenderReplyDelegate : class {
    func sendReply(cell : SenderCell , checkIndex : IndexPath)
}

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var lblForward: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    weak var delegate : SenderReplyDelegate?
    //    @IBOutlet weak var lblMessage: UILabel!
    
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var btnSenderReply: UIButton!
    var seelectIndex : IndexPath?
    var longGesture = UILongPressGestureRecognizer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
        //        self.contentView.addGestureRecognizer(longPressRecognizer)
        
        // Configure the view for the selected state
    }
    
    //    @objc func longPressed(sender: UILongPressGestureRecognizer) {
    //           print("Ahmad")
    //       }
    //
    
    
    @IBAction func btnSenderReply(_ sender: UIButton) {
        print("hi")
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SenderCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        btnSenderReply.addGestureRecognizer(longGesture)
        
        
        
        
    }
    
    //    @IBAction private func btnSenderReply(_ sender : UILongPressGestureRecognizer) {
    ////        sender.minimumPressDuration = 1.5
    ////            print("Ahmad")
    //
    //        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(SenderCell.longPress(_:)))
    //        longGesture.minimumPressDuration = 0.5
    //        btnSenderReply.addGestureRecognizer(longGesture)
    //
    ////        if sender.state == UIGestureRecognizer.State.ended {
    ////             print("Ahmad")
    //////            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender:)))
    //////            longPress.minimumPressDuration = 0.5
    //////            self.btnSenderReply.addGestureRecognizer(longPress)
    ////
    ////        }
    //
    ////
    //    }
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.sendReply(cell: self, checkIndex: seelectIndex!)
        }
    }
    
    //    @objc func singlePress(_ sender: UITapGestureRecognizer) {
    //           if  sender.state == UIGestureRecognizer.State.ended {
    //               delegate?.sendReply(cell: self, checkIndex: seelectIndex!)
    //           }
    //       }
    
    //    @objc func longPressed(sender: UILongPressGestureRecognizer) {
    //         print("Ahmad")
    //    }
    
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath, isReply: Bool) {
        guard  let message = message else { return }
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        lblMessage.text = message.message
        lblForward.isHidden = !(message.is_forward == 1)
        seelectIndex = indexPath
        guard  let imgOfSenderss = message.image else { return }
        WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
    
}
