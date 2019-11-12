//
//  BookOrClassifiedCell.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 24/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
protocol BookOrClassifiedSenderDetail : class {
    func bookOrClassifiedSenderDetail(cell : BookOrClassifiedCell , index : IndexPath )
    func forwardBookOrClassifiedMessage(cell : BookOrClassifiedCell , checkIndex : IndexPath)
    
}

class BookOrClassifiedCell: UITableViewCell {
    @IBOutlet weak var lblBookTitleOrClassified: UILabel!
    @IBOutlet weak var imgOfBookOrClassified: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var imgOfSender: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    
    weak var delegate : BookOrClassifiedSenderDetail?
    var selectIndex : IndexPath?
    
    @IBOutlet weak var btnSenderReply: UIButton!
    
    var longGesture = UILongPressGestureRecognizer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        longGesture = UILongPressGestureRecognizer(target: self, action: #selector(BookOrClassifiedCell.longPress(_:)))
        longGesture.minimumPressDuration =  0.2
        self.contentView.addGestureRecognizer(longGesture)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func btnSenderBookDetail(_ sender: UIButton) {
        delegate?.bookOrClassifiedSenderDetail(cell: self, index: selectIndex!)
    }
    
    
    @objc func longPress(_ sender: UILongPressGestureRecognizer) {
        if  sender.state == UIGestureRecognizer.State.ended {
            delegate?.forwardBookOrClassifiedMessage(cell: self, checkIndex: selectIndex!)
        }
    }
    
    func setUPCell(message: AllMessages?, indexPath: IndexPath ) {
        guard  let message = message else { return }
        lblBookTitleOrClassified.text = message.details?.titleOfBookOrClassified
        lblTime.text = WAShareHelper.getFormattedDate(string: (message.created_at)!)
        lblMessage.text = (message.message ?? "").count > 0 ? message.message ?? "" : ""
        selectIndex = indexPath
        guard  let imgStr = message.details?.image else { return}
        WAShareHelper.loadImage(urlstring:imgStr , imageView: imgOfBookOrClassified!, placeHolder: "profile2")
        guard  let imgOfSenderss = message.image else { return }
        WAShareHelper.loadImage(urlstring:imgOfSenderss , imageView: imgOfSender, placeHolder: "profile2")
        let cgFloats: CGFloat = imgOfSender.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(imgOfSender, radius: CGFloat(someFloats))
    }
}
