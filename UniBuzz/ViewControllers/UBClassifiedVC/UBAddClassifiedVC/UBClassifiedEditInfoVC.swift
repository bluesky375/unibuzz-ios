//
//  UBClassifiedEditInfoVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import GrowingTextView
  

class UBClassifiedEditInfoVC: UIViewController {
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtPhoneNum: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDescription: UITextView!
    
    let photoPicker = PhotoPicker()
    var morePhotos: [UIImage]? = []
    var cover_image: UIImage?
    var isImageSelect : Bool?
    var subSubCat : CategoriesList?
    var selectSubCategoriesList : SubCategoriesList?
    
    var selectSubCategoriesListFromCat : [SubCategoriesList]?
    @IBOutlet weak var imgOfAnonyMous: UIImageView!
    var isAnonymous  = 0
    var param =    [ : ] as [String : Any]
    var selectCategorieId : String?
    var selectsubSubCat : String?
    var lastSubCategorie : String?
    var presenter: RegistrationPresenter?
    var myClassified : ClassifiedPost?
//    var dummyImage: UIImageView!
    @IBOutlet  var dummyImage: UIImageView!
    
    var isPhotoEdit : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isPhotoEdit = false
        
        isImageSelect = false
        self.imgOfAnonyMous.image = UIImage(named: "check_n_selected")
        isAnonymous = 0
        txtPrice.text = myClassified?.price
        txtTitle.text = myClassified?.postTitle
        txtPhoneNum.text = myClassified?.phone
        txtLocation.text = myClassified?.location
        txtDescription.text = myClassified?.datumDescription

        isImageSelect = true

        if myClassified?.userAs == 0 {
            isAnonymous = 0
            self.imgOfAnonyMous.image = UIImage(named: "check_n_selected")
        } else {
            isAnonymous = 1
            self.imgOfAnonyMous.image = UIImage(named: "check_selected")
        }
        
        presenter = RegistrationPresenter(delegate: self)
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBClassifiedEditInfoVC.imageTappedForDp(img:)))
        mainImage.isUserInteractionEnabled = true
        mainImage.addGestureRecognizer(tapGestureRecognizerforDp)
        WAShareHelper.setBorderAndCornerRadius(layer: collectionView.layer, width: 1.0, radius: 5.0, color: UIColor.groupTableViewBackground)
        WAShareHelper.setBorderAndCornerRadius(layer: txtDescription.layer, width: 1.0, radius: 5.0, color: UIColor.groupTableViewBackground)

        let imageName = myClassified!.postImage
        let imgPAth = myClassified!.image_path
        let imgFullUrl = "\(imgPAth!)/\(imageName!)"
        WAShareHelper.loadImage(urlstring: imgFullUrl , imageView: mainImage , placeHolder: "classifieds-placeholder")
      
//        if (myClassified?.postImages!.count)! == 1 {
//            
//        } else {
//            if (myClassified?.postImages!.count)! > 1 {
//                for (_ , obj) in ((myClassified?.postImages?.enumerated())!) {
//                    DispatchQueue.global().async {[unowned self] in
//                        let imageName = obj.name
//                        let imgPAth = self.myClassified!.image_path
//                        let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//                        DispatchQueue.main.async { [unowned self] in
//                            WAShareHelper.loadImageWithCompletion(urlstring: imgFullUrl, showLoader: true, imageView: self.dummyImage) {[weak self] (image) in
//                                self!.morePhotos?.append(self!.dummyImage.image!)
//                                self!.collectionView.reloadData()
//                            }
//                        }
//                    }
////                    WAShareHelper.loadImage(urlstring: imgFullUrl , imageView: mainImage , placeHolder: "classifieds-placeholder")
//
//
//                }
//            }
//        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()

        
    }
    
    @objc func imageTappedForDp(img: AnyObject)
    {
        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) {[weak self] (orignal, edited) in

            let vc = PhotoTweaksViewController(image: orignal)
            vc?.delegate = self
            vc?.autoSaveToLibray = false
            self!.isImageSelect = true
            
            self?.navigationController?.pushViewController(vc!, animated: true)
        }
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
    @IBAction private func btnNextStep_Pressed(_ sender : UIButton) {
        
        presenter?.adddProductInfo(productTitle: txtTitle.text! , price: txtPrice.text! , postImage: self.isImageSelect!)
    }
}

extension UBClassifiedEditInfoVC: UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
        if isPhotoEdit == true {
             return (morePhotos?.count)! + 1
        } else {
             return (myClassified?.postImages!.count)! + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePhotoCell", for: indexPath) as! MorePhotoCell
        if isPhotoEdit == true {
                if indexPath.row != self.morePhotos?.count {
                    cell.imagePhoto.image = morePhotos![indexPath.row]
                } else {
                    cell.imagePhoto.image = UIImage(named: "AddAva")
                }
        } else {
                    if indexPath.row != myClassified?.postImages?.count {
                        let imageName = myClassified?.postImages![indexPath.row].name
                        let imgPAth = self.myClassified!.image_path
                        let imgFullUrl = "\(imgPAth!)/\(imageName!)"
                        WAShareHelper.loadImageWithCompletion(urlstring: imgFullUrl, showLoader: true, imageView: cell.imagePhoto) {[weak self] (image) in
                            self!.morePhotos?.append(image!)
                        }
            //            cell.imagePhoto.setImage(with: imgFullUrl, placeholder: UIImage(named: "Place"))
                        } else {
                            cell.imagePhoto.image = UIImage(named: "AddAva")
                        }

        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.morePhotos!.count < 5 {
            if indexPath.row == self.morePhotos?.count {
                photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self, successBlock: {[weak self] (orignal, edited) in
                    self!.morePhotos?.append(orignal!)
                    self!.isPhotoEdit = true
                    self!.collectionView.reloadData()
                })
            }
        }
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let wid = collectionView.frame.size.width/3 - 3
        return CGSize(width: wid, height: 150)
        
        
    }
    
}

extension UBClassifiedEditInfoVC : PhotoTweaksViewControllerDelegate {
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        _ = controller.navigationController?.popViewController(animated: true)
        self.mainImage.image = croppedImage
        self.cover_image = croppedImage
        isImageSelect = true
        
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}

extension UBClassifiedEditInfoVC : RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditListClassfiedVC") as? UBEditListClassfiedVC
        vc?.subSubCat = subSubCat
        vc?.selectSubCategoriesList = selectSubCategoriesList
        vc?.cover_image = mainImage.image
        vc?.morePhotos = morePhotos
        vc?.titleOfItem = txtTitle.text
        vc?.descriptionOfItem = txtDescription.text
        vc?.phoneNum = txtPhoneNum.text
        vc?.priceOfItem = txtPrice.text
        vc?.loc = txtLocation.text
        vc?.selectCategorieId = selectCategorieId
        vc?.selectsubSubCat = selectsubSubCat
        vc?.lastSubCategorie = lastSubCategorie
        vc?.myClassified = myClassified
        vc?.isPostAnonymous = "\(isAnonymous)"
        
        //        var selectCategorieId : String?
        //        var selectsubSubCat : String?
        //        var lastSubCategorie : String?
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
    
}
