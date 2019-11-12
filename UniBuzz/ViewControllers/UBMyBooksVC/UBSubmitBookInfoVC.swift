//
//  UBSubmitBookInfoVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0
import TagListView
  
class UBSubmitBookInfoVC: UIViewController {

    @IBOutlet weak var titleOfCourse: UITextField!
    @IBOutlet weak var txtAuthorName: UITextField!
    @IBOutlet weak var btnBookStatus: UIButton!
    var bookInfo : Book?
    var bookISBN : BookISBN?

//    @IBOutlet weak var btnCoverType: UIButton!
    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var txtEdition: UITextField!
    @IBOutlet weak var txtPrice: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtCourseName: UITextField!
    @IBOutlet weak var txtCourseCode: UITextField!
    @IBOutlet weak var viewOfCourseName: UIView!
    @IBOutlet weak var viewOfCourseCode : UIView!
    @IBOutlet weak var heightOfCourseName: NSLayoutConstraint!
    @IBOutlet weak var btnIsCourseSelect: UIButton!
    @IBOutlet weak var btnCourseCode : UIButton!
    let photoPicker = PhotoPicker()
    var cover_image: UIImage?
    @IBOutlet weak var viewOFPRice: UIView!

    var coureCode = [Int]()
    var selectCoverType  = ""
    var coverStatus  = ""
    var bookLocation  = ""
    var courseCode  = ""
    var send_email  = ""
    @IBOutlet weak var mainImage: UIImageView!
    
    var isAcademicOrNonAcademic : Int?
    var isSellOrDonate : Int?
    var isbn : String?
    
    @IBOutlet weak var tagListView: TagListView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getAllBookInfo()
        
        if isSellOrDonate == 0 {
            txtPrice.isHidden = true
            viewOFPRice.isHidden = true
        } else {
            txtPrice.isHidden = false
            viewOFPRice.isHidden = false

        }
        
        titleOfCourse.text = bookISBN?.title
        txtAuthorName.text = bookISBN?.author
        txtDescription.text = bookISBN?.descriptionOFBook
        heightOfCourseName.constant = 0.0
        tagListView.delegate = self
        tagListView.isHidden = true
        txtCourseName.isHidden = true
        txtCourseCode.isHidden = true
        viewOfCourseName.isHidden = true
        viewOfCourseCode.isHidden = true
        btnIsCourseSelect.isSelected = false
        
    }
    
    func getAllBookInfo() {
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: BOOKADD , serviceType: "Book Add".localized(), modelType: Book.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()
            guard let this = self else {
                return
            }
            this.bookInfo = (response as! Book)
            if this.bookInfo?.status == true {
            }
            else {
                this.showAlert(title: KMessageTitle, message: (this.bookInfo?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
   
    @IBAction func btnBookStatus_Pressed(_ sender: UIButton) {
        var allBookStatus = [String]()
        for (_ , info) in (bookInfo?.bookInfo?.bookStatus?.enumerated())! {
            allBookStatus.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: " ", rows: allBookStatus , initialSelection: 0 , doneBlock: { [weak self ](picker, index, value) in
            let category = self!.bookInfo?.bookInfo?.bookStatus![index]
            let id  = category?.id

            self!.coverStatus = "\(id!)"
            self!.btnBookStatus.setTitle(category?.name , for: .normal)
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)

    }
    
//    @IBAction func btnCoverType_Pressed(_ sender: UIButton) {
//        var bookCover = [String]()
//        for (_ , info) in (bookInfo?.bookInfo?.bookCover?.enumerated())! {
//            bookCover.append(info.name!)
//        }
//        ActionSheetStringPicker.show(withTitle: " ", rows: bookCover , initialSelection: 0 , doneBlock: { [weak self ](picker, index, value) in
//            let category = self!.bookInfo?.bookInfo?.bookCover![index]
//            let id  = category?.id
//            self!.selectCoverType = "\(id!)"
//            self!.btnCoverType.setTitle(category?.name , for: .normal)
//            return
//            }, cancel: { (actionStrin ) in
//        }, origin: sender)
//
//    }
    
    @IBAction func btnCitySelect_Pressed(_ sender: UIButton) {
        var citiesList = [String]()
        for (_ , info) in (bookInfo?.bookInfo?.citiesList?.enumerated())! {
            citiesList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: " ", rows: citiesList , initialSelection: 0 , doneBlock: { [weak self ](picker, index, value) in
            let category = self!.bookInfo?.bookInfo?.citiesList![index]
            let id  = category?.id

            self!.bookLocation = "\(id!)"

            self!.btnCity.setTitle(category?.name , for: .normal)
            return
            }, cancel: { (actionStrin ) in
        }, origin: sender)

        
    }
    
    @IBAction func btnCourseCode_Pressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCourseSelectVC") as? UBCourseSelectVC
        tagListView.removeAllTags()
        vc?.courseList = bookInfo?.bookInfo?.course
        vc?.delegate = self
        coureCode = []

//        vc?.providesPresentationContextTransitionStyle = true
        present(vc!, animated: true) {
            
        }
//        var courseCode = [String]()
//        for (_ , info) in (bookInfo?.bookInfo?.course?.enumerated())! {
//            courseCode.append(info.name!)
//        }
//        ActionSheetStringPicker.show(withTitle: " ", rows: courseCode , initialSelection: 0 , doneBlock: { [weak self ](picker, index, value) in
//            let category = self!.bookInfo?.bookInfo?.course![index]
//            let id  = category?.id
//
//            self!.courseCode = "\(id!)"
//            self!.btnCourseCode.setTitle(category?.name , for: .normal)
//            return
//            }, cancel: { (actionStrin ) in
//        }, origin: sender)

    }
    
    @IBAction func btnSendEmail_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true {
            send_email = "1"
        } else {
            send_email = "0"
        }
    }
    @IBAction func btnISCoursefineOrNot_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected == true {
            heightOfCourseName.constant = 32.0
            txtCourseName.isHidden = false
            txtCourseCode.isHidden = false
            viewOfCourseName.isHidden = false
            viewOfCourseCode.isHidden = false
            self.tagListView.removeAllTags()
            self.btnCourseCode.setTitle("Select Course".localized(), for: .normal)
            self.btnCourseCode.isUserInteractionEnabled = false


        } else {
            heightOfCourseName.constant = 0.0
            txtCourseName.isHidden = true
            txtCourseCode.isHidden = true
            viewOfCourseName.isHidden = true
            viewOfCourseCode.isHidden = true
            self.btnCourseCode.isUserInteractionEnabled = true

        }
    }
    
  private   func AddBookInfo() {
        var  param =    [ : ] as [String : Any]
    var imgUrl : String?
        if self.bookISBN != nil {
            imgUrl = self.bookISBN!.thumbnail ?? " "
        } else {
            imgUrl =  " "

        }
    
        self.courseCode  = coureCode.map({"\($0)"}).joined(separator: ",")
        if isSellOrDonate == 1 {
            param = [ "isbn"                             :   isbn!  ,
                      "is_academic"                      :  "\(isAcademicOrNonAcademic!)" ,
                      "type"                             :  "\(isSellOrDonate!)" ,
                      "image_url"                        :   imgUrl!  ,
                      "title"                            :  titleOfCourse.text! ,
                      "author"                           :  txtAuthorName.text ?? " " ,
//                      "cover_type"                       :  selectCoverType ,
                      "book_status"                      :  coverStatus ,
                      "city_id"                          :  bookLocation  ,
                      "price"                            :  txtPrice.text! ,
                      "edition"                          :  txtEdition.text! ,
                      "description"                      :  txtDescription.text! ,
                      "location"                         :  txtLocation.text! ,
                      "course_ids"                       :  courseCode ,
                      "new_course"                       :  txtLocation.text! ,
                      "send_email"                       :  send_email
                
            ]
        } else {
            param = [ "isbn"                             :   isbn!  ,
                      "is_academic"                      :  "\(isAcademicOrNonAcademic!)" ,
                "type"                             :  "\(isSellOrDonate!)" ,
                "image_url"                        :   imgUrl! ,
                "title"                            :  titleOfCourse.text! ,
                "author"                           :  txtAuthorName.text ?? " " ,
//                "cover_type"                       :  selectCoverType ,
                "book_status"                      :  coverStatus ,
                "city_id"                          :  bookLocation  ,
                "edition"                          :  txtEdition.text! ,
                "description"                      :  txtDescription.text! ,
                "location"                         :  txtLocation.text! ,
                "course_ids"                       :  courseCode ,
                "new_course"                       :  txtLocation.text! ,
                "send_email"                       :  send_email
                
            ]
            
        }
        
        let params =       [ "isbn"                             :   isbn!  ,
                             "is_academic"                      :  "\(isAcademicOrNonAcademic!)" ,
                             "type"                             :  "\(isSellOrDonate!)" ,
                             "image_url"                        :   imgUrl!  ,
                             "title"                            :  titleOfCourse.text! ,
                             "author"                           :  txtAuthorName.text ?? " " ,
//                             "cover_type"                       :  selectCoverType ,
                             "book_status"                      :  coverStatus ,
                             "city_id"                          :  bookLocation  ,
                             "price"                            :  txtPrice.text! ,
                             "edition"                          :  txtEdition.text! ,
                             "description"                      :  txtDescription.text! ,
                             "location"                         :  txtLocation.text! ,
                             "course_ids"                       :  courseCode ,
                             "new_course"                       :  txtLocation.text! ,
                             "send_email"                       :  send_email
            
            ] as [String : Any]
        SVProgressHUD.show()
        
        var imge : UIImage?
        if cover_image != nil {
            imge = cover_image
        }
        WebServiceManager.mutliChat(params: params as Dictionary<String, AnyObject> , serviceName: ADDBOOK, imageParam:"main_image", imgFileName: "main_image.png", serviceType: "", profileImage: imge  , cover_image_param: "", cover_image: nil , modelType: MessageObject.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()
            let post = response as? MessageObject
            if post!.status == true {
                self?.showAlertViewWithTitle(title: KMessageTitle, message: post!.message!, dismissCompletion: {
                    self?.navigationController?.popToRootViewController(animated: true)
                })
            }
            else
            {
                self!.showAlert(title: KMessageTitle, message: post!.message!, controller: self)
            }
        }) { [weak self] (error) in
        }
    }

//    }
    
    @IBAction func btnAddMAinImage_Pressed(_ sender: UIButton) {
        photoPicker.pick(allowsEditing: false, pickerSourceType: .CameraAndPhotoLibrary, controller: self) {[weak self] (orignal, edited) in
            
            let cgFloat: CGFloat = self!.mainImage.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(self!.mainImage, radius: CGFloat(someFloat))
            let vc = PhotoTweaksViewController(image: orignal)
            vc?.delegate = self
            vc?.autoSaveToLibray = false
            self?.navigationController?.pushViewController(vc!, animated: true)
        }

    }
    @IBAction func btnSubmitBook(_ sender: UIButton) {

        if titleOfCourse.text!.isEmpty {
            self.showAlert(title: KMessageTitle, message: "Enter the Title Name".localized(), controller: self)
        }
        else if titleOfCourse.text!.count < 5 {
            self.showAlert(title: KMessageTitle, message: "Course Title must not be less than 5 characters".localized(), controller: self)
            
        } else if titleOfCourse.text!.count > 150 {
            self.showAlert(title: KMessageTitle, message: "Course Title Not greater than 150".localized(), controller: self)
            
        } else {
            if isSellOrDonate == 1 {
                if txtPrice.text!.isEmpty {
                    self.showAlert(title: KMessageTitle, message: "Enter the Price".localized(), controller: self)
                }
                else if txtPrice.text!.count >= 4 {
                    self.showAlert(title: KMessageTitle, message: "Price must not be greater than 1000".localized(), controller: self)
                    
                }
                else {
                    self.AddBookInfo()
                }
            } else {
                  self.AddBookInfo()
            }
            
    }
  }
}

extension UBSubmitBookInfoVC : PhotoTweaksViewControllerDelegate {
    
    func photoTweaksController(_ controller: PhotoTweaksViewController!, didFinishWithCroppedImage croppedImage: UIImage!) {
        _ = controller.navigationController?.popViewController(animated: true)
        self.mainImage.image = croppedImage
        self.cover_image = croppedImage
        let cgFloat: CGFloat = self.mainImage.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.mainImage, radius: CGFloat(someFloat))
    }
    
    func photoTweaksControllerDidCancel(_ controller: PhotoTweaksViewController!) {
        _ = controller.navigationController?.popViewController(animated: true)
    }
    
}

extension UBSubmitBookInfoVC : TagListViewDelegate {

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
    }
}

extension UBSubmitBookInfoVC : CourseSelectDelegate {
    func selectedCourse(course: [CoursesList]) {
        self.tagListView.isHidden = false
        self.btnCourseCode.setTitle("", for: .normal)
        for (_ , obj) in (course.enumerated()) {
            tagListView.addTag(obj.name!)
            coureCode.append(obj.id!)
            
        }
    }
    
    
}

