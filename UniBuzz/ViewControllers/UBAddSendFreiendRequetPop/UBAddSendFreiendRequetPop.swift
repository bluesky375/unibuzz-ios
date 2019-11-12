//
//  UBAddSendFreiendRequetPop.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 22/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import GrowingTextView
  

protocol FriendRequestDelegate  : class {
    func isRequestSendOrAccept(updateFeed : FeedsObject  , index : IndexPath)
}

class UBAddSendFreiendRequetPop: UIViewController {
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var lblUniName: UILabel!
    @IBOutlet weak var lblName: UILabel!
//    @IBOutlet weak var txtOfMessage: GrowingTextView!
    @IBOutlet weak var txtOfMessage: UITextField!
    
    var feedObj : FeedsObject?
    @IBOutlet weak var btnSendMessage: UIButton!
    var presenter: RegistrationPresenter?
    weak var delegate : FriendRequestDelegate?
    var indexSelect : IndexPath?
    
    @IBOutlet weak var isFriendMEssgae: UILabel!
    
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var btnReject: UIButton!

    @IBOutlet weak var btnFriend: UIButton!
    var userName  : String?
    @IBOutlet weak var viewOfAcceptOrReject: UIView!
    private  var responseObj : UserResponse?
    var userInfo  : UserInfoObject?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setViewCornerRadius(txtOfMessage, radius: 20.0)
        if feedObj == nil {
            getFriendStatus()
        } else {
            imgOfUser.setImage(with: feedObj?.user?.profile_image, placeholder: UIImage(named: "profile2"))
            lblName.text = feedObj?.user?.full_name
            lblUniName.text = feedObj?.post_group_name
            userName = feedObj?.user?.full_name
            let firstName = feedObj?.user?.first_name

            txtOfMessage.placeholder = "Say hi to".localized() + " \(firstName!)"

            if feedObj?.friendStatus?.friends == true {
                viewOfAcceptOrReject.isHidden = true
                btnFriend.isHidden = false
                btnFriend.setTitle("  Friends  ".localized(), for: .normal)
                isFriendMEssgae.text = "Already Friend with".localized() + " \(userName!)"
                btnFriend.isUserInteractionEnabled = false
                btnFriend.isHidden = true
            }
            if feedObj?.friendStatus?.friends == false &&  feedObj?.friendStatus?.invited == false && feedObj?.friendStatus?.requested == false {
                viewOfAcceptOrReject.isHidden = true
                btnFriend.setTitle("    Add Friend    ".localized(), for: .normal)
                isFriendMEssgae.text = "Add \(userName!) as a friend".localized()
            }
            
            if feedObj?.friendStatus?.requested == true {
                viewOfAcceptOrReject.isHidden = true
                btnFriend.setTitle("    Cancel Request    ".localized(), for: .normal)
                isFriendMEssgae.text = "Cancel you friend request to".localized() + " \(userName!)"
            }
            
            if feedObj?.friendStatus?.invited == true {
                isFriendMEssgae.text = "\(userName!)" + " Sent you are friend request".localized()
                viewOfAcceptOrReject.isHidden = false
                btnFriend.isHidden = true
            }
            
            let cgFloat: CGFloat = self.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloat))

        }
        presenter = RegistrationPresenter(delegate: self)
        self.btnSendMessage.isUserInteractionEnabled = false
        self.btnSendMessage.setImage(UIImage(named: "sendUn"), for: .normal)
        txtOfMessage.setLeftPaddingPoints(10.0)
        txtOfMessage.delegate = self
        
        txtOfMessage.addTarget(self, action: #selector(UBAddSendFreiendRequetPop.numberOfRow(_:)), for: UIControl.Event.editingChanged)

//        txtOfMessage.placeholder = "Enter Message"
        
//        heightOFPop.constant = 170.0
//        viewOfMessage.isHidden = true
//        txtOfMessage.isHidden = true
//        btnSendMessage.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    @objc func numberOfRow(_ textField: UITextField) {
        if txtOfMessage.text!.count > 0 {
            self.btnSendMessage.isUserInteractionEnabled = true
            self.btnSendMessage.setImage(UIImage(named: "send"), for: .normal)
        } else {
            self.btnSendMessage.isUserInteractionEnabled = false
            self.btnSendMessage.setImage(UIImage(named: "sendUn"), for: .normal)

        }
    }
    
    func getFriendStatus() {
        let userId = userInfo?.id
        let serviceUrl = "\(FRIENDSCHECK)\(userId!)"
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Note Detail".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
            self!.responseObj = (response as! UserResponse)
            if self!.responseObj?.status == true {
                SVProgressHUD.dismiss()
                self!.getCheckStatusOfFriend()
            } else {
                self!.showAlert(title: KMessageTitle, message: (self!.responseObj?.message!)!, controller: self)
            }
        }) { (error) in

        }
    }

    func getCheckStatusOfFriend() {
        imgOfUser.setImage(with: userInfo?.profile_image, placeholder: UIImage(named: "profile2"))
        lblName.text = userInfo?.full_name
        lblUniName.text = ""
        userName = userInfo?.full_name
        let firstName = userInfo?.first_name
        txtOfMessage.placeholder = "Say hi to".localized() + " \(firstName!)"
        if responseObj?.friendStatus?.friends == true {
            viewOfAcceptOrReject.isHidden = true
            btnFriend.isHidden = false
            btnFriend.setTitle("  Friends  ".localized(), for: .normal)
            isFriendMEssgae.text = "Already Friend with".localized() + " \(userName!)"
            btnFriend.isUserInteractionEnabled = false
            btnFriend.isHidden = true
        }
        
        if responseObj?.friendStatus?.friends == false &&  responseObj?.friendStatus?.invited == false && responseObj?.friendStatus?.requested == false {
            viewOfAcceptOrReject.isHidden = true
            btnFriend.setTitle("    Add Friend    ".localized(), for: .normal)
            isFriendMEssgae.text = "Add \(userName!) as a friend".localized()
        }
        
        if responseObj?.friendStatus?.requested == true {
            viewOfAcceptOrReject.isHidden = true
            btnFriend.setTitle("    Cancel Request    ".localized(), for: .normal)
            isFriendMEssgae.text = "Cancel you friend request to".localized() + " \(userName!)"
        }
        
        if responseObj?.friendStatus?.invited == true {
            isFriendMEssgae.text = "\(userName!)" + " Sent you are friend request".localized()
            viewOfAcceptOrReject.isHidden = false
            btnFriend.isHidden = true
        }
        
        let cgFloat: CGFloat = self.imgOfUser.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloat))

    }

    private func performAPICall(endPoint: String) {
        if Connectivity.isConnectedToInternet() {
            SVProgressHUD.show()
            WebServiceManager.put(params: ["":"" as AnyObject], serviceName: endPoint, isLoaderShow: true, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
                SVProgressHUD.dismiss()
                self!.delegate?.isRequestSendOrAccept(updateFeed: self!.feedObj!, index: self!.indexSelect!)
                self!.dismiss(animated: true) {
                }
            }, fail: { (error) in
                
            }, showHUD: true)
        }else {
            self.showAlert(title: KMessageTitle, message: "No internet connection!".localized(), controller: self)
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
//        self.dismiss(animated: true) {
//
//        }
//    }

    
    @IBAction func btnMessage_Pressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }
//        txtOfMessage.becomeFirstResponder()
//        UIView.animate(withDuration: 0.6, delay: 0.3, options: .transitionFlipFromLeft, animations: {[weak self] in
////            self!.heightOFPop.constant = 280
////            self!.viewOfMessage.isHidden = false
//            self!.txtOfMessage.isHidden = false
//            self!.btnSendMessage.isHidden = false
//        }) { (isCompleted) in
//        }
//
    }
    
    @IBAction func btnSendMessage_Pressed(_ sender: UIButton) {
        self.presenter?.sendMessageValidation(message: txtOfMessage.text!)
    }
    
    @IBAction func btnCross_Pressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func btnAddFriend(_ sender: UIButton) {
        
        if feedObj == nil {
            if responseObj?.friendStatus?.friends == false &&  responseObj?.friendStatus?.invited == false && responseObj?.friendStatus?.requested == false {
                let userId = userInfo?.id
                let endPoint = "\(SEND)\(userId!)"
//                feedObj?.friendStatus?.requested = true
                self.performAPICall(endPoint: endPoint)
            }
            else  if responseObj?.friendStatus?.requested == true {
                let userId = userInfo?.id
                let endPoint = "\(CANCEL)\(userId!)"
//                feedObj?.friendStatus?.requested = false
                self.performAPICall(endPoint: endPoint)
            }

        }
        else {
            if feedObj?.friendStatus?.friends == false &&  feedObj?.friendStatus?.invited == false && feedObj?.friendStatus?.requested == false {
                let userId = feedObj?.user_id
                let endPoint = "\(SEND)\(userId!)"
                feedObj?.friendStatus?.requested = true
                self.performAPICall(endPoint: endPoint)
            }
            else  if feedObj?.friendStatus?.requested == true {
                let userId = feedObj?.user_id
                let endPoint = "\(CANCEL)\(userId!)"
                feedObj?.friendStatus?.requested = false
                self.performAPICall(endPoint: endPoint)
            }

        }
        
        if feedObj == nil {
            
        }
    }
    @IBAction func btnAccept(_ sender: UIButton) {
        
        if feedObj == nil {
            let userId = userInfo?.id
            let endPoint = "\(ACCEPT)\(userId!)"
//            feedObj?.friendStatus?.friends = true
//            feedObj?.friendStatus?.invited = false
            
            self.performAPICall(endPoint: endPoint)

        } else {
            let userId = feedObj?.user_id
            let endPoint = "\(ACCEPT)\(userId!)"
            feedObj?.friendStatus?.friends = true
            feedObj?.friendStatus?.invited = false
            
            self.performAPICall(endPoint: endPoint)

        }
  }
    
    @IBAction func btnReject(_ sender: UIButton) {
        
        if feedObj == nil {
            let userId = userInfo?.id
            let endPoint = "\(REJECT)\(userId!)"
            self.performAPICall(endPoint: endPoint)

        } else {
            let userId = feedObj?.user_id
            let endPoint = "\(REJECT)\(userId!)"
            feedObj?.friendStatus?.friends = false
            feedObj?.friendStatus?.requested = false
            feedObj?.friendStatus?.invited = false
            
            self.performAPICall(endPoint: endPoint)

        }

    }
}

extension UBAddSendFreiendRequetPop : RegistrationDelegate {
    func showProgress(){
        
    }
    
    func hideProgress(){
        
    }

    func registrationDidSucceed(){

        var param = [:] as [String : Any]
        var  userId : Int?
        
        if feedObj == nil {
            userId = userInfo?.id
        } else {
            userId = feedObj?.user_id

        }
        param = ["user_id"                         :  "\(userId!)",
                 "message"                         :   txtOfMessage.text!
                ]
        self.btnSendMessage.isUserInteractionEnabled = false
        self.btnSendMessage.setImage(UIImage(named: "sendUn"), for: .normal)
        self.txtOfMessage.text = ""
        self.txtOfMessage.resignFirstResponder()

        SVProgressHUD.show(withStatus: "Loading".localized())
        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: STARTNEWCHAT , serviceType: "Chat".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    SVProgressHUD.show(withStatus: "Message Sent".localized())
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self]  in
                        SVProgressHUD.dismiss()
                        self?.dismiss(animated: true, completion: {
                        })
                    })
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
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

extension UBAddSendFreiendRequetPop :  UITextFieldDelegate {
    
//    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
//        UIView.animate(withDuration: 0.2) { [weak self] in
//            self!.view.layoutIfNeeded()
//        }
//    }
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if txtOfMessage.text!.count > 0 {
//            self.btnSendMessage.isUserInteractionEnabled = true
//            self.btnSendMessage.setImage(UIImage(named: "send"), for: .normal)
//
//        } else {
//            self.btnSendMessage.isUserInteractionEnabled = false
//            self.btnSendMessage.setImage(UIImage(named: "sendUn"), for: .normal)
//
//        }
//
//
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("DidEnd \(textField.text!)")
//        //        isNumberOfSeatSelect = textField.text
//
//
//    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        print("shouldBEgin \(textField.text!)")
//        //        isNumberOfSeatSelect = textField.text
//
//
//        return true;
//    }
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        print("shouldClear \(textField.text!)")
//        //        isNumberOfSeatSelect = textField.text
//
//
//        return true;
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if txtOfMessage.text!.count > 0 {
//            self.btnSendMessage.isUserInteractionEnabled = true
//            self.btnSendMessage.setImage(UIImage(named: "send"), for: .normal)
//
//        } else {
//            self.btnSendMessage.isUserInteractionEnabled = false
//            self.btnSendMessage.setImage(UIImage(named: "sendUn"), for: .normal)
//
//        }
//
//        //        isNumberOfSeatSelect = textField.text
//
//
//        return true;
//    }
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if txtOfMessage.text!.count > 0 {
//            self.btnSendMessage.isUserInteractionEnabled = true
//            self.btnSendMessage.setImage(UIImage(named: "send"), for: .normal)
//
//        } else {
//            self.btnSendMessage.isUserInteractionEnabled = false
//            self.btnSendMessage.setImage(UIImage(named: "sendUn"), for: .normal)
//
//        }
//        //        isNumberOfSeatSelect = textField.text
//
//
//        return true;
//    }
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder();
//        return true;
//    }
//
    

        

}
