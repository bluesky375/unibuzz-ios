//
//  UBLoginVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  

class UBLoginVC : UIViewController {
    
    var presenter               :    RegistrationPresenter?
    @IBOutlet var txtEmail      :    UITextField!
    @IBOutlet var txtPassword   :    UITextField!
    let persistence             =    Persistence(with: .user)
    
//    @IBOutlet weak var katexViewss: MTMathUILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        txtPassword.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        presenter = RegistrationPresenter(delegate: self)
    }

    @IBAction private func btnSignIn_Pressed(_ sender : UIButton) {
        if Connectivity.isConnectedToInternet()  {
            self.presenter?.signIn(email: txtEmail.text!, password: txtPassword.text!)
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)
        }
    }

    @IBAction private func btnForgetPass_Pressed(_ sender : UIButton) {
        self.pushToViewControllerWithStoryboardID(storyboardId: "UBForgetPasswordVC")
    }
    
    @IBAction private func btnSignUp_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSignUpVC") as? UBSignUpVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    deinit {
        print("<<<<<<<< UBLoginVC dealloc")
    }
}

extension UBLoginVC: RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        SVProgressHUD.show()
        let endPoint = AuthEndpoint.login(email: txtEmail.text! , password: txtPassword.text! , client_id: "2", client_secret: "pmGqX1ki5HnvamG3g9nPC91QVBCeP6v2uzcjdjhS", scope: "" , grant_type: "password")
        let persistence = Persistence(with: .user)
        NetworkLayer.fetch(endPoint, with: LoginResponse.self) { [weak self](result) in
            guard let self = self else {return}
            switch result {
            case .success(let response):
                SVProgressHUD.dismiss()
                if response.status == true {
                    persistence.save(response.data)
                    self.presenter = nil
                    SKSocketConnection.socketSharedConnection.connectSocket()
                    WAShareHelper.goToHomeController(vcIdentifier: VCIdentifier.KTABBARCONTROLLER, storyboardName: "Home", navController: self.navigationController!, leftMenuIdentifier: "UBSideMenuVC")
                } else {
                    self.showAlert(title: KMessageTitle, message: response.message ?? "Server Error".localized() , controller: self)
                }
            case .failure(_): break
            }
        }
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}



