//
//  UBGroupSelectorVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 25/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  
class UBGroupSelectorVC: UIViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    @IBOutlet weak var txtGroupName : UITextField!
    @IBOutlet weak var imgOfGroupIcon : UIImageView!
    var selectedList = [String]()
    var  selectFriendListId : String?

    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    var friendList : [FriendList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for (_ , obj) in (self.friendList?.enumerated())! {
            var idOfPost : String?
            idOfPost = obj.friend_user_id?.string
            selectedList.append(idOfPost!)
        }
        
        print(selectedList)
        postCollectionView.register(UINib(nibName: "FriendCollectionCell", bundle: nil), forCellWithReuseIdentifier: "FriendCollectionCell")
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBGroupSelectorVC.imageTappedForDp(img:)))
        imgOfGroupIcon.isUserInteractionEnabled = true
        imgOfGroupIcon.addGestureRecognizer(tapGestureRecognizerforDp)

    }
    
    @objc func imageTappedForDp(img: AnyObject)
    {
        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) {[weak self] (orignal, edited) in
            
//            self!.imgOfGroupIcon.image = orignal
//            let cgFloat: CGFloat = self!.imgOfGroupIcon.frame.size.width/2.0
//            let someFloat = Float(cgFloat)
//            WAShareHelper.setViewCornerRadius(self!.imgOfGroupIcon, radius: CGFloat(someFloat))
//            self!.cover_image = orignal
            
            let vc = PhotoTweaksViewController(image: orignal)
            vc?.delegate = self
            vc?.autoSaveToLibray = false
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
    }

    @IBAction private func btnCreateGroup_Pressed(_ sender : UIButton) {
        selectFriendListId  = selectedList.map({"\($0)"}).joined(separator: ",")
        let params =      [ "name"                      :  txtGroupName.text!  ,
                            "friends"                    :  selectFriendListId! ,
                          ] as [String : Any]
        SVProgressHUD.show()
        WebServiceManager.multiPartImage(params: params as Dictionary<String, AnyObject> , serviceName: CREATEGROUP, imageParam:"logo", imgFileName: "logo.png", serviceType: "Sign Up".localized(), profileImage: imgOfGroupIcon.image, cover_image_param: "", cover_image: nil , modelType: UserResponse.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()

            let responseObj = response as! UserResponse
            if responseObj.status == true {
//                self?.showAlertViewWithTitle(title: KMessageTitle, message: responseObj.message! , dismissCompletion: {
                    let nc = NotificationCenter.default
                    nc.post(name: Notification.Name("CreateGroup"), object: nil)
                    self?.navigationController?.popToRootViewController(animated: true)
//                })
            }
            else
            {
                self!.showAlert(title: KMessageTitle, message: responseObj.message!, controller: self)
                
            }
            
        }) { [weak self](error) in
            
            
        }
        
    }


   

}

extension UBGroupSelectorVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if  self.friendList?.isEmpty == false {
            numOfSections = 1
            postCollectionView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: postCollectionView.bounds.size.width, height: postCollectionView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Friend Select.".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            postCollectionView.backgroundView = noDataLabel
            //            collectionViewCell.separatorStyle = .none
        }
        return numOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.friendList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FriendCollectionCell", for: indexPath) as! FriendCollectionCell

        cell.lblName.text =  friendList![indexPath.row].friendProfile?.full_name
        cell.delegate = self
        cell.indexSelect = indexPath
        guard  let image = friendList![indexPath.row].friendProfile?.profile_image  else   {
            return cell
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfFriend!), placeHolder: "profile2")
        let cgFloat: CGFloat = cell.imgOfFriend.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(cell.imgOfFriend, radius: CGFloat(someFloat))

        
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.postCollectionView.frame.size.width/6 - 1
        return CGSize(width: sizeOfCell, height: 80)
    }
}

extension UBGroupSelectorVC: PhotoTweaksViewControllerDelegate {
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        _ = controller.navigationController?.popViewController(animated: true)
        self.imgOfGroupIcon.image = croppedImage
        self.cover_image = croppedImage
        let cgFloat: CGFloat = self.imgOfGroupIcon.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfGroupIcon, radius: CGFloat(someFloat))
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
}

extension UBGroupSelectorVC :  RemoveFriendDelegate {
    func removeItem(cell: FriendCollectionCell, selectIndex: IndexPath) {
        let obj = friendList![selectIndex.row]
        if let index  = self.friendList?.index(where: {$0.id == obj.id}) {
            self.friendList?.remove(at: index)
            self.selectedList.remove(at: index)
        }
        self.postCollectionView.reloadData()

//        if cell.btnSelect.isSelected == true {
//            self.isSelectedFriend.append(obj!.id!)
//            friendList?.append(obj!)
//        } else {
//            if let removeIndex = self.isSelectedFriend.index(where: {$0 == obj?.id}) {
//                self.isSelectedFriend.remove(at: removeIndex)
//            }
//        }

    }
}



extension Int
{
    var string:String {
        get {
            return String(self)
        }
    }
}
