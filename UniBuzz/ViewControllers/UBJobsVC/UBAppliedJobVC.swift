//
//  UBAppliedJobVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
//import GrowingTextView
import SVProgressHUD
  
class UBAppliedJobVC: UIViewController {
    
    @IBOutlet weak var lblJobTitle: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    var bookDetail : JobList?

    @IBOutlet weak var txtCoverLetter: UITextView!
    @IBOutlet weak var btnUSeMyCv : UIButton!
    @IBOutlet weak var btnUploadNewCV : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblJobTitle.text = bookDetail?.titleOfJob
        lblCompanyName.text = bookDetail?.company?.companyInfo?.company_name
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtCoverLetter.layer, width: 1.0, radius: 5.0, color: UIColor.groupTableViewBackground)
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func  btnUseMyCv(_ sender : UIButton) {
//        sender.isSelected = !sender.isSelected
        btnUSeMyCv.isSelected = true
//        btnUploadNewCV.isSelected = false
    }

    @IBAction private func  btnUploadNewCv(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        btnUSeMyCv.isSelected = false
        btnUploadNewCV.isSelected = true
    }
    
    @IBAction private func  btnAppliedForJob(_ sender : UIButton) {
        
        if txtCoverLetter.text.count < 10 {
            self.showAlert(title: KMessageTitle, message: "Cover Letter must not be less than 10 characters".localized(), controller: self)
        } else if txtCoverLetter.text.count > 1000 {
            self.showAlert(title: KMessageTitle, message: "Cover Letter must not be greater than 13 characters".localized(), controller: self)
        } else {
        let jobID = bookDetail?.id
                let params =       [ "job_id"                             :   "\(jobID!)"  ,
                                     "cover_letter"                       :  txtCoverLetter.text ?? " ",
                                   ] as [String : Any]
        SVProgressHUD.show()
        var imge : UIImage?
        WebServiceManager.mutliChat(params: params as Dictionary<String, AnyObject> , serviceName: APPLIEDJOB, imageParam:"resume", imgFileName: "resume.png", serviceType: "", profileImage: imge  , cover_image_param: "", cover_image: nil , modelType: MessageObject.self, success: {[weak self] (response) in
            if  let post = response as? MessageObject {
                if post.status == true {
//                    self?.navigationController?.popViewController(animated: true)
                    self?.navigationController?.popToRootViewController(animated: true)
                }
                    
                else
                {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
                
            }}) { [weak self] (error) in
            }
          }
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
