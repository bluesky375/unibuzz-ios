//
//  UBReferalCodeVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 10/10/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBReferalCodeVC: UIViewController {

    @IBOutlet weak var lblReferealCode: MyVerticalLabel!
    var userObj : Session?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblReferealCode.text =  userObj?.referral_code
//        lblReferealCode.text = "M12D3456WW"
//        let revered = String((userObj?.referral_code?.reversed())!)
//        lblReferealCode.text = revered
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

@IBDesignable
class MyVerticalLabel: UILabel {

    override func draw(_ rect: CGRect) {
        guard let text = self.text else {
            return
        }

        // Drawing code
        if let context = UIGraphicsGetCurrentContext() {
            let transform = CGAffineTransform( rotationAngle: CGFloat(-Double.pi/2))
            context.concatenate(transform)
            context.translateBy(x: -rect.size.height, y: 0)
            var newRect = rect.applying(transform)
            newRect.origin = CGPoint.zero

            let textStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            textStyle.lineBreakMode = self.lineBreakMode
            textStyle.alignment = self.textAlignment

            let attributeDict: [NSAttributedString.Key: AnyObject] = [NSAttributedString.Key.font: self.font, NSAttributedString.Key.foregroundColor: self.textColor, NSAttributedString.Key.paragraphStyle: textStyle]

            let nsStr = text as NSString
            nsStr.draw(in: newRect, withAttributes: attributeDict)
        }
    }


}
