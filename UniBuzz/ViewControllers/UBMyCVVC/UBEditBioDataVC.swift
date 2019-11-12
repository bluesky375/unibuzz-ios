//
//  UBEditBioDataVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  

class UBEditBioDataVC: UIViewController {
    
    @IBOutlet weak var txtObjective: UITextView!
    @IBOutlet weak var txtEducation: UITextView!
    @IBOutlet weak var txtExperience: UITextView!
    @IBOutlet weak var txtSkills: UITextView!
    @IBOutlet weak var txtReference: UITextView!
    var presenter: RegistrationPresenter?
    var cvObj : UserResponse?

    var cover_image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtObjective.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtEducation.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtExperience.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtSkills.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtReference.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        
        txtObjective.text = self.cvObj?.cvData?.myCvObj?.objective
        txtEducation.text = self.cvObj?.cvData?.myCvObj?.education
        txtExperience.text = self.cvObj?.cvData?.myCvObj?.experience
        txtSkills.text = self.cvObj?.cvData?.myCvObj?.skills
        txtReference.text = self.cvObj?.cvData?.myCvObj?.references
        presenter = RegistrationPresenter(delegate: self)
        
        
      
    }
    
    @IBAction func btnReadyToGo_Pressed(_ sender: UIButton) {
        presenter?.cvCreateInfo(objective: "a" , education: "a" , exeperience: "a" , skills: "a" , reference: "a")
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

extension UBEditBioDataVC : RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){

        let email = self.cvObj?.cvData?.myCvObj?.email!
        let add = self.cvObj?.cvData?.myCvObj?.address ?? " "
        let linkedInUr = self.cvObj?.cvData?.myCvObj?.linkedin ?? " "
        let nationality = self.cvObj?.cvData?.myCvObj?.nationality ?? 1
        let language = self.cvObj?.cvData?.myCvObj?.language ?? " "
        let about = self.cvObj?.cvData?.myCvObj?.about_me ??  " "
        let website = self.cvObj?.cvData?.myCvObj?.website ?? " "
        let phone = self.cvObj?.cvData?.myCvObj?.phone ?? " "

        let params =      [ "email"                        :  email!  ,
                            "address"                      :  add  ,
                            "linkedin"                     :  linkedInUr ,
                            "nationality"                  : "\(nationality)" ,
                            "language"                     :  language ,
                            "about_me"                     :  about ,
                            "objective"                    :  txtObjective.text ?? " " ,
                            "experience"                   :  txtExperience.text ?? " " ,
                            "education"                    :  txtEducation.text ?? " " ,
                            "skills"                       :  txtSkills.text ??  " " ,
                            "references"                   :  txtReference.text ?? " " ,
                            "website"                      :  website ,
                            "phone"                        :  phone ,
            ] as [String : Any]
        
        SVProgressHUD.show()
        WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject> , serviceName: UPDATECV, imageParam:"profile", imgFileName: "profile.png", serviceType: "Crate Cv".localized(), profileImage: cover_image, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()
            guard let this = self else {
                return
            }
            
            let responseObj = response as! UserResponse
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CVCreate"), object : nil, userInfo : nil)

            if responseObj.status == true {
                this.showAlertViewWithTitle(title: KMessageTitle, message: responseObj.message! , dismissCompletion: {
                    this.navigationController?.popToRootViewController(animated: true)
                })
            }
            else
            {
                this.showAlert(title: KMessageTitle, message: responseObj.message!, controller: self)
                
            }
            
        }) { [weak self](error) in
        }
        
        
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEnterCVInfoVC") as? UBEnterCVInfoVC
        //        vc?.cvList = self.cvObj?.cvData
        //        vc?.education = txtEducation.text!
        //        vc?.objectiveText = txtObjective.text!
        //        vc?.experience = txtExperience.text!
        //        vc?.skillsList = txtSkills.text!
        //        vc?.reference = txtReference.text!
        //        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}
