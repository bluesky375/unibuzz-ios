//
//  UBCreateCVVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  
class UBCreateCVVC: UIViewController {

    @IBOutlet weak var txtObjective: UITextView!
    @IBOutlet weak var txtEducation: UITextView!
    @IBOutlet weak var txtExperience: UITextView!
    @IBOutlet weak var txtSkills: UITextView!
    @IBOutlet weak var txtReference: UITextView!
    var presenter: RegistrationPresenter?
    
    var txtPhoneNum : String?
    var txtLanguage : String?
    var txtEmail : String?
    var nationality : Int?
    var txtLinkedUrl : String?
    var txtWebsiteUrl : String?
    var txtAddress : String?
    var txtAbout : String?
    var cover_image: UIImage?
    var cvObj : CVObject?
    
//    @IBOutlet weak var txtPhoneNum: UITextField!
//    @IBOutlet weak var txtLanguage: UITextField!
//    @IBOutlet weak var txtEmail: UITextField!
//    @IBOutlet weak var btnNationality: UIButton!
//    @IBOutlet weak var txtLinkedUrl: UITextField!
//    @IBOutlet weak var txtWebsiteProfile: UITextField!
//    @IBOutlet weak var txtAddress: UITextField!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtObjective.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtEducation.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtExperience.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtSkills.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtReference.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        
//        txtObjective.placeholder = "Tell the world who you are and what you good at"
//        txtEducation.placeholder = "Tell the world who you are and what you good at"
//        txtExperience.placeholder = "Tell the world who you are and what you good at"
//        txtSkills.placeholder = "Tell the world who you are and what you good at"
//        txtReference.placeholder = "Tell the world who you are and what you good at"
//        
        presenter = RegistrationPresenter(delegate: self)
//        getAllCvInfo()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("<<<<<<<<< UBCreateCVVC delloc")
    }
    
    @IBAction func btnReadyToGo_Pressed(_ sender: UIButton) {
        presenter?.cvCreateInfo(objective: "ac" , education: "ac" , exeperience: "ac", skills: "ac" , reference: "ac")
    }
    

}


extension UBCreateCVVC: RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        let params =       [ "email"                       :  txtEmail!  ,
                            "address"                      :  txtAddress! ,
                            "linkedin"                     :  txtLinkedUrl! ,
                            "nationality"                  : "\(nationality!)" ,
                            "language"                     :  txtLanguage! ,
                            "about_me"                     :  txtAbout! ,
                            "objective"                    :  txtObjective.text ?? " " ,
                            "experience"                   :  txtExperience.text ?? " " ,
                            "education"                    :  txtEducation.text ?? " " ,
                            "skills"                       :  txtSkills.text ?? " " ,
                            "references"                   :  txtReference.text ?? " " ,
                            "website"                      :  txtWebsiteUrl! ,
                            "phone"                        :  txtPhoneNum! ,
                            ] as [String : Any]
        SVProgressHUD.show()
        WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject> , serviceName: CREATECV, imageParam:"profile", imgFileName: "profile.png", serviceType: "Crate Cv".localized(), profileImage: cover_image, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()

            let responseObj = response as! UserResponse
                    if responseObj.status == true {
                        
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CVCreate"), object : nil, userInfo : nil)
                        
                        self?.showAlertViewWithTitle(title: KMessageTitle, message: responseObj.message! , dismissCompletion: {
                            
                            self?.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                    else
                    {
                        self!.showAlert(title: KMessageTitle, message: responseObj.message!, controller: self)

                    }

                }) { [weak self](error) in
                }
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}


extension UITextView{
    
    func setPlaceholder(string : String) {
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Detail...".localized()
        placeholderLabel.font = UIFont.boldSystemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 222
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (self.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(red: 173/255.0, green: 191/255.0, blue: 248/255.0, alpha: 1.0)
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
    }
    
    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(222) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
    
}

