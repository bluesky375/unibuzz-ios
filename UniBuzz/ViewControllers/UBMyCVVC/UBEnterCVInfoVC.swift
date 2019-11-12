//
//  UBEnterCVInfoVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
  
class UBEnterCVInfoVC: UIViewController {
    
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
    
    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    var selectId : Int?
    var isSlectNationailities : Bool?
    var isSelectPhoto : Bool?
    
    var cvObj : UserResponse?
    
    var presenter: RegistrationPresenter?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSlectNationailities = false
        isSelectPhoto = false
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtAboutMe.layer, width: 1.0, radius: 5, color: UIColor.lightGray)
        presenter = RegistrationPresenter(delegate: self)
//        txtAboutMe.placeholder = "Tell the world who you are and what you good at"
        getAllCvInfo()
        
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBEnterCVInfoVC.imageTappedForDp(img:)))
        imgOfUser.isUserInteractionEnabled = true
        imgOfUser.addGestureRecognizer(tapGestureRecognizerforDp)
        
        
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
    
    
    func getAllCvInfo() {
        SVProgressHUD.show()
        //        var context = (cvObj)
        WebServiceManager.get(params: nil, serviceName: CVGET, serviceType: "Cv Info".localized(), modelType: UserResponse.self, success: { (response) in
            self.cvObj = (response as? UserResponse)
            SVProgressHUD.dismiss()
            if self.cvObj?.status == true {
                self.lblNamr.text = self.cvObj?.cvData?.name
                self.lblUniName.text = self.cvObj?.cvData?.university
                self.lblField.text = self.cvObj?.cvData?.college
            } else  {
                self.showAlert(title: KMessageTitle, message: self.cvObj!.message! , controller: self)
            }
        }) { (error) in
        }
        
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
    
    @IBAction func btnCreateCV_Pressed(_ sender: UIButton) {
        
        presenter?.basicUserInfo(profilePic: isSelectPhoto!, aboutMe: txtAboutMe.text! , txtPhone: txtPhoneNum.text! , txtEmail: txtEmail.text!, nationalities: isSlectNationailities! , addrss: " " , language: txtLanguage.text! , website: txtWebsiteProfile.text!, linked: txtLinkedUrl.text!)
    }
    
    
}

extension UBEnterCVInfoVC : RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){

    }
    
    func registrationDidSucceed(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCreateCVVC") as? UBCreateCVVC
        vc?.cover_image              = cover_image!
        vc?.txtPhoneNum              = txtPhoneNum.text!
        vc?.txtAddress               = txtAddress.text ?? " "
        vc?.txtEmail                 = txtEmail.text!
        vc?.nationality              = self.selectId!
        vc?.txtLinkedUrl             = self.txtLinkedUrl.text ?? " "
        vc?.txtWebsiteUrl            = self.txtWebsiteProfile.text ?? " "
        vc?.txtLanguage              = txtLanguage.text!
        vc?.cvObj                    = self.cvObj?.cvData
        vc?.txtAbout                 = txtAboutMe.text
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}


extension UBEnterCVInfoVC : PhotoTweaksViewControllerDelegate {
    
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
