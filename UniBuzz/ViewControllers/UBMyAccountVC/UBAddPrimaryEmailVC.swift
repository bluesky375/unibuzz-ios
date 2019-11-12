//
//  UBAddPrimaryEmailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 08/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  
protocol AddEmailDelegate : class {
    func addEmail(user : Session)
}
class UBAddPrimaryEmailVC: UIViewController {
    
    @IBOutlet weak var email : UITextField!
    weak var delegate : AddEmailDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnCancel_Pressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func btnAddEmail(_ sender: UIButton) {
      
        if email.text!.isEmpty {
           self.showAlert(title: KMessageTitle, message: "email can't be blank".localized(), controller: self)
        } else if !(UtilityHelper.isValidEmailAddress(email.text!)) {
            self.showAlert(title: KMessageTitle, message: kValidationEmailInvalidInput , controller: self)
        } else {
            SVProgressHUD.show()
            let persistence = Persistence(with: .user)
            let endPoint = AuthEndpoint.primaryEmail(email: email.text!)
            NetworkLayer.fetch(endPoint, with: LoginResponse.self) {[weak self] (result ) in
            switch result {
            case .success(let response):
                SVProgressHUD.dismiss()
                if response.status == true {
                    persistence.save(response.data, success: { success in
                        self!.delegate?.addEmail(user: response.data!)
                        self!.dismiss(animated: true, completion: {
                            
                        })
                    })
                } else {
                    self!.showAlert(title: KMessageTitle, message: response.message ?? "Server Error".localized() , controller: self)
                }
            case .failure(_): break
                
            }
          }
        }
    }


}
