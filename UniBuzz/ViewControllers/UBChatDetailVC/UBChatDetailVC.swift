//
//  UBChatDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import HSPopupMenu
import GrowingTextView
import IQKeyboardManagerSwift
import AlamofireObjectMapper
import ObjectMapper
import ActionSheetPicker_3_0
import Photos
  
protocol DeleteGroupDelegate : class {
    func deleteGroupFromList(checkIndex : Int)
    func updateView(selectChat : ChatList  , indexSelect : Int)
}

  
  

class UBChatDetailVC: UIViewController  , UIGestureRecognizerDelegate   {
    @IBOutlet weak var tblViewss: UITableView!
    var menuArray: [String] = []
    var selectGroupOrUser : ChatList?
    var inboxChat : UserResponse?
    var userObj : Session?
    
    @IBOutlet weak var imgOfIcon: UIImageView!
    @IBOutlet weak var lblGroupName: UILabel!
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var txtMessage : GrowingTextView!
    @IBOutlet weak var viewOfChat: UIView!
    @IBOutlet weak var btnMessageSend : UIButton!
    var groupChatMenu : [String] = []
    var isReply : Bool?
    var parentMessage : Int?
    @IBOutlet weak var viewOfReply: UIView!
    @IBOutlet weak var lblParentMessage: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var bottomViewBottomSpaceConstant : NSLayoutConstraint!
    @IBOutlet weak var chatViewBottomConstraint : NSLayoutConstraint!
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    var selectIndex : Int?
    weak var delegate : DeleteGroupDelegate?
    @IBOutlet weak var btnSideMenu : UIButton!
    
    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    var morePhotos: [UIImage]? = []
    @IBOutlet weak var addItemCollectionView: UICollectionView!
    @IBOutlet weak var viewOfImages : UIView!
    var isSelectImage : Bool?
    @IBOutlet weak var viewOfForwardOrDeleteMessage : UIView!
    var indexOfSelectedMessage : IndexPath?
    //    let photoPicker = PhotoPicker()
    //    var morePhotos: [UIImage]? = []
    let imagePicker = UIImagePickerController()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        appDelegate.isChatView = true
        isReply = false
        isSelectImage = false
        viewOfImages.isHidden = true
        btnSideMenu.isUserInteractionEnabled = false
        tblViewss.registerCells([
            SenderCell.self ,  ReceiverCell.self , TypeMessageCell.self , SenderReplyCell.self , RecieverReplyCell.self , BookOrClassifiedCell.self , BookOrClassifiedReceiverCell.self  , MorePhotoCellSender.self , MultiplePhotoCell.self , SinglePhotoCellSender.self , MorePhotoCellSender.self , MultiplePhotoReceiverCell.self , SinglePhotoReceiverCell.self , MorePhotoReceiverCell.self
        ])
        self.navigationController!.interactivePopGestureRecognizer!.delegate = self
        if self.selectGroupOrUser!.unreadMessageCount! > 0 {
            appDelegate.badgeCount  = appDelegate.badgeCount - self.selectGroupOrUser!.unreadMessageCount!
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGesture)
        //        IQKeyboardManager.shared.disabledToolbarClasses.append(UBChatDetailVC.self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didMessageDisplay(_:)), name: NSNotification.Name(rawValue: "messageReciver"), object: nil)
        
        let tapGestures = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard(_:)))
        self.view.addGestureRecognizer(tapGestures)
        IQKeyboardManager.shared.disabledToolbarClasses.append(UBChatDetailVC.self)
        IQKeyboardManager.shared.enable = false
        
        let tapGestureRecognizerfor = UITapGestureRecognizer(target:self, action:#selector(UBChatDetailVC.imageTappedForDp))
        viewOfForwardOrDeleteMessage.isUserInteractionEnabled = true
        tapGestureRecognizerfor.delegate = self
        viewOfForwardOrDeleteMessage.addGestureRecognizer(tapGestureRecognizerfor)
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        if selectGroupOrUser?.is_group == true {
            self.lblGroupName.text = selectGroupOrUser?.group_name
            guard  let image = selectGroupOrUser?.group_image  else   {
                return imgOfIcon.image = UIImage(named: "User")
            }
            self.imgOfIcon.setImage(with: image, placeholder: UIImage(named: "profile2"))
            let cgFloat: CGFloat = self.imgOfIcon.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(self.imgOfIcon, radius: CGFloat(someFloat))
        } else {
            
            if selectGroupOrUser?.identity_type == 1 {
                
                if selectGroupOrUser?.dtail?.user_id == userObj?.id  {
                    self.lblGroupName.text = selectGroupOrUser?.chatUser?.full_name
                    guard  let image = selectGroupOrUser?.chatUser?.profile_image  else   {
                        return imgOfIcon.image = UIImage(named: "User")
                    }
                    self.imgOfIcon.setImage(with: image, placeholder: UIImage(named: "profile2"))
                    
                    let cgFloat: CGFloat = self.imgOfIcon.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(self.imgOfIcon, radius: CGFloat(someFloat))
                } else {
                    lblGroupName.text  = "Anonymous".localized()
                    imgOfIcon.image = UIImage(named: "anonymous_icon")
                    let cgFloat: CGFloat = imgOfIcon.frame.size.width/2.0
                    let someFloat = Float(cgFloat)
                    WAShareHelper.setViewCornerRadius(imgOfIcon , radius: CGFloat(someFloat))
                    
                }
                
            } else {
                self.lblGroupName.text = selectGroupOrUser?.chatUser?.full_name
                guard  let image = selectGroupOrUser?.chatUser?.profile_image  else   {
                    return imgOfIcon.image = UIImage(named: "User")
                }
                self.imgOfIcon.setImage(with: image, placeholder: UIImage(named: "profile2"))
                
                let cgFloat: CGFloat = self.imgOfIcon.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(self.imgOfIcon, radius: CGFloat(someFloat))
                
            }
            
        }
        guard  let img = userObj?.profile_image  else   {
            return imgOfUser.image = UIImage(named: "User")
        }
        WAShareHelper.loadImage(urlstring:img , imageView: (self.imgOfUser!), placeHolder: "profile2")
        let cgFloats: CGFloat = self.imgOfUser.frame.size.width/2.0
        let someFloats = Float(cgFloats)
        WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloats))
        getInboxChat()
        
    }
    
    @objc func imageTappedForDp()
    {
        self.view.endEditing(true)
        self.viewOfForwardOrDeleteMessage.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addItemCollectionView.delegate = self
        addItemCollectionView.dataSource = self
        addItemCollectionView.reloadData()
        
        //self.revealController.recognizesPanningOnFrontView = false
        self.navigationController!.interactivePopGestureRecognizer!.isEnabled = true
        self.viewOfForwardOrDeleteMessage.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //    deinit {
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //
    //        NotificationCenter.default.removeObserver(self)
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self)
        selectGroupOrUser?.unreadMessageCount = 0
        delegate?.updateView(selectChat: selectGroupOrUser! , indexSelect: selectIndex!)
        appDelegate.isChatView = true 
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return (otherGestureRecognizer is UIScreenEdgePanGestureRecognizer)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        txtMessage.resignFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        print("<<<<<<<<< UBChatDetailVC delloc")
    }
    
    @IBAction func cameraButtonAction(_ sender: Any) {
    }
    
    
    // Message Receiver Notifications
    @objc func didMessageDisplay(_ notification: NSNotification) {
        
        let messagess = notification.object as? NSDictionary
        
        guard let message = messagess!["data"]  else {
            return
        }
        let stringObj = messagess!["data"] as? NSDictionary
        //        let stringObj = messagess!["data"] as? NSDictionary
        let jsonData = try? JSONSerialization.data(withJSONObject: stringObj!, options: [])
        let jsonString = String(data: jsonData!, encoding: .utf8)
        let messageObj = Mapper<AllMessages>().map(JSONString: jsonString!)
        if self.selectGroupOrUser?.id == messageObj?.chat_id {
            self.inboxChat?.listOfChat?.listOfAllMessage?.append((messageObj)!)
            self.tblViewss.reloadData()
            guard  let itemCount =  self.inboxChat?.listOfChat?.listOfAllMessage?.count  else {
                return
            }
            if (self.inboxChat?.listOfChat?.listOfAllMessage!.count)! > 2 {
                self.tblViewss.scrollToBottom()
            }
        }
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification) {
        
        if Connectivity.isConnectedToInternet() {
            let userInfo:NSDictionary = notification.userInfo! as NSDictionary
            let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.chatViewBottomConstraint.constant = keyboardHeight + 5
            if ((self.inboxChat?.listOfChat?.listOfAllMessage!.count)!) > 0 {
                self.tblViewss.scrollToBottom()
            }
            self.bottomViewBottomSpaceConstant.constant = 0
        }
    }
    
    @objc func keyboardWillHide(notification:NSNotification)  {
        self.bottomViewBottomSpaceConstant.constant = 0.0
        self.chatViewBottomConstraint.constant = 10.0
    }
    
    func checkBlock() {
        
    }
    
    func getInboxChat() {
        let chatId = selectGroupOrUser?.id
        let serviceUrl = "\(INBOXCHAT)/\(chatId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Inbox Chat".localized(), modelType: UserResponse.self, success: { [weak self ] (response) in
            guard let self = self else {return}
            self.inboxChat = (response as! UserResponse)
            self.btnSideMenu.isUserInteractionEnabled = true
            if self.inboxChat?.status == true {
            if  self.inboxChat?.listOfChat?.chatUser?.bbm == true    {
                    self.menuArray.append("Clear Chat".localized())
                    self.menuArray.append("Un Block User".localized())
                    
                } else {
                    self.menuArray.append("Clear Chat".localized())
                    self.menuArray.append("Block User".localized())
                }
                
                if self.inboxChat?.listOfChat?.chatUser?.is_blocked == true {
                    self.viewOfChat.isHidden = true
                } else {
                    self.viewOfChat.isHidden = false
                }
                if self.selectGroupOrUser?.is_group == true {
                    if self.selectGroupOrUser?.sender_id == self.userObj?.id  {
                        self.groupChatMenu.append("Group Info".localized())
                        self.groupChatMenu.append("Add Participants".localized())
                        self.groupChatMenu.append("Clear Chat".localized())
                        self.groupChatMenu.append("Delete Group".localized())
                    } else {
                        self.groupChatMenu.append("Group Info".localized())
                        self.groupChatMenu.append("Leave Group".localized())
                        self.groupChatMenu.append("Clear Chat".localized())
                    }
                }
                self.inboxChat?.listOfChat?.listOfAllMessage?.reverse()
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.estimatedRowHeight = 50.0
                self.tblViewss.rowHeight = UITableView.automaticDimension
                self.tblViewss.reloadData()
                if (self.inboxChat?.listOfChat?.listOfAllMessage!.count)! > 0 {
                    self.tblViewss.scrollToBottom()
                }
            } else {
                self.showAlert(title: KMessageTitle, message: (self.inboxChat?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    @IBAction private func btnBack_Pressed(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func btnCrossAttachFile(_ sender : UIButton) {
        self.morePhotos = []
        self.viewOfImages.isHidden = true
    }
    
    @IBAction private func btnRightMenu_Pressed(_ sender : UIButton) {
        if self.inboxChat?.listOfChat?.is_group == true {
            ActionSheetStringPicker.show(withTitle: "", rows: self.groupChatMenu , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                if index == 0 {
                    let vc = self!.storyboard?.instantiateViewController(withIdentifier: "UBGroupInfoVC") as? UBGroupInfoVC
                    vc?.selectGroupOrUser = self!.selectGroupOrUser
                    self!.navigationController?.pushViewController(vc!, animated: true)
                }
                else if index == 1 {
                    let vc = self!.storyboard?.instantiateViewController(withIdentifier: "UBAddParticipantVC") as? UBAddParticipantVC
                    vc?.selectGroupOrUser = self!.selectGroupOrUser
                    self!.navigationController?.pushViewController(vc!, animated: true)
                }
                else if index == 2 {
                    self!.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this Chat ?".localized()) {
                        self!.deleteChat()
                    }
                    
                }
                    
                else if index == 3 {
                    self!.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this  group?".localized()) {
                        self!.deleteGroup()
                        
                    }
                    
                    
                }
                return
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        } else {
            
            ActionSheetStringPicker.show(withTitle: "", rows: self.menuArray , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
                if index == 0 {
                    self!.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this Chat ?".localized()) {
                        self!.deleteChat()
                        
                    }
                } else if index == 1 {
                    
                    self!.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to block this  User?".localized()) {
                        self!.viewOfChat.isHidden = true
                        self!.blockUser()
                    }
                }
                return
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
    }
    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        if Connectivity.isConnectedToInternet() {
            if isSelectImage == false {
                if txtMessage.text.count > 0 {
                    self.btnMessageSend.isUserInteractionEnabled = false
                    self.btnMessageSend.setImage(UIImage(named: "sendUn"), for: .normal)
                    let chatId = selectGroupOrUser?.id
                    var param = [:] as [String : Any]
                    if isReply == true {
                        param = ["chat_id"            : "\(chatId!)",
                            "message"            :  txtMessage.text! ,
                            "parent_id"          :  "\(parentMessage!)"
                        ]
                    } else {
                        param = [       "chat_id"            : "\(chatId!)",
                            "message"            :  txtMessage.text!
                        ]
                    }
                    var imge : UIImage?
                    WebServiceManager.mutliChat(params: param as Dictionary<String, AnyObject> , serviceName: CHATMESSAGE, imageParam:KImageParam, imgFileName: KImageFileName, serviceType: "", profileImage: imge  , cover_image_param: "", cover_image: nil , modelType: MessageObject.self, success: {[weak self] (response) in
                        if  let post = response as? MessageObject {
                            if post.status == true {
                                self?.viewOfReply.isHidden = true
                                self?.viewOfImages.isHidden = true
                                self?.morePhotos = []
                                self?.isSelectImage = false
                                
                                self!.inboxChat?.listOfChat?.listOfAllMessage?.append(post.messagee!)
                                let JSONString = post.toJSONString(prettyPrint: true)
                                let userss = MessageObject(JSONString: JSONString!)
                                self!.isReply = false
                                SKSocketConnection.socketSharedConnection.sendMessage(keyName: "senderEvent", obj: userss!)
                                self!.tblViewss.reloadData()
                                self!.txtMessage.text = ""
                                self!.tblViewss.scrollToBottom()
                            }
                            else
                            {
                                self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                            }
                            
                        }}) { [weak self] (error) in
                    }
                }
            } else {
                
                var param = [:] as [String : Any]
                let chatId = selectGroupOrUser?.id
                
                param = [       "chat_id"   : "\(chatId!)",
                    "message"            :  txtMessage.text ?? " "
                ]
                var imge : UIImage?
                
                WebServiceManager.multiPartImageMorePhotosInChat(params: param  as Dictionary<String, AnyObject>, morePhotos: morePhotos , serviceName: CHATMESSAGE, imageParam: KImageParam , serviceType: "", profileImage: imge , cover_image_param: "", cover_image: nil, modelType: MessageObject.self, success: { (response) in
                    let parseResponse = response as! MessageObject
                    if parseResponse.status == true {
                        self.inboxChat?.listOfChat?.listOfAllMessage?.append(parseResponse.messagee!)
                        let JSONString = parseResponse.toJSONString(prettyPrint: true)
                        let userss = MessageObject(JSONString: JSONString!)
                        SKSocketConnection.socketSharedConnection.sendMessage(keyName: "senderEvent", obj: userss!)
                        self.tblViewss.reloadData()
                        self.txtMessage.text = ""
                        self.tblViewss.scrollToBottom()
                        
                        self.viewOfImages.isHidden = true
                        self.morePhotos = []
                        self.isSelectImage = false
                        
                    }else {
                        self.showAlert(title: "Error".localized(), message: parseResponse.message!, controller: self)
                    }
                }, fail: { (error) in
                    self.showAlert(title: "Error", message: "no internet".localized(), controller: self)
                    
                })
            }
            
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)
        }
        
    }
    
    @IBAction private func btnAttachImage(_ sender : UIButton) {
        if Connectivity.isConnectedToInternet() {
            self.bottomViewBottomSpaceConstant.constant = 0.0
            self.chatViewBottomConstraint.constant = 10.0
            self.txtMessage.resignFirstResponder()
            photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) { [weak self] (orignal, edited) in
                self?.morePhotos?.append(orignal!)
                self?.viewOfImages.isHidden = false
                self?.isReply = false
                self!.isSelectImage = true
                self!.btnMessageSend.isUserInteractionEnabled = true
                self!.btnMessageSend.setImage(UIImage(named: "send"), for: .normal)
                self?.addItemCollectionView.reloadData()
            }
            
        } else {
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)
            
        }
    }
    
    
    
    func deleteChat() {
        let idOfChat = self.selectGroupOrUser?.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(DELETECHAT)\(idOfChat!)"
        btnSideMenu.isUserInteractionEnabled = false
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    func blockUser() {
        let idOfChat = self.selectGroupOrUser?.chatUser?.id
        btnSideMenu.isUserInteractionEnabled = false
        let serviceUrl = "\(BLOCKEDUSER)\(idOfChat!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Block Chat".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let this = self else {
                return
            }
            this.inboxChat = (response as! UserResponse)
            if this.inboxChat?.status == true {
                this.viewOfChat.isHidden = true
                this.navigationController?.popViewController(animated: true)
            } else {
                this.showAlert(title: KMessageTitle, message: (this.inboxChat?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    func deleteGroup() {
        let idOfChat = self.selectGroupOrUser?.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(DESTROYGROUP)\(idOfChat!)"
        btnSideMenu.isUserInteractionEnabled = false
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { [weak self] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self!.delegate?.deleteGroupFromList(checkIndex: self!.selectIndex!)
                    self!.navigationController?.popViewController(animated: true)
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
            }, fail: { (error) in
        }, showHUD: true)
    }
    
    func LeaveGroup() {
        let idOfChat = self.selectGroupOrUser?.id
        btnSideMenu.isUserInteractionEnabled = false
        let serviceURl = "\(LEAVEGROUP)\(idOfChat!)/leave"
        let param =    [ : ] as [String : Any]
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    @IBAction private func btnCross_Pressed(_ sender : UIButton) {
        isReply = false
        viewOfReply.isHidden = true
        self.btnMessageSend.isUserInteractionEnabled = false
        self.btnMessageSend.setImage(UIImage(named: "sendUn"), for: .normal)
        
    }
    
    func alert(_ title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        vc.addAction(UIAlertAction(title: "Ok".localized(), style: .cancel, handler: nil))
        present(vc, animated: true, completion: nil)
    }
    
    
}

  
extension UBChatDetailVC: HSPopupMenuDelegate {
    func popupMenu(_ popupMenu: HSPopupMenu, didSelectAt index: Int) {
        if self.selectGroupOrUser?.is_group == true {
            if self.selectGroupOrUser?.sender_id == self.userObj?.id  {
                if index == 0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupInfoVC") as? UBGroupInfoVC
                    vc?.selectGroupOrUser = self.selectGroupOrUser
                    self.navigationController?.pushViewController(vc!, animated: true)
                    
                } else if index == 1 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddParticipantVC") as? UBAddParticipantVC
                    vc?.selectGroupOrUser = self.selectGroupOrUser
                    self.navigationController?.pushViewController(vc!, animated: true)
                }
                    
                else if index == 3 {
                    deleteGroup()
                }
                    
                else if index == 2 {
                    deleteChat()
                }
                //
            } else {
                if index == 0 {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupInfoVC") as? UBGroupInfoVC
                    vc?.selectGroupOrUser = self.selectGroupOrUser
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else if index == 1 {
                    self.LeaveGroup()
                } else {
                    deleteChat()
                }
            }
        } else {
            if index == 0 {
                deleteChat()
            } else if index == 1 {
                blockUser()
            }
            
        }
    }
    
    private func deleteMessage(messageId : Int) {
        let groupId = selectGroupOrUser?.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(DELETEMESSAGE)\(groupId!)/message/\(messageId)/destroy"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    @IBAction private func btnCopyMeMessage(_ sender : UIButton) {
        self.view.endEditing(true)
        viewOfForwardOrDeleteMessage.isHidden = true
        let copyString = self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].message
        let pastBoard = UIPasteboard.general
        pastBoard.string = copyString
    }
    
    @IBAction private func btnForwardMeMessage(_ sender : UIButton) {
        self.view.endEditing(true)
        viewOfForwardOrDeleteMessage.isHidden = true
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBForwardMessageVC") as? UBForwardMessageVC
        vc!.messageId = self.inboxChat?.listOfChat?.listOfAllMessage![self.indexOfSelectedMessage!.row].id
        vc!.delegate = self
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @IBAction private func btnReplyMeMessage(_ sender : UIButton) {
        self.view.endEditing(true)
        viewOfForwardOrDeleteMessage.isHidden = true
        if (self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].message_files?.count)! >  0 {
            self.isReply = true
            self.parentMessage = self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].id
            
            self.viewOfReply.isHidden = true
            self.viewOfImages.isHidden = false
            self.addItemCollectionView.reloadData()
        } else {
            self.isReply = true
            self.viewOfReply.isHidden = false
            self.parentMessage = self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].id
            self.lblName.text = self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].sender_name
            self.lblParentMessage.text = self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].message
        }
    }
    
    @IBAction private func btnDeleteMessage(_ sender : UIButton) {
        self.view.endEditing(true)
        viewOfForwardOrDeleteMessage.isHidden = true
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this message ?".localized()) {[weak self] in
            let messgeId = self!.inboxChat?.listOfChat?.listOfAllMessage![self!.indexOfSelectedMessage!.row].id
            self!.deleteMessage(messageId: messgeId!)
            if let index  =   self!.inboxChat?.listOfChat?.listOfAllMessage?.index(where: {$0.id == messgeId}) {
                self!.inboxChat?.listOfChat?.listOfAllMessage?.remove(at: index)
                self!.tblViewss.reloadData()
                self!.viewOfForwardOrDeleteMessage.isHidden = true
            }
        }
    }
}

  

extension UBChatDetailVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  self.inboxChat?.listOfChat?.listOfAllMessage!.isEmpty == false {
            numOfSections = 1
            tblViewss.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Messages .".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tblViewss.backgroundView = noDataLabel
            tblViewss.separatorStyle = .none
        }
        return numOfSections
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inboxChat?.listOfChat?.listOfAllMessage?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let message = self.inboxChat?.listOfChat?.listOfAllMessage?[indexPath.row] {
          let parent = message.parent_message?.messageFile?.count ?? 0
          let count = message.message_files?.count ?? 0
            let is_reply = message.is_reply ?? false
            if  message.type == 1 || message.type == 2 {
                if message.sender_id == userObj?.id  {
                    let cell = tableView.dequeueReusableCell(with:  BookOrClassifiedCell.self, for: indexPath)
                    cell.delegate = self
                    cell.setUPCell(message: message, indexPath: indexPath)
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(with:  BookOrClassifiedReceiverCell.self, for: indexPath)
                    cell.delegate = self
                    cell.setUPCell(message: message, indexPath: indexPath, selectedGroup: selectGroupOrUser, id: userObj?.id)
                    return cell
                }
            } else if message.type == 8 || message.type == 6 || message.type == 7 {
                let cell = tableView.dequeueReusableCell(with: TypeMessageCell.self, for: indexPath)
                cell.lblMessageType.text = message.message
                return cell
            } else {
                if message.sender_id == userObj?.id {
                    if parent == 1 || count == 1 {
                        let cell = tableView.dequeueReusableCell(with: SinglePhotoCellSender.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, isReply: is_reply)
                        return cell
                    } else if parent == 2 || count == 2 {
                        let cell = tableView.dequeueReusableCell(with: MultiplePhotoCell.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, isReply: is_reply)
                        return cell
                    } else if parent == 3 || count == 3 {
                        let cell = tableView.dequeueReusableCell(with: MorePhotoCellSender.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, isReply: is_reply)
                        return cell
                    } else if parent > 3 || count > 3  {
                        let cell = tableView.dequeueReusableCell(with: MorePhotoCellSender.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, isReply: is_reply)
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(with: SenderReplyCell.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath)
                        return cell
                    }
                } else {
                    if parent == 1 || count == 1 {
                        let cell = tableView.dequeueReusableCell(with: SinglePhotoReceiverCell.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, selectedGroup: selectGroupOrUser, id: userObj?.id, isReply: is_reply)
                        return cell
                    } else if parent == 2 || count == 2 {
                        let cell = tableView.dequeueReusableCell(with: MultiplePhotoReceiverCell.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, selectedGroup: selectGroupOrUser, id: userObj?.id, isReply: is_reply)
                        return cell
                    } else if parent > 3 || count > 3 {
                        let cell = tableView.dequeueReusableCell(with: MorePhotoReceiverCell.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, selectedGroup: selectGroupOrUser, id: userObj?.id, isReply: is_reply)
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(with: RecieverReplyCell.self, for: indexPath)
                        cell.delegate = self
                        cell.setUPCell(message: message, indexPath: indexPath, selectedGroup: selectGroupOrUser, id: userObj?.id, isReply: is_reply)
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //        if indexPath.row == (self.inboxChat?.listOfChat?.listOfAllMessage?.count)! - 1 { //you might decide to load sooner than -1 I guess...
        //                if isPageRefreshing == false {
        //                    isPageRefreshing = true
        //                    let count = (self.inboxChat?.listOfChat?.listOfAllMessage!.count)! - 1
        //                    let id = self.inboxChat?.listOfChat?.listOfAllMessage![count].id
        //                    if self.inboxChat?.listOfChat?.listOfAllMessage![indexPath.row].id ==  id {
        //                        print("Ahmad")
        ////                        self.makeRequest(pageSize: self.page)
        ////                        self.tblViewss.tableFooterView = self.activity
        ////                        self.activity.startAnimating()
        ////                        self.tblViewss.tableFooterView?.isHidden = false
        //
        //                    } else {
        //
        //                    }
        //
        //                }  else {
        //                }
        //
        //
        //        }
        
    }
    
    
}
  

extension UBChatDetailVC : SenderSubReplyDelegate {
    func sendSubReply(cell : SenderReplyCell , checkIndex : IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.view.endEditing(true)
        self.viewOfForwardOrDeleteMessage.isHidden = false
        
    }
    
}

  

extension UBChatDetailVC : ReceiverSubReplyDelegate {
    func receiveSubReply(cell : RecieverReplyCell , checkIndex : IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.view.endEditing(true)
        self.viewOfForwardOrDeleteMessage.isHidden = false
        
    }
    
}



  
extension UBChatDetailVC :  GrowingTextViewDelegate {
    
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        if txtMessage.text.count > 0 {
            self.btnMessageSend.isUserInteractionEnabled = true
            self.btnMessageSend.setImage(UIImage(named: "send"), for: .normal)
            
        } else {
            self.btnMessageSend.isUserInteractionEnabled = false
            self.btnMessageSend.setImage(UIImage(named: "sendUn"), for: .normal)
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtMessage.text.count > 0 {
            self.btnMessageSend.isUserInteractionEnabled = true
            self.btnMessageSend.setImage(UIImage(named: "send"), for: .normal)
        } else {
            self.btnMessageSend.isUserInteractionEnabled = false
            self.btnMessageSend.setImage(UIImage(named: "sendUn"), for: .normal)
        }
    }
    
}
  

extension UBChatDetailVC : SenderReplyDelegate {
    func sendReply(cell : SenderCell , checkIndex : IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
}
  

extension UBChatDetailVC : ReciverReplyDelegate {
    func receiverReply(cell: ReceiverCell, checkIndex: IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
    
}

  
extension UBChatDetailVC : MessageForwardDelegate {
    func messaegeForward(obj : MessageObject) {
        //        self.inboxChat?.listOfChat?.listOfAllMessage?.append(obj.messagee!)
        //        self.tblViewss.reloadData()
        //        if (self.inboxChat?.listOfChat?.listOfAllMessage!.count)! > 2 {
        //             self.tblViewss.scrollToBottom()
        //        }
        
    }
    
}
  
extension UBChatDetailVC : BookOrClassifiedSenderDetail {
    func bookOrClassifiedSenderDetail(cell : BookOrClassifiedCell , index : IndexPath ) {
        if self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type == 1  {
            //            if #available(iOS 13, *) {
            //
            //            }
            let storyboard = UIStoryboard.init(name: "Book", bundle: Bundle.main)
            guard let vc = storyboard.instantiateViewController(withIdentifier : "UBBookDetailVC" ) as?  UBBookDetailVC else {
                return
            }
            //            let vc = storyboard.instantiateViewController(withIdentifier: "UBBookDetailVC") as? UBBookDetailVC
            let bookId = self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type_id
            vc.bookId = bookId
            self.navigationController?.pushViewController(vc, animated: true )
            
        } else {
            let storyboard = UIStoryboard.init(name: "Classified", bundle: Bundle.main)
            
            guard let vc = storyboard.instantiateViewController(withIdentifier : "UBClassifiedDetailVC" ) as?  UBClassifiedDetailVC else {
                return
            }
            let bookId = self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type_id
            vc.bookId = bookId
            self.navigationController?.pushViewController(vc , animated: true )
        }
    }
    
    func forwardBookOrClassifiedMessage(cell : BookOrClassifiedCell , checkIndex : IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
}

  
extension UBChatDetailVC : BookOrClassifiedReceiverDetail {
    func bookOrClassifiedDetail(cell : BookOrClassifiedReceiverCell , index : IndexPath ) {
        if self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type == 1  {
            let storyboard = UIStoryboard.init(name: "Book", bundle: Bundle.main)
            guard let vc = storyboard.instantiateViewController(withIdentifier : "UBBookDetailVC") as?  UBBookDetailVC else {
                return
            }
            vc.bookId = self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type_id
            self.navigationController?.pushViewController(vc , animated: true )
        } else {
            if self.inboxChat?.listOfChat?.listOfAllMessage![index.row].details?.sub_category_id == 1 {
                let storyboard = UIStoryboard.init(name: "Classified", bundle: Bundle.main)
                guard let vc = storyboard.instantiateViewController(withIdentifier: "UBClassifiedCarDetailVC") as?  UBClassifiedCarDetailVC else {
                    return
                }
                let bookId = self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type_id
                vc.bookId = bookId
                self.navigationController?.pushViewController(vc , animated: true )
            } else {
                let storyboard = UIStoryboard.init(name: "Classified", bundle: Bundle.main)
                guard let vc = storyboard.instantiateViewController(withIdentifier : "UBClassifiedDetailVC" ) as?  UBClassifiedDetailVC else {
                    return
                }
                let bookId = self.inboxChat?.listOfChat?.listOfAllMessage![index.row].type_id
                vc.bookId = bookId
                self.navigationController?.pushViewController(vc , animated: true )
            }
        }
        
    }
    
    func forwardBookOrClassifiedReceiverMessage(cell : BookOrClassifiedReceiverCell , checkIndex : IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
}

  
extension UBChatDetailVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return  1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //        return  morePhotos?.count ?? 0
        if isReply == true {
            return (self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].message_files!.count)! + 1
        } else {
            return (morePhotos?.count)! + 1
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePhotoCell", for: indexPath) as! MorePhotoCell
        if isReply == true {
            if indexPath.row != self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].message_files!.count {
                guard  let img = self.inboxChat?.listOfChat?.listOfAllMessage![indexOfSelectedMessage!.row].message_files![indexPath.row].file_path  else   {
                    return cell
                }
                WAShareHelper.loadImage(urlstring:img , imageView: (cell.imagePhoto!), placeHolder: "profile2")
            } else {
            }
            
        } else {
            if indexPath.row != self.morePhotos?.count {
                cell.imagePhoto.image = morePhotos![indexPath.row]
            } else {
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid = collectionView.frame.size.width / 6
        return CGSize(width: wid, height: 70)
    }
    
}
  
extension UBChatDetailVC : PreviewImageDelegate {
    func receiverMorePhot(cell: MorePhotoReceiverCell, checkIndex: IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
        
    }
    
    
    func previewImageList(cell : MorePhotoReceiverCell , index : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBImageSlidesVC") as? UBImageSlidesVC
        vc?.listOfReceiverFile =  self.inboxChat?.listOfChat?.listOfAllMessage![index.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

  
extension UBChatDetailVC : PreviewSenderImageDelegate {
    
    func previewTwoImagesList(cell : MultiplePhotoCell , index : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBImageSlidesVC") as? UBImageSlidesVC
        vc?.listOfReceiverFile =  self.inboxChat?.listOfChat?.listOfAllMessage![index.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func sendReplyImage(cell : MultiplePhotoCell , checkIndex : IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
}

  
extension UBChatDetailVC : PreviewSenderSingleImageDelegate {
    func sendReplySingleImage(cell: SinglePhotoCellSender, checkIndex: IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
    
    
    func previewOneSenderImagesList(cell : SinglePhotoCellSender , index : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBImageSlidesVC") as? UBImageSlidesVC
        vc?.listOfReceiverFile =  self.inboxChat?.listOfChat?.listOfAllMessage![index.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
}

  
extension UBChatDetailVC : PreviewMoreSenderImageDelegate {
    func sendReplyMoreImageList(cell: MorePhotoCellSender, checkIndex: IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
    func previewMoreImagesList(cell : MorePhotoCellSender , index : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBImageSlidesVC") as? UBImageSlidesVC
        vc?.listOfReceiverFile =  self.inboxChat?.listOfChat?.listOfAllMessage![index.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

  
extension UBChatDetailVC : PreviewTwoReceiveImageDelegate {
    func receiveReplyTwoPhoto(cell: MultiplePhotoReceiverCell, checkIndex: IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
        
    }
    func previewTwoImagesListReceive(cell : MultiplePhotoReceiverCell , index : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBImageSlidesVC") as? UBImageSlidesVC
        vc?.listOfReceiverFile =  self.inboxChat?.listOfChat?.listOfAllMessage![index.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

  
extension UBChatDetailVC : PreviewOneReceiveImageDelegate {
    func reciverReplySingleImage(cell: SinglePhotoReceiverCell, checkIndex: IndexPath) {
        indexOfSelectedMessage = checkIndex
        self.viewOfForwardOrDeleteMessage.isHidden = false
    }
    
    func previewOneImagesListReceive(cell : SinglePhotoReceiverCell , index : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBImageSlidesVC") as? UBImageSlidesVC
        vc?.listOfReceiverFile =  self.inboxChat?.listOfChat?.listOfAllMessage![index.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}




