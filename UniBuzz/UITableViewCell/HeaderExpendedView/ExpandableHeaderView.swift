//
//  ExpandableHeaderView.swift
//  ExpendableView
//

import UIKit

protocol ExpandableHeaderViewDelegate {
    func toggleSection(header: ExpandableHeaderView, section: Int)
}
typealias Handler = (_ header: ExpandableHeaderView, _ section: Int)->()
class ExpandableHeaderView: UITableViewHeaderFooterView {
    var delegate: ExpandableHeaderViewDelegate?
    var section : Int!
    @IBOutlet weak var ImageOfProduct: UIImageView!
    @IBOutlet weak var lblProductName: UILabel!
    var handler: Handler?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectHeaderAction)))

        
    }
    
    
    @objc func selectHeaderAction(gestureRecognizer: UITapGestureRecognizer) {
        let cell = gestureRecognizer.view as! ExpandableHeaderView
        if let handler = self.handler {
            handler(self, cell.section)
        }
        //delegate?.toggleSection(header: self, section: cell.section)
    }
    
    func customInit(title: String, section: Int, image : String , handler: @escaping Handler){
        self.handler = handler
        self.lblProductName?.text = title
        self.section = section
        self.ImageOfProduct.image = UIImage(named: image)
        self.ImageOfProduct.contentMode = .scaleAspectFit
        self.backgroundView?.backgroundColor = UIColor.clear
//        ImageOfProduct.image = UIImage(named: "angry-selected")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.lblProductName?.textColor = UIColor.white
        self.contentView.backgroundColor = UIColor.white
    }

}
