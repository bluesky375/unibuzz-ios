//
//  UBGroupCreateVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 05/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0


protocol GroupObjectDelegate : class {
    func createGroup(obj : GroupList)
}

class UBGroupCreateVC: UIViewController {
    @IBOutlet var relatedSView: UIStackView!
    @IBOutlet weak var avatarView: UIView!
    
    @IBOutlet weak var chooseAvatarLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var data: GroupData?
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var imgOfUser: UIImageView!
    @IBOutlet weak var txtGroupName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var btnCreateGroup: UIButton!
    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    var presenter: RegistrationPresenter?
    var groupObj : GroupList?
    var courseType: Courses?
    var avatar: Avatars?
    @IBOutlet weak var relatedStackVw: UIStackView!
    @IBOutlet weak var relatedToCourseButton: UIButton!
    @IBOutlet weak var couldNotFindButton: UIButton!
    @IBOutlet weak var professorTF: TextField!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var courseVw: UIView!
    @IBOutlet weak var courseCodeTF: TextField!
    @IBOutlet weak var courseNameLabel: TextField!
    @IBOutlet weak var selectCourseLabel: UILabel!
    weak var delegate : GroupObjectDelegate?
    var isUpdate: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnCreateGroup.layer.shadowOpacity = 0.5
        btnCreateGroup.layer.shadowOffset = CGSize(width: 3.0, height: 2.0)
        btnCreateGroup.layer.shadowRadius = 5.0
        btnCreateGroup.layer.shadowColor = UIColor(red: 98/255.0, green: 128/255.0, blue: 187/255.0, alpha: 1).cgColor
        
        presenter = RegistrationPresenter(delegate: self)
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBGroupCreateVC.imageTappedForDp(img:)))
        imgOfUser.isUserInteractionEnabled = true
        imgOfUser.addGestureRecognizer(tapGestureRecognizerforDp)
        if let groupObj = groupObj {
            txtGroupName.isUserInteractionEnabled = false
            chooseAvatarLabel.isHidden = true
            if let data = data , let avatars = data.avatars, let index = avatars.firstIndex(where: {$0.name! == groupObj.logo!}) {
                let imageUrl = "\(data.base_url ?? "")/\(avatars[index].name ?? "")"
                self.avatar = avatars[index]
                WAShareHelper.loadImage(urlstring: imageUrl , imageView: imgOfUser, placeHolder: "")
                let cgFloat : CGFloat = imgOfUser.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(imgOfUser, radius: CGFloat(someFloat))
            }
            imgOfUser.isUserInteractionEnabled = false
            txtDescription.text = groupObj.description
            txtGroupName.text = groupObj.name
            relatedSView.isHidden = true
            titleLabel.text = "Update Group"
            btnCreateGroup.setTitle("Update", for: .normal)
            txtGroupName.text = groupObj.name
            professorTF.text = groupObj.professor
            
        }
        
        let tapGestureRecognizerfor = UITapGestureRecognizer(target:self, action:#selector(UBGroupCreateVC.imageTappedFor(img:)))
        avatarView.isUserInteractionEnabled = true
        tapGestureRecognizerfor.delegate = self
        avatarView.addGestureRecognizer(tapGestureRecognizerfor)
    }
    
    @objc func imageTappedForDp(img: AnyObject)
    {
        self.view.endEditing(true)
        self.avatarView.isHidden = false
    }
    
    @objc func imageTappedFor(img: AnyObject)
    {
        avatarView.isHidden = true
    }
    
    
    @IBAction func relatedToCourseButtonAction(_ sender: UIButton) {
        self.selectCourseLabel.text = "name"
        self.couldNotFindButton.isSelected = false
        sender.isSelected = !sender.isSelected
        self.setView(view: relatedStackVw, hidden: !sender.isSelected )
    }
    @IBAction func selectCourseButtonAction(_ sender: Any) {
        if let data = data?.courses, data.count > 0 {
            var temp = data
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            let values = temp.map({$0.name!})
            ActionSheetStringPicker.show(withTitle: "Select Course".localized(), rows: values , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.selectCourseLabel.text = value
                self.courseType = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
    }
    @IBAction func couldNotFoundCourseButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.setView(view: courseVw, hidden: !sender.isSelected )
    }
    
    @IBAction func btnCreateGroup(_ sender: UIButton) {
        presenter?.GroupCreate(groupName: txtGroupName.text!, groupDes: txtDescription.text!)
    }
    
    func setView(view: UIView, hidden: Bool) {
        view.isHidden = hidden
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension UBGroupCreateVC: PhotoTweaksViewControllerDelegate {
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        _ = controller.navigationController?.popViewController(animated: true)
        self.imgOfUser.image = croppedImage
        self.cover_image = croppedImage
        let cgFloat: CGFloat = self.imgOfUser.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloat))
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}

extension UBGroupCreateVC: RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed() {
        var  params: [String: Any] =  [
            "name": txtGroupName.text!,
            "description":  txtDescription.text!,
        ]
        
        if !isUpdate {
            params["professor"] = professorTF.text!
            params["android"] = true
            params["course_credit"] = 12
            params["new_course"] = self.couldNotFindButton.isSelected
            params["is_course"] = self.relatedToCourseButton.isSelected
            if let course = self.courseType {
                params["course_id"] = "\(course.id ?? 0)"
                params["course_name"] = "\(course.name ?? "")"
                params["course_code"] = "\(course.course_code ?? "")"
            } else {
                params["course_id"] = ""
                params["course_name"] = courseCodeTF.text!
                params["course_code"] = courseCodeTF.text!
            }
        }
        
        if let avatar = self.avatar {
            params["logo"] = "\(avatar.id ?? 0)"
        } else {
            self.registrationDidFailed(message: StringConstants.selectIcon)
            return
        }

        if let id = self.groupObj?.id {
            params["group_id"] = "\(id)"
        }
        
        SVProgressHUD.show(withStatus: "Loading")
        WebServiceManager.postJson(params: params as Dictionary<String, AnyObject>, serviceName: isUpdate ? GROUPUPDATE : GROUPCREATE, serviceType: "Sign Up".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let response = response as? UserResponse {
                    if response.status == true {
                        if self.isUpdate {
                            self.groupObj?.description = self.txtDescription.text
                            self.groupObj?.name = self.txtGroupName.text
                            self.groupObj?.logo = self.avatar?.name
                            self.groupObj?.group_thumb = "\(self.data?.base_url ?? "" )/\(self.avatar?.name ?? "")"
                            self.delegate?.createGroup(obj: self.groupObj!)
                        }
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showAlert(title: KMessageTitle, message: response.message!, controller: self)
                    }
                }
            }
            
            }, fail: { (error) in
                
        }, showHUD: true)
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}

extension UBGroupCreateVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if let avatars = data?.avatars,  avatars.count > 0 {
            numOfSections = 1
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.collectionView.bounds.size.width, height: self.collectionView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Avatar in this Time.".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            self.collectionView.backgroundView = noDataLabel
        }
        return numOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let avatars = data?.avatars,  avatars.count > 0 {
            return avatars.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        if let data = data, let avatars = data.avatars,  avatars.count > 0 {
            let imageUrl = "\(data.base_url ?? "")/\(avatars[indexPath.row].name ?? "")"
            WAShareHelper.loadImage(urlstring: imageUrl , imageView: cell.imgOfAvatar, placeHolder: "")
            let cgFloat : CGFloat = cell.imgOfAvatar.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfAvatar, radius: CGFloat(someFloat))
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.collectionView.frame.size.width/4 - 5
        return CGSize(width: sizeOfCell, height: 70.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = data, let avatars = data.avatars,  avatars.count > 0 {
            let imageUrl = "\(data.base_url ?? "")/\(avatars[indexPath.row].name ?? "")"
            self.avatar = avatars[indexPath.row]
            WAShareHelper.loadImage(urlstring: imageUrl , imageView: imgOfUser, placeHolder: "")
            let cgFloat : CGFloat = imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(imgOfUser, radius: CGFloat(someFloat))
            self.avatarView.isHidden = true
        }
    }
}


extension UBGroupCreateVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view!.isDescendant(of: self.collectionView) {
            return false
        }
        return true
    }
}
