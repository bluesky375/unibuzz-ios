//
//  UBAddMemberVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 07/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBAddMemberVC: UIViewController {
    
    @IBOutlet weak var txtEmail : UITextField!
    var groupObj : GroupList?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func btnSendInvitation_Pressed(_ sender : UIButton) {
        
        if  txtEmail.text!.isEmpty {
           self.showAlert(title: KMessageTitle, message: "Please enter the email address".localized(), controller: self)
        } else if !(UtilityHelper.isValidEmailAddress(txtEmail.text!)) {
            self.showAlert(title: KMessageTitle, message: "Please enter the valid email address".localized(), controller: self)
        } else {
            
        var param = [:] as [String : Any]
        let EMAIL = txtEmail.text
        let EMAILARR = EMAIL!.split{$0 == "@"}.map(String.init)
        let groupId = groupObj?.id
        let serviceUrl = "\(INVITE)\(groupId!)"
        param = ["email"                              :   EMAILARR[0],
                 "domain"                             :    "@\(EMAILARR[1])"
                ]
            WebServiceManager.postJson(params:param as Dictionary<String, Any> as Dictionary<String, AnyObject> , serviceName: serviceUrl  , serviceType: "Invite User".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
            //
        }, showHUD: true)
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
