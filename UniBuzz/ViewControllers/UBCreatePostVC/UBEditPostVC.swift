//
//  UBEditPostVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
  
protocol EditPostDelegate : class {
    func editPost(obj : FeedsObject , index : Int)
}

class UBEditPostVC: UIViewController {
    
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var btnPostAnonymous: UIButton!
    @IBOutlet weak var btnSelectGroup: UIButton!
    @IBOutlet weak var btnDisableComment: UIButton!
    var post: FeedsObject?
    var groupId : Int?
    var groupBarCode : String?
    var isAnonymous  = 0
    var isDisbaleComent = 0
    @IBOutlet weak var lblPost : UILabel!
    var groupList: UserResponse?

    var isSelectGroup : Bool?
    var selectIndex : Int?
    weak var delegate : EditPostDelegate?
    
    
    @IBOutlet weak var imgofDisableComment: UIImageView!
    @IBOutlet weak var disbleComment: UIImageView!
    
    
    
    
    @IBOutlet weak var lbDisable: UILabel!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtPost.layer, width: 1.0, radius: 0.0, color: UIColor.groupTableViewBackground)
        
        txtPost.text = post?.comment
//        txtPost.text = post?.comment
        let grpumName = post?.groupInfo?.name ?? post?.post_group_name
        btnSelectGroup.setTitle(grpumName, for: .normal)
        groupBarCode = post?.groupInfo?.barcode ?? post?.post_group_barcode
        groupId = post?.groupInfo?.id  ?? post?.student_group_id
        
        if post?.is_edited == true {
            lbDisable.isHidden = true
            imgofDisableComment.isHidden = true
            btnDisableComment.isHidden = true
            isDisbaleComent = 1
            disbleComment.isHidden = true
            
            if post!.allow_comment == 0 {
//                btnDisableComment.isSelected = false
//                imgofDisableComment.image = UIImage(named: "check_n_selected")
                isDisbaleComent = 0
                
            } else {
//                btnDisableComment.isSelected = true
                isDisbaleComent = 1
//                imgofDisableComment.image = UIImage(named: "check_selected")
                
            }
            
        } else {
            lbDisable.isHidden = false
            imgofDisableComment.isHidden = false
            btnDisableComment.isHidden = false
            disbleComment.isHidden = false
            
            
            if post!.allow_comment == 0 {
                btnDisableComment.isSelected = false
                imgofDisableComment.image = UIImage(named: "check_n_selected")
                isDisbaleComent = 0
                
            } else {
                btnDisableComment.isSelected = true
                isDisbaleComent = 1
                imgofDisableComment.image = UIImage(named: "check_selected")
                
            }
            
        }

        if post!.user_as == 0 {
            btnPostAnonymous.isSelected = false
            isAnonymous = 0
        } else {
            btnPostAnonymous.isSelected = true
            isAnonymous = 1
        }
        
//        getAllGroupList()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnSelectGroup_Pressed(_ sender: UIButton) {
        
    }


    @IBAction func btnPostAnonyMous_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            isAnonymous = 1
        } else {
            isAnonymous = 0
        }
        //        btnPostAnonymous.isSelected = true
        //        btnDisableComment.isSelected = false
        
        
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
        
        if Connectivity.isConnectedToInternet() {
            
       
        var param = [:] as [String : Any]
        let postId = post?.id
        param = ["group_id"                       :  "\(groupId!)",
                 "group_barcode"                  : groupBarCode! ,
                 "type"                           : "0",
                 "comment"                        : txtPost.text! ,
                 "disable_comments"               : "\(isDisbaleComent)" ,
                 "post_id"                        :   "\(postId!)"
                ]
    
        SVProgressHUD.show(withStatus: "Loading".localized())
        
        WebServiceManager.putJson(params:param as Dictionary<String, AnyObject> , serviceName: UPDATEPOST , serviceType: "Login".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    SVProgressHUD.show(withStatus: post.message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {[weak self] in
                        SVProgressHUD.dismiss()

                        self!.delegate?.editPost(obj: post.postReaction!, index: (self?.selectIndex!)!)
//                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postCreate"), object : nil, userInfo : nil)

                        self!.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
            //
        }, showHUD: true)
      } else {
          self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection, controller: self)
      }
    }
  }


