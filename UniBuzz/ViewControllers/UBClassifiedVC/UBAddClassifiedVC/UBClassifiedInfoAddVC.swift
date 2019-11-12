//
//  UBClassifiedInfoAddVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 19/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import GrowingTextView
  

class UBClassifiedInfoAddVC: UIViewController {

    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
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
    var selectCategories : Category?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isImageSelect = false
        txtDescription.placeholder = "Description".localized()
        self.imgOfAnonyMous.image = UIImage(named: "check_n_selected")
        isAnonymous = 0
        WAShareHelper.setBorderAndCornerRadius(layer: txtDescription.layer, width: 1.0, radius: 5.0, color: UIColor.groupTableViewBackground)
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBClassifiedInfoAddVC.imageTappedForDp(img:)))
        mainImage.isUserInteractionEnabled = true
        mainImage.addGestureRecognizer(tapGestureRecognizerforDp)
        WAShareHelper.setBorderAndCornerRadius(layer: collectionView.layer, width: 1.0, radius: 5.0, color: UIColor.groupTableViewBackground)
        presenter = RegistrationPresenter(delegate: self)

        // Do any additional setup after loading the view.
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
            
            //            self!.imgOfGroupIcon.image = orignal
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
    
        if selectCategories!.slug == "free-stuff" {
            presenter?.adddProductInfo(productTitle: txtTitle.text! , price: "21" , postImage: self.isImageSelect!)
        } else {
            presenter?.adddProductInfo(productTitle: txtTitle.text! , price: txtPrice.text! , postImage: self.isImageSelect!)
        }
//
    }

}

extension UBClassifiedInfoAddVC: UICollectionViewDataSource , UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (morePhotos?.count)! + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MorePhotoCell", for: indexPath) as! MorePhotoCell
       
        cell.removebutton.isHidden = (indexPath.row == morePhotos?.count)
        cell.delegate = self
        cell.indexSelect = indexPath
        if indexPath.row != self.morePhotos?.count {
            cell.imagePhoto.image = morePhotos![indexPath.row]
        } else {
            cell.imagePhoto.image = UIImage(named: "AddAva")
//
            
        }
        return cell

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.morePhotos!.count < 5 {
            if indexPath.row == self.morePhotos?.count {
                photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self, successBlock: {[weak self] (orignal, edited) in
                    self!.morePhotos?.append(orignal!)
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

extension UBClassifiedInfoAddVC: PhotoTweaksViewControllerDelegate {
    
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

extension UBClassifiedInfoAddVC : RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedCreateVC") as? UBClassifiedCreateVC
        vc?.subSubCat = subSubCat
        vc?.selectSubCategoriesList = selectSubCategoriesList
        vc?.cover_image = cover_image
        vc?.morePhotos = morePhotos
        vc?.titleOfItem = txtTitle.text
        vc?.descriptionOfItem = txtDescription.text
        vc?.phoneNum = txtPhoneNum.text
        vc?.priceOfItem = txtPrice.text
        vc?.loc = txtLocation.text
        vc?.selectCategorieId = selectCategorieId
        vc?.selectsubSubCat = selectsubSubCat
        vc?.lastSubCategorie = lastSubCategorie
        vc?.isPostAnonymous = isAnonymous
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func registrationDidFailed( message: String ) {
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}

extension UBClassifiedInfoAddVC  :  CancelImageDelegate {
    func crossImage(cell : MorePhotoCell , index : IndexPath) {
        let alert = UIAlertController(title: "Confirm".localized(), message: "Are you sure you want to remove it?".localized(), preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes".localized(), style: .default) { (action) in
            self.morePhotos = self.morePhotos!.filter { $0 != cell.imagePhoto.image }
            self.collectionView.reloadData()
//            self.collectionView.deleteItems(at: [IndexPath(row: index.row, section: 0)])
        }
        let noAction = UIAlertAction(title: "No".localized(), style: .cancel, handler: nil)
        alert.addAction(yesAction)
        alert.addAction(noAction)
        self.present(alert, animated: true, completion: nil)

    }

}


