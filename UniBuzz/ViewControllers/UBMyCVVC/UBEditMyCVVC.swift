//
//  UBEditMyCVVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
  
class UBEditMyCVVC: UIViewController {

    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblNamr: UILabel!
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var lblField: UILabel!
    @IBOutlet weak var txtAboutMe: UITextView!
    @IBOutlet weak var txtPhoneNum: UITextField!
    @IBOutlet weak var txtLanguage: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnNationality: UIButton!
    @IBOutlet weak var txtLinkedUrl: UITextField!
    @IBOutlet weak var txtWebsiteProfile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    var cover_image: UIImage?
    let photoPicker = PhotoPicker()
    var selectId : Int?
    var isSlectNationailities : Bool?
    var isSelectPhoto : Bool?
    var cvObj : UserResponse?
    var presenter: RegistrationPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtAboutMe.layer, width: 1.0, radius: 5, color: UIColor.groupTableViewBackground)
        presenter = RegistrationPresenter(delegate: self)
        isSelectPhoto = true
        isSlectNationailities = true
        selectId = self.cvObj?.cvData?.myCvObj?.nationality
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBEditMyCVVC.imageTappedForDp(img:)))
        imgOfUser.isUserInteractionEnabled = true
        imgOfUser.addGestureRecognizer(tapGestureRecognizerforDp)
        lblNamr.text = self.cvObj?.cvData?.name
        lblUniName.text = self.cvObj?.cvData?.university
        txtAboutMe.text = self.cvObj?.cvData?.myCvObj?.about_me
        txtPhoneNum.text = self.cvObj?.cvData?.myCvObj?.phone
        txtLanguage.text = self.cvObj?.cvData?.myCvObj?.language
        txtEmail.text = self.cvObj?.cvData?.myCvObj?.email
        txtLinkedUrl.text = self.cvObj?.cvData?.myCvObj?.linkedin
        txtWebsiteProfile.text = self.cvObj?.cvData?.myCvObj?.website
        txtAddress.text = self.cvObj?.cvData?.myCvObj?.address
        btnNationality.setTitle(self.cvObj?.cvData?.myCvObj?.nationality_name , for: .normal)
        let image = self.cvObj?.cvData?.myCvObj?.image
        let path = self.cvObj?.cvData?.myCvObj?.path
        if path == nil {
            imgOfUser.setImage(with: self.cvObj?.cvData?.myCvObj?.path , placeholder: UIImage(named: "profile_ic"))
            imgOfUser.image = cover_image
        } else {
            let fullPAth = "\(path!)/\(image!)"
            WAShareHelper.loadImage(urlstring: fullPAth , imageView: self.imgOfUser! , placeHolder: "profile")
            cover_image = imgOfUser.image
            let cgFloat: CGFloat = imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(imgOfUser, radius: CGFloat(someFloat))
            imgOfUser.image = cover_image
        }
    }
    
    @objc func imageTappedForDp(img: AnyObject)
    {
        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) {[weak self] (orignal, edited) in
            
            self!.isSelectPhoto = true
            //            self!.imgOfGroupIcon.image = orignal
            let cgFloat: CGFloat = self!.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(self!.imgOfUser, radius: CGFloat(someFloat))
            let vc = PhotoTweaksViewController(image: orignal)
            vc?.delegate = self
            vc?.autoSaveToLibray = false
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
    }


    @IBAction func btnCreateCV_Pressed(_ sender: UIButton) {
        
        presenter?.basicUserInfo(profilePic: isSelectPhoto!, aboutMe: txtAboutMe.text! , txtPhone: txtPhoneNum.text! , txtEmail: txtEmail.text!, nationalities: isSlectNationailities! , addrss: " " , language: txtLanguage.text! , website: txtWebsiteProfile.text!, linked: txtLinkedUrl.text!)
    }
    
    @IBAction func btnNationality_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        var allNationalities = [String]()
        for (_ , info) in (cvObj?.cvData?.nationalitiesList?.enumerated())! {
            allNationalities.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Nationality".localized(), rows: allNationalities , initialSelection: 0 , doneBlock: { (picker, index, value) in
            self.isSlectNationailities = true
            self.btnNationality.isSelected = true 
            let category = self.cvObj?.cvData?.nationalitiesList![index]
            self.selectId = category?.id
            self.btnNationality.setTitle(category?.name , for: .normal)
            
            return
        }, cancel: { (actionStrin ) in
            
        }, origin: sender)
    }
}

extension UBEditMyCVVC : RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        
        let objective = self.cvObj?.cvData?.myCvObj?.objective ?? " "
        let expe = self.cvObj?.cvData?.myCvObj?.experience ?? " "
        let education = self.cvObj?.cvData?.myCvObj?.education ?? " "
        let skill = self.cvObj?.cvData?.myCvObj?.skills ?? " "
        let ref = self.cvObj?.cvData?.myCvObj?.references ?? " "

        let params =      [ "email"                        :  txtEmail.text!  ,
                            "address"                      :  txtAddress.text ?? " " ,
                            "linkedin"                     :  txtLinkedUrl.text! ,
                            "nationality"                  : "\(selectId!)" ,
                            "language"                     :  txtLanguage.text! ,
                            "about_me"                     :  txtAboutMe.text! ,
                            "objective"                    :  objective  ,
                            "experience"                   :  expe  ,
                            "education"                    :  education  ,
                            "skills"                       :  skill  ,
                            "references"                   :  ref  ,
                            "website"                      :  txtWebsiteProfile.text! ,
                            "phone"                        :  txtPhoneNum.text! ,
            ] as [String : Any]
        SVProgressHUD.show()
        WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject> , serviceName: UPDATECV, imageParam:"profile", imgFileName: "profile.png", serviceType: "Crate Cv".localized(), profileImage: cover_image, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: {[weak self] (response) in
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


extension UBEditMyCVVC : PhotoTweaksViewControllerDelegate {
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        _ = controller.navigationController?.popViewController(animated: true)
        self.imgOfUser.image = croppedImage
        self.cover_image = croppedImage
        let cgFloat: CGFloat = self.imgOfUser.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloat))
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}
