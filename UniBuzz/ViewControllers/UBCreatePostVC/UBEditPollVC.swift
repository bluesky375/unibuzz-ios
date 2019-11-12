//
//  UBEditPollVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 18/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper
import AlamofireObjectMapper
  
protocol EditPollDelegate : class {
    func editPoll(obj : FeedsObject , index : Int)
}

class UBEditPollVC: UIViewController {
    @IBOutlet weak var txtOption1: UITextField!
    @IBOutlet weak var txtOption2: UITextField!
    @IBOutlet weak var txtOption3: UITextField!
    @IBOutlet weak var txtOption4: UITextField!
    @IBOutlet weak var txtOption5: UITextField!
    @IBOutlet weak var lblOption3: UILabel!
    @IBOutlet weak var lblOption4: UILabel!
    @IBOutlet weak var lblOption5: UILabel!
    @IBOutlet weak var btnCross1: UIButton!
    @IBOutlet weak var btnCross2: UIButton!
    @IBOutlet weak var btnCross3: UIButton!
    @IBOutlet weak var heightOfOption: NSLayoutConstraint!
    @IBOutlet weak var heightOfMainView: NSLayoutConstraint!
    @IBOutlet weak var txtPost: UITextView!
    @IBOutlet weak var btnPostAnonymous: UIButton!
    @IBOutlet weak var btnSelectGroup: UIButton!
    @IBOutlet weak var btnDisableComment: UIButton!
    
    @IBOutlet weak var viewOfOption3: UIView!
    @IBOutlet weak var viewOfOption4: UIView!
    @IBOutlet weak var viewOfOption5: UIView!
    
    @IBOutlet weak var heightOfOption3: NSLayoutConstraint!
    
    @IBOutlet weak var heightOfOption4: NSLayoutConstraint!
    
    @IBOutlet weak var heightOfOption5: NSLayoutConstraint!
    @IBOutlet weak var viewOfOptionsSelect: UIView!
    private  var pollArray : [String] = []
    var post: FeedsObject?
    var groupId : Int?
    var groupBarCode : String?
    var isAnonymous  = 0
    var isDisbaleComent = 0
    @IBOutlet weak var imgofDisableComment: UIImageView!
    @IBOutlet weak var disbleComment: UIImageView!
    
    var selectIndex : Int?
    weak var delegate : EditPollDelegate?
    
    var isOptio1 = false
    var isOptio2 = false
    var isOptio3 = false
    var isOptio4 = false
    var isOptio5 = false

    
    
    @IBOutlet weak var lbDisable: UILabel!
    
    private var  pollUpdateArray : [PollUpdate] = []
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setBorderAndCornerRadius(layer: viewOfOptionsSelect.layer, width: 1.0, radius: 5.0, color: UIColor(red: 145/255.0, green: 157/255.0, blue: 205/255.0, alpha: 1.0))
        
        WAShareHelper.setBorderAndCornerRadius(layer: txtPost.layer, width: 1.0, radius: 0.0, color: UIColor.groupTableViewBackground)
        txtPost.text = post?.comment
     
//        btnSelectGroup.setTitle(post?.groupInfo?.name, for: .normal)
//        groupBarCode = post?.groupInfo?.barcode
//        groupId = post?.groupInfo?.id
        
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
        
        if post?.postOption?.count == 2 {
            
            txtOption1.text = post?.postOption![0].name
            txtOption2.text = post?.postOption![1].name
            
            let items: [PollUpdate] = [
                PollUpdate(id: (post?.postOption![0].id)! , comment: (post?.postOption![0].name)!),
                PollUpdate(id: (post?.postOption![1].id)! , comment: (post?.postOption![1].name)!),
            ]
            
            self.isOptio1 = true
            self.isOptio2 = true
            self.isOptio3 = true
            self.isOptio4 = true
            self.isOptio5 = true

            self.pollUpdateArray = items

            heightOfOption.constant = 120.0
            heightOfMainView.constant = 806
            btnCross1.isHidden = true
            btnCross2.isHidden = true
            btnCross3.isHidden = true
            
            txtOption3.isHidden = true
            txtOption4.isHidden = true
            txtOption5.isHidden = true
            
                    viewOfOption3.isHidden = true
                    viewOfOption4.isHidden = true
                    viewOfOption5.isHidden = true
                    lblOption3.isHidden = true
                    lblOption4.isHidden = true
                    lblOption5.isHidden = true
//                    heightOfOption.constant = 120.0
//                    heightOfOption.constant = 120.0
        }
        
        else if post?.postOption?.count == 3 {
            
            txtOption1.text = post?.postOption![0].name
            txtOption2.text = post?.postOption![1].name
            txtOption3.text = post?.postOption![2].name
            heightOfMainView.constant = 820
            self.isOptio1 = true
            self.isOptio2 = true
            self.isOptio3 = true
            self.isOptio4 = true
            self.isOptio5 = true

            let items: [PollUpdate] = [
                PollUpdate(id: (post?.postOption![0].id)! , comment: (post?.postOption![0].name)!),
                PollUpdate(id: (post?.postOption![1].id)! , comment: (post?.postOption![1].name)!),
                PollUpdate(id: (post?.postOption![2].id)! , comment: (post?.postOption![2].name)!),

            ]
            
            self.pollUpdateArray = items

            
            txtOption3.isHidden = false
            lblOption3.isHidden = false
            btnCross1.isHidden = true
            viewOfOption3.isHidden = false
            if txtOption5.isHidden == true || txtOption4.isHidden == true {
                heightOfOption.constant = 150.0
            } else {
                heightOfOption.constant = 220.0
            }
            
            heightOfOption3.constant = 30.0
            
            
//            btnCross1.isHidden = true
            btnCross2.isHidden = true
            btnCross3.isHidden = true
            
//            txtOption3.isHidden = true
            txtOption4.isHidden = true
            txtOption5.isHidden = true
            
//            viewOfOption3.isHidden = true
            viewOfOption4.isHidden = true
            viewOfOption5.isHidden = true
//            lblOption3.isHidden = true
            lblOption4.isHidden = true
            lblOption5.isHidden = true

            
        }
        else if post?.postOption?.count == 4 {
            
            txtOption1.text = post?.postOption![0].name
            txtOption2.text = post?.postOption![1].name
            txtOption3.text = post?.postOption![2].name
            txtOption4.text = post?.postOption![3].name
            heightOfMainView.constant = 840.0

            self.isOptio1 = true
            self.isOptio2 = true
            self.isOptio3 = true
            self.isOptio4 = true
            self.isOptio5 = true

            let items: [PollUpdate] = [
                PollUpdate(id: (post?.postOption![0].id)! , comment: (post?.postOption![0].name)!),
                PollUpdate(id: (post?.postOption![1].id)! , comment: (post?.postOption![1].name)!),
                PollUpdate(id: (post?.postOption![2].id)! , comment: (post?.postOption![2].name)!),
                PollUpdate(id: (post?.postOption![3].id)! , comment: (post?.postOption![3].name)!),

                ]
            
            self.pollUpdateArray = items

            
            txtOption3.isHidden = false
            lblOption3.isHidden = false
            btnCross1.isHidden = true
            viewOfOption3.isHidden = false

            txtOption4.isHidden = false
            lblOption4.isHidden = false
            btnCross2.isHidden = true
            viewOfOption4.isHidden = false
            heightOfOption.constant = 220.0
            heightOfOption4.constant = 30.0
            
            
            btnCross1.isHidden = true
            btnCross2.isHidden = true
            btnCross3.isHidden = true
            
            txtOption3.isHidden = false
            txtOption4.isHidden = false
            txtOption5.isHidden = true
            
            viewOfOption3.isHidden = false
            viewOfOption4.isHidden = false
            viewOfOption5.isHidden = true
            
            lblOption3.isHidden = false
            lblOption4.isHidden = false
            lblOption5.isHidden = true

            
        } else if post?.postOption?.count == 5 {
            
            txtOption1.text = post?.postOption![0].name
            txtOption2.text = post?.postOption![1].name
            txtOption3.text = post?.postOption![2].name
            txtOption4.text = post?.postOption![3].name
            txtOption5.text = post?.postOption![4].name
            heightOfMainView.constant = 860.0
            self.isOptio1 = true
            self.isOptio2 = true
            self.isOptio3 = true
            self.isOptio4 = true
            self.isOptio5 = true

            let items: [PollUpdate] = [
                PollUpdate(id: (post?.postOption![0].id)! , comment: (post?.postOption![0].name)!),
                PollUpdate(id: (post?.postOption![1].id)! , comment: (post?.postOption![1].name)!),
                PollUpdate(id: (post?.postOption![2].id)! , comment: (post?.postOption![2].name)!),
                PollUpdate(id: (post?.postOption![3].id)! , comment: (post?.postOption![3].name)!),
                PollUpdate(id: (post?.postOption![4].id)! , comment: (post?.postOption![4].name)!),

                
                ]
            
            self.pollUpdateArray = items

            txtOption3.isHidden = false
            lblOption3.isHidden = false
            btnCross1.isHidden = true
            viewOfOption3.isHidden = false
            
            txtOption4.isHidden = false
            lblOption4.isHidden = false
            btnCross2.isHidden = true
            viewOfOption4.isHidden = false
//            heightOfOption.constant = 220.0
            heightOfOption4.constant = 30.0
            
            txtOption5.isHidden = false
            lblOption5.isHidden = false
            btnCross3.isHidden = true
            viewOfOption5.isHidden = false
            heightOfOption.constant = 220
            heightOfOption5.constant = 30.0

            
        }
        
//        txtOption1.addTarget(self, action: #selector(UBEditPollVC.option1(_:)), for: UIControl.Event.editingChanged)
//        txtOption2.addTarget(self, action: #selector(UBEditPollVC.option2(_:)), for: UIControl.Event.editingChanged)
        txtOption3.addTarget(self, action: #selector(UBEditPollVC.option3(_:)), for: UIControl.Event.editingChanged)
        txtOption4.addTarget(self, action: #selector(UBEditPollVC.option4(_:)), for: UIControl.Event.editingChanged)
        txtOption5.addTarget(self, action: #selector(UBEditPollVC.option5(_:)), for: UIControl.Event.editingChanged)
//
        
//        @IBOutlet weak var txtOption1: UITextField!
//        @IBOutlet weak var txtOption2: UITextField!
//        @IBOutlet weak var txtOption3: UITextField!
//        @IBOutlet weak var txtOption4: UITextField!
//        @IBOutlet weak var txtOption5: UITextField!


        // Do any additional setup after loading the view.
    }
    
    
//    @objc func option1(_ textField: UITextField) {
//        if txtOption1.text!.count > 0 {
//            isOptio1 = true
//        } else {
//             isOptio1 = fal
//        }
//    }
//    @objc func option2(_ textField: UITextField) {
//        if txtOption2.text!.count > 0 {
//        } else {
//
//        }
//    }
//
    @objc func option3(_ textField: UITextField) {
        if txtOption3.text!.count > 0 {
            isOptio3 = true

        } else {
            isOptio3 = false
//            isOption3Select = true

        }
    }

    @objc func option4(_ textField: UITextField) {
        if txtOption4.text!.count > 0 {
//            isOption4Select = false
            isOptio4 = true

        } else {
            isOptio4 = false

//            isOption4Select = true

        }
    }

    @objc func option5(_ textField: UITextField) {
        if txtOption5.text!.count > 0 {
            isOptio5 = true
        } else {
            isOptio5 = false

        }
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
    
//    @IBAction func btnDisableComment_Pressed(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected == true {
//            isDisbaleComent = 1
//        } else {
//            isDisbaleComent = 0
//        }
//    }

    @IBAction func btnAddOption_Pressed(_ sender: UIButton) {
//        if txtOption3.isHidden == true {
//            txtOption3.isHidden = false
//            lblOption3.isHidden = false
//            btnCross1.isHidden = false
//            viewOfOption3.isHidden = false
//            if txtOption5.isHidden == true || txtOption4.isHidden == true {
//                heightOfOption.constant = 150.0
//            } else {
//                heightOfOption.constant = 220.0
//            }
//
//            heightOfOption3.constant = 30.0
//
//        } else if txtOption4.isHidden == true {
//            txtOption4.isHidden = false
//            lblOption4.isHidden = false
//            btnCross2.isHidden = false
//            viewOfOption4.isHidden = false
//            heightOfOption.constant = 220.0
//            heightOfOption4.constant = 30.0
//
//
//        } else if txtOption5.isHidden == true {
//            txtOption5.isHidden = false
//            lblOption5.isHidden = false
//            btnCross3.isHidden = false
//            viewOfOption5.isHidden = false
//            heightOfOption.constant = 220
//            heightOfOption5.constant = 30.0
//        }
        
        
        
        
    }
    @IBAction func btnOption1_Pressed(_ sender: UIButton) {
//        txtOption3.isHidden = true
//        lblOption3.isHidden = true
//        btnCross1.isHidden = true
//        viewOfOption3.isHidden = true
//        heightOfOption.constant = 200
//        heightOfOption3.constant = 0.0
//
//        pollArray.removeAll { $0 == txtOption3.text }
//
//        //        if pollArray.contains(txtOption3.text!) {
//        //            let string = txtOption3.text!
//        //             pollArray.removeAll { (string) -> Bool in
//        //             print(pollArray)
//        //             return true
//        //            }
//        //        }
//        txtOption3.text = ""
        
    }
    
    @IBAction func btnOption2_Pressed(_ sender: UIButton) {
//        txtOption4.isHidden = true
//        lblOption4.isHidden = true
//        btnCross2.isHidden = true
//        viewOfOption4.isHidden = true
//        heightOfOption.constant = 200.0
//        heightOfOption4.constant = 0.0
//        pollArray.removeAll { $0 == txtOption4.text }
//
////        pollArray.removeAll { $0 == txtOption4.text }
//
//        txtOption4.text = ""
        
    }
    
    @IBAction func btnOption3_Pressed(_ sender: UIButton) {
//        txtOption5.isHidden = true
//        lblOption5.isHidden = true
//        btnCross3.isHidden = true
//        viewOfOption5.isHidden = true
//        heightOfOption.constant = 180.0
//        heightOfOption5.constant = 0.0
//        pollArray.removeAll { $0 == txtOption5.text }
//
//        
////        pollArray.removeAll { $0 == txtOption5.text }
//        
//        txtOption5.text = ""
        
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

    func encodeParamters(_ parameters: [String : Any]) {
        do {
            let json = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print(error)
        }
    }

    @IBAction private func btnCreatePost_Pressed(_ sender : UIButton) {
        
        if Connectivity.isConnectedToInternet() {
        var param = [:] as [String : Any]
//
//        if txtOption1.text!.count > 0 &&  txtOption2.text!.count > 0  {
//            pollArray.append(txtOption1.text!)
//            pollArray.append(txtOption2.text!)
//        } else {
//            self.showAlert(title: KMessageTitle  , message: "Please Enter the Option1 or Option 2", controller: self)
//        }
//        if txtOption3.text!.count  > 0 {
//            pollArray.append(txtOption3.text!)
//        }
//
//        if txtOption4.text!.count > 0 {
//            pollArray.append(txtOption4.text!)
//        }
//        if txtOption5.text!.count > 0 {
//            pollArray.append(txtOption5.text!)
//        }
//
        
        if txtPost.text.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Please Enter the comment".localized() , controller: self)
        }
        else if txtOption1.text!.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 1".localized() , controller: self)
        }
            
        else if txtOption2.text!.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 2".localized() , controller: self)
        }
        else if isOptio3 == false {
            self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 3".localized() , controller: self)
        }
            
        else if isOptio4 == false {
            self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 4".localized() , controller: self)
        }
        else if isOptio5 == false {
            self.showAlert(title: KMessageTitle, message: "Please Enter the value of option 5".localized() , controller: self)
        } else {
                    if post?.postOption?.count == 2 {
                        let items: [PollUpdate] = [
                            PollUpdate(id: (post?.postOption![0].id)! , comment: txtOption1.text!),
                            PollUpdate(id: (post?.postOption![1].id)! , comment: txtOption2.text!),
                        ]
            
                        self.pollUpdateArray = items
                    } else if post?.postOption?.count == 3 {
                        let items: [PollUpdate] = [
                            PollUpdate(id: (post?.postOption![0].id)! , comment: txtOption1.text!),
                            PollUpdate(id: (post?.postOption![1].id)! , comment: txtOption2.text!),
                            PollUpdate(id: (post?.postOption![2].id)! , comment: txtOption3.text!),
                        ]
                        self.pollUpdateArray = items
                    }
                    else if post?.postOption?.count == 3 {
                        let items: [PollUpdate] = [
                            PollUpdate(id: (post?.postOption![0].id)! , comment: txtOption1.text!),
                            PollUpdate(id: (post?.postOption![1].id)! , comment: txtOption2.text!),
                            PollUpdate(id: (post?.postOption![2].id)! , comment: txtOption3.text!),
                            ]
                        self.pollUpdateArray = items
                    } else if post?.postOption?.count == 4 {
                        let items: [PollUpdate] = [
                            PollUpdate(id: (post?.postOption![0].id)! , comment: txtOption1.text!),
                            PollUpdate(id: (post?.postOption![1].id)! , comment: txtOption2.text!),
                            PollUpdate(id: (post?.postOption![2].id)! , comment: txtOption3.text!),
                            PollUpdate(id: (post?.postOption![3].id)! , comment: txtOption4.text!),
                            ]
                        self.pollUpdateArray = items
                    } else if post?.postOption?.count == 5 {
                        let items: [PollUpdate] = [
                            PollUpdate(id: (post?.postOption![0].id)! , comment: txtOption1.text!),
                            PollUpdate(id: (post?.postOption![1].id)! , comment: txtOption2.text!),
                            PollUpdate(id: (post?.postOption![2].id)! , comment: txtOption3.text!),
                            PollUpdate(id: (post?.postOption![3].id)! , comment: txtOption4.text!),
                            PollUpdate(id: (post?.postOption![4].id)! , comment: txtOption5.text!),
                            ]
                        self.pollUpdateArray = items
                    }
                    let postId = post?.id
                    var pollString : String?
                    do {
                        let encoded = try JSONEncoder().encode(self.pollUpdateArray)
                        pollString = String(bytes: encoded, encoding: .utf8)
            //            print(String(bytes: encoded, encoding: .utf8))
                    } catch {
                        print(error)
                    }
                    let json: AnyObject? = pollString?.parseJSONString
                    print("Parsed JSON: \(json!)")
            
                    param = ["group_id"                       :   "\(groupId!)",
                            "group_barcode"                   :    groupBarCode! ,
                            "type"                            :    "1",
                            "comment"                         :    txtPost.text! ,
                            "disable_comments"                :    "\(isDisbaleComent)" ,
                            "options"                         :    json! ,
                            "post_id"                         :     "\(postId!)"
                           ]
            
                    SVProgressHUD.show(withStatus: "Loading".localized())
                    WebServiceManager.putJson(params:param as Dictionary<String, Any> , serviceName: UPDATEPOST , serviceType: "Login".localized(), modelType: UserResponse.self, success: { (responseData) in
                        if  let post = responseData as? UserResponse {
                            if post.status == true {
            
                                SVProgressHUD.show(withStatus: post.message)
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    SVProgressHUD.dismiss()
                                    self.delegate?.editPoll(obj: post.postReaction!, index: self.selectIndex!)
            //                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "postCreate"), object : nil, userInfo : nil)
                                    self.pollUpdateArray = []
                                    self.navigationController?.popViewController(animated: true)
                                })
                            } else {
                                 self.pollUpdateArray = []
                                self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                            }
                        }
                    }, fail: { (error) in
                        //
                    }, showHUD: true)
              }
         }
        else {
             self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection, controller: self)
        }
    }
    
    func isValidName(name: String) -> Bool {
        let decimalCharacters = NSCharacterSet.decimalDigits
        let decimalRange = name.rangeOfCharacter(from: decimalCharacters, options: String.CompareOptions.numeric, range: nil)
        
        if decimalRange != nil {
            return false
        }
        return true
    }


}

extension String
{
    var parseJSONString: AnyObject?
    {
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        if let jsonData = data
        {
            // Will return an object or nil if JSON decoding fails
            do
            {
                let message = try JSONSerialization.jsonObject(with: jsonData, options:.mutableContainers)
                if let jsonResult = message as? NSMutableArray
                {
                    print(jsonResult)
                    
                    return jsonResult //Will return the json array output
                }
                else
                {
                    return nil
                }
            }
            catch let error as NSError
            {
                print("An error occurred: \(error)")
                return nil
            }
        }
        else
        {
            // Lossless conversion of the string was not possible
            return nil
        }
    }
}
