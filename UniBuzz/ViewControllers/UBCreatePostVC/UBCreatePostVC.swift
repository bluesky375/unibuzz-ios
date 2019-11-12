//
//  UBCreatePostVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD

protocol CreatePostDelegate : class {
    func createPost(obj : FeedsObject)
    
}
class UBCreatePostVC: UIViewController {
    
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var btnPostAnonymous: UIButton!
    @IBOutlet weak var btnSelectGroup: UIButton!
    
    @IBOutlet weak var pollView1: UIView!
    @IBOutlet weak var pollView2: UIView!
    @IBOutlet weak var pollView3: UIView!
    @IBOutlet weak var pollView4: UIView!
    @IBOutlet weak var pollView5: UIView!
    @IBOutlet weak var btnDisableComment: UIButton!
    var groupList: UserResponse?
    var groupId : Int?
    var groupBarCode : String?
    var isAnonymous  = 0
    var isDisbaleComent = 0
    var groupObj : GroupList?
    @IBOutlet weak var txtOption1: UITextField!
    @IBOutlet weak var txtOption2: UITextField!
    @IBOutlet weak var txtOption3: UITextField!
    @IBOutlet weak var txtOption4: UITextField!
    @IBOutlet weak var txtOption5: UITextField!
    @IBOutlet weak var lblOption3: UILabel!
    @IBOutlet weak var btnCross1: UIButton!
    @IBOutlet weak var btnCross2: UIButton!
    @IBOutlet weak var btnCross3: UIButton!
    @IBOutlet weak var imgofPost: UIImageView!
    @IBOutlet weak var imgOfPoll: UIImageView!
    
    @IBOutlet weak var imgOfAnonyMous: UIImageView!
    @IBOutlet weak var imgofDisableComment: UIImageView!
    @IBOutlet weak var viewOfOptionsSelect: UIView!
    var isPollSelectOrPost : Bool?
    
    private  var pollArray : [String] = []
    
    weak var delegate : CreatePostDelegate?
    var post : FeedsObject?
    var isSelectGroup : Bool?
    
    @IBOutlet weak var addMoreView: UIView!
    var isEditClick : Bool?
    
    var presenter: RegistrationPresenter?
    
    var isOption3Select : Bool?
    var isOption4Select : Bool?
    var isOption5Select : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WAShareHelper.setBorderAndCornerRadius(layer: txtPost.layer, width: 1.0, radius: 5.0, color: UIColor(red: 145/255.0, green: 157/255.0, blue: 205/255.0, alpha: 1.0))
        imgOfPoll.image = UIImage(named: "checkUn")
        imgofPost.image = UIImage(named: "selected_ic")
        btnSelectGroup.isUserInteractionEnabled = false
        isPollSelectOrPost = false
        isSelectGroup = false
        txtPost.placeholder = "What you want to post today".localized()
        viewOfOptionsSelect.isHidden = true
        pollView3.isHidden = true
        pollView4.isHidden = true
        pollView5.isHidden = true
        txtOption3.addTarget(self, action: #selector(UBCreatePostVC.option3(_:)), for: UIControl.Event.editingChanged)
        txtOption4.addTarget(self, action: #selector(UBCreatePostVC.option4(_:)), for: UIControl.Event.editingChanged)
        txtOption5.addTarget(self, action: #selector(UBCreatePostVC.option5(_:)), for: UIControl.Event.editingChanged)
        isOption3Select = false
        isOption4Select = false
        isOption5Select = false
        if let groupObject = self.groupObj {
            self.btnSelectGroup.setTitle(groupObject.name , for: .normal)
            self.groupId = groupObject.id
            self.isSelectGroup = true
            self.groupBarCode = groupObject.barcode
        } else {
            getAllGroupList()
        }
        
    }
    
    @objc func option1(_ textField: UITextField) {
        if txtOption1.text!.count > 0 {
            
        } else {
            
        }
    }
    @objc func option2(_ textField: UITextField) {
        if txtOption2.text!.count > 0 {
        } else {
            
        }
    }
    
    @objc func option3(_ textField: UITextField) {
        if txtOption3.text!.count > 0 {
            isOption3Select = false
        } else {
            isOption3Select = true
            
        }
    }
    
    @objc func option4(_ textField: UITextField) {
        if txtOption4.text!.count > 0 {
            isOption4Select = false
        } else {
            isOption4Select = true
            
        }
    }
    
    @objc func option5(_ textField: UITextField) {
        if txtOption5.text!.count > 0 {
            isOption5Select = false
        } else {
            isOption5Select = true
        }
    }
    
    @IBAction func btnAddOption_Pressed(_ sender: UIButton) {
        if pollView3.isHidden == true {
            pollView3.isHidden = false
            isOption3Select = true
        } else if pollView4.isHidden == true {
            pollView4.isHidden = false
            isOption4Select = true
        } else if pollView5.isHidden == true {
            pollView5.isHidden = false
            isOption5Select = true
        }
    }
    
    @IBAction func btnOption1_Pressed(_ sender: UIButton) {
        pollView3.isHidden = true
        pollArray.removeAll { $0 == txtOption3.text }
        txtOption3.text = ""
        isOption3Select = false
        
    }
    
    @IBAction func btnOption2_Pressed(_ sender: UIButton) {
        pollView4.isHidden = true
        pollArray.removeAll { $0 == txtOption4.text }
        txtOption4.text = ""
        isOption4Select = false
    }
    
    @IBAction func btnOption3_Pressed(_ sender: UIButton) {
        pollView5.isHidden = true
        pollArray.removeAll { $0 == txtOption5.text }
        isOption5Select = false
        txtOption5.text = ""
    }
    
    func getAllGroupList() {
        WebServiceManager.get(params: nil, serviceName: GETGROUP, serviceType: "Group List".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
            self!.groupList = (response as! UserResponse)
            if self!.groupList?.status == true {
                self!.btnSelectGroup.isUserInteractionEnabled = true
                
            } else {
                self!.showAlert(title: KMessageTitle, message: (self!.groupList?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
    
    @IBAction func btnPoll_Select(_ sender: UIButton) {
        viewOfOptionsSelect.isHidden = false
        imgOfPoll.image = UIImage(named: "selected_ic")
        imgofPost.image = UIImage(named: "checkUn")
        isPollSelectOrPost = true
    }
    
    @IBAction func btnPollSelect_Pressed(_ sender: UIButton) {
        viewOfOptionsSelect.isHidden = true
        isPollSelectOrPost = false
        imgOfPoll.image = UIImage(named: "checkUn")
        imgofPost.image = UIImage(named: "selected_ic")
        pollView3.isHidden = true
        pollView4.isHidden = true
        pollView5.isHidden = true
    }
    
    @IBAction func btnSelectGroup_Pressed(_ sender: UIButton) {
        
        var allCategoriesList = [String]()
        for (_ , info) in (self.groupList?.getGroup?.enumerated())! {
            allCategoriesList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Group".localized(), rows: allCategoriesList , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            self!.isSelectGroup = true
            let category = self!.groupList?.getGroup![index]
            self!.btnSelectGroup.setTitle(category?.name , for: .normal)
            self!.groupId = category?.id
            self!.groupBarCode = category?.barcode
            
            return
            }, cancel: { (actionStrin ) in
                
        }, origin: sender)
        
    }
    
    @IBAction func btnPostAnonyMous_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            self.imgOfAnonyMous.image = UIImage(named: "check_selected")
            isAnonymous = 1
        } else {
            self.imgOfAnonyMous.image = UIImage(named: "check_n_selected")
            
            isAnonymous = 0
        }
    }
    
    @IBAction func btnDisableComment_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            isDisbaleComent = 1
            self.imgofDisableComment.image = UIImage(named: "check_selected")
            
        } else {
            isDisbaleComent = 0
            self.imgofDisableComment.image = UIImage(named: "check_n_selected")
        }
    }
    
    @IBAction private func btnCreatePost_Pressed(_ sender : UIButton) {
        
        if Connectivity.isConnectedToInternet()  {
            var param = [:] as [String : Any]
            
            if self.isSelectGroup ==  true {
                
                if isPollSelectOrPost == true {
                    if txtPost.text.isEmpty {
                        self.showAlert(title: KMessageTitle, message: "Please Enter the comment".localized() , controller: self)
                    }
                    else if txtOption1.text!.isEmpty {
                        self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 1".localized() , controller: self)
                    }
                    else if txtOption2.text!.isEmpty {
                        self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 2".localized() , controller: self)
                    }
                    else if isOption3Select == true {
                        self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 3".localized() , controller: self)
                    }
                        
                    else if isOption4Select == true {
                        self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 4".localized() , controller: self)
                    }
                    else if isOption5Select == true {
                        self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 5".localized() , controller: self)
                    }
                    else {
                        pollArray.append(txtOption1.text!)
                        pollArray.append(txtOption2.text!)
                        if txtOption3.text!.count  > 0 {
                            pollArray.append(txtOption3.text!)
                        }
                        
                        if txtOption4.text!.count  > 0 {
                            pollArray.append(txtOption4.text!)
                        }
                        if txtOption5.text!.count  > 0 {
                            pollArray.append(txtOption5.text!)
                        }
                        
                        
                        param = ["group_id"                   :  "\(groupId!)",
                            "group_barcode"              : groupBarCode! ,
                            "type"                       : "1",
                            "comment"                    : txtPost.text! ,
                            "is_anonymous"               : "\(isAnonymous)" ,
                            "disable_comments"           : "\(isDisbaleComent)" ,
                            "options"                        : pollArray
                        ]
                        SVProgressHUD.show(withStatus: "Loading".localized())
                        var serviceUrl : String?
                        if  isEditClick == true  {
                            serviceUrl = UPDATEPOST
                        } else {
                            serviceUrl = GETGROUP
                        }
                        
                        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: serviceUrl! , serviceType: "Login".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
                            //  NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PostNewCreate"), object : nil, userInfo : nil)
                            //            SVProgressHUD.dismiss()
                            if  let post = responseData as? UserResponse {
                                if post.status == true {
                                    SVProgressHUD.show(withStatus: post.message)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self]  in
                                        SVProgressHUD.dismiss()
                                        self!.pollArray = []
                                        self!.delegate?.createPost(obj: post.postReaction!)
                                        self!.navigationController?.popViewController(animated: true)
                                        
                                    })
                                } else {
                                    self!.pollArray = []
                                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                                }
                            }
                            }, fail: { (error) in
                                //
                        }, showHUD: true)
                        
                        
                    }
                    
                    //            self.presenter?.pollCreateValidator(isSelectGroup: self.isSelectGroup! , txtAdd: txtPost.text! , option1: txtOption1.text! , option2: txtOption2.text! , option3: <#T##Bool#>, option4: <#T##Bool#>, option5: <#T##Bool#>)
                    //            if txtOption1.text!.count > 0  {
                    //                pollArray.append(txtOption1.text!)
                    //                pollArray.append(txtOption2.text!)
                    //            } else {
                    //                self.showAlert(title: KMessageTitle  , message: "Please Enter the Option1 ", controller: self)
                    //            }
                    ////
                    ////            else {
                    ////                self.showAlert(title: KMessageTitle  , message: "Please Enter the Option1 or Option 2", controller: self)
                    ////            }
                    //            if txtOption3.text!.count  > 0 {
                    //                 pollArray.append(txtOption3.text!)
                    //            }
                    //
                    //            if txtOption4.text!.count > 0 {
                    //                pollArray.append(txtOption4.text!)
                    //            }
                    //
                    //            if txtOption5.text!.count > 0 {
                    //                pollArray.append(txtOption5.text!)
                    //            }
                    //            param = ["group_id"                   :  "\(groupId!)",
                    //                     "group_barcode"              : groupBarCode! ,
                    //                     "type"                       : "1",
                    //                     "comment"                    : txtPost.text! ,
                    //                     "is_anonymous"               : "\(isAnonymous)" ,
                    //                    "disable_comments"           : "\(isDisbaleComent)" ,
                    //                    "options"                        : pollArray
                    //                ]
                    
                    
                } else {
                    
                    if txtPost.text.count > 5 {
                        param = ["group_id"                    :  "\(groupId!)",
                            "group_barcode"               : groupBarCode! ,
                            "type"                        : "0",
                            "comment"                     : txtPost.text! ,
                            "is_anonymous"                : "\(isAnonymous)" ,
                            "disable_comments"            : "\(isDisbaleComent)" ]
                        SVProgressHUD.show(withStatus: "Loading".localized())
                        var serviceUrl : String?
                        if  isEditClick == true  {
                            serviceUrl = UPDATEPOST
                        } else {
                            serviceUrl = GETGROUP
                        }
                        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: serviceUrl! , serviceType: "Login".localized(), modelType: UserResponse.self , success: {[weak self] (responseData) in
                            if  let post = responseData as? UserResponse {
                                if post.status == true {
                                    SVProgressHUD.show(withStatus: post.message)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self]  in
                                        SVProgressHUD.dismiss()
                                        self!.pollArray = []
                                        self!.delegate?.createPost(obj: post.postReaction!)
                                        self!.navigationController?.popViewController(animated: true)
                                    })
                                } else {
                                    self!.pollArray = []
                                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                                }
                            }
                            }, fail: { (error) in
                                //
                        }, showHUD: true)
                        
                    } else {
                        self.showAlert(title: "UniBuzz".localized(), message: " Post must be more than 5 characters! ".localized() , controller: self)
                        
                    }
                    
                }
                
            }
            else {
                self.showAlert(title: "UniBuzz".localized(), message: "Please select the group".localized() , controller: self)
            }
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection, controller: self)
        }
    }
}


