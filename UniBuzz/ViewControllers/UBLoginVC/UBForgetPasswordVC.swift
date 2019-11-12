//
//  UBForgetPasswordVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 19/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import IQKeyboardManagerSwift
  
class UBForgetPasswordVC: UIViewController {
    
    var presenter : RegistrationPresenter?
    @IBOutlet var txtEmail: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.shared.enable = true
        presenter = RegistrationPresenter(delegate: self)
        
    }
    
    @IBAction func btnBack_Pressed(_ sender: UIButton) {
        self.pushToViewControllerWithStoryboardID(storyboardId: "UBSignUpVC")
    }
    
    @IBAction func btnSendCode_Pressed(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet()  {
            self.presenter?.forgotPasswordValidation(email: txtEmail.text!)
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)
        }
    }
}

extension UBForgetPasswordVC : RegistrationDelegate{
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    func registrationDidSucceed(){
        let forgotParam = [ kEmail        : txtEmail.text!
            ] as [String : Any]
        SVProgressHUD.show()
        WebServiceManager.postJsonWithOutHeader(params: forgotParam as Dictionary<String, AnyObject> , serviceName: FORGOTPASSWORD , serviceType: "Forget passwod".localized(), modelType: UserResponse.self, success: { [weak self] (responseData) in
            guard let self = self else {return}
            SVProgressHUD.dismiss()
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.showAlertViewWithTitle(title: KMessageTitle, message: post.message! , dismissCompletion: { [weak self] in
                        guard let self = self else {return}
                        self.presenter = nil
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
            //
        }, showHUD: true)
    }
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}
