//
//  UBSignUpVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
  
class UBSignUpVC: UIViewController {
    
    var listCountry : UserResponse?
    var listOfUni : UserResponse?
    var listOfCampus : UserResponse?
    var listOfCollege : UserResponse?
    @IBOutlet weak var btnSelectCountry : UIButton!
    @IBOutlet weak var btnUniversity : UIButton!
    @IBOutlet weak var btnCollege : UIButton!
    @IBOutlet weak var btnCampus : UIButton!
    @IBOutlet weak var btnStudentLevel : UIButton!
    var countryId : Int?
    var universityId : Int?
    var campusID : Int?
    var collegeID : Int?
    var studentLeve : Int?
    var gender : String?
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPass: UITextField!
    @IBOutlet weak var btnMale: UIButton!
    @IBOutlet weak var btnFemale: UIButton!
    
    var presenter: RegistrationPresenter?
    
    @IBOutlet weak var heightOfCampus: NSLayoutConstraint!
    @IBOutlet weak var viewOFCampus: UIView!
    
    var isSelectCountries = false
    var isSelectUniversity = false
    var isSelectCampus = false
    var isSelectCollege = false
    var isSelectStudentLevel  = true
    var isSelectProfilePic = false

    @IBOutlet weak var collectionView: UICollectionView!
    var profilePicture  : String?

    @IBOutlet weak var imgOfPRofile: UIImageView!
    @IBOutlet weak var viewOfAvatars: UIView!

    
    @IBOutlet weak var imgOfDropDown: UIImageView!
    @IBOutlet weak var btnRegister : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        studentLeve = 0
        self.viewOfAvatars.isHidden = true
        imgOfDropDown.isHidden = true
        self.heightOfCampus.constant = 0.0
        self.viewOFCampus.isHidden = true
        self.btnCampus.isHidden = true
        self.hideKeyboardWhenTappedAround()
        self.btnUniversity.isUserInteractionEnabled = false
        self.btnCollege.isUserInteractionEnabled = false
        self.btnCampus.isUserInteractionEnabled = false
        presenter = RegistrationPresenter(delegate: self)
//        btnMale.isSelected = true
//        btnFemale.isSelected = false
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBSignUpVC.imageTappedForDp(img:)))
        imgOfPRofile.isUserInteractionEnabled = true
        imgOfPRofile.addGestureRecognizer(tapGestureRecognizerforDp)
//        gender = "male"
        
        
        let tapGestureRecognizerfor = UITapGestureRecognizer(target:self, action:#selector(UBSignUpVC.imageTappedFor(img:)))
        viewOfAvatars.isUserInteractionEnabled = true
        tapGestureRecognizerfor.delegate = self
        viewOfAvatars.addGestureRecognizer(tapGestureRecognizerfor)
        setUPTextField()
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideAvatar))
//
//        view.addGestureRecognizer(tap)
//
        
        getAllCountriesList()
    }
    
    func setUPTextField() {
        txtEmail.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        txtPassword.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        txtFirstName.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        txtLastName.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        txtConfirmPass.textAlignment = AppDelegate.isArabic() ? NSTextAlignment.right : NSTextAlignment.left
        btnSelectCountry.contentHorizontalAlignment = AppDelegate.isArabic() ? UIControl.ContentHorizontalAlignment.right : UIControl.ContentHorizontalAlignment.left
        btnUniversity.contentHorizontalAlignment = AppDelegate.isArabic() ? UIControl.ContentHorizontalAlignment.right : UIControl.ContentHorizontalAlignment.left
        btnCollege.contentHorizontalAlignment = AppDelegate.isArabic() ? UIControl.ContentHorizontalAlignment.right : UIControl.ContentHorizontalAlignment.left
        btnCampus.contentHorizontalAlignment = AppDelegate.isArabic() ? UIControl.ContentHorizontalAlignment.right : UIControl.ContentHorizontalAlignment.left
        btnStudentLevel.contentHorizontalAlignment = AppDelegate.isArabic() ? UIControl.ContentHorizontalAlignment.right : UIControl.ContentHorizontalAlignment.left
    }
    
    @objc func imageTappedFor(img: AnyObject)
    {
        viewOfAvatars.isHidden = true
    }
//    @objc func hideAvatar() {
//        //Causes the view (or one of its embedded text fields) to resign the first responder status.
//        self.viewOfAvatars.isHidden = true
//    }

   
    @objc func imageTappedForDp(img: AnyObject)
    {
        self.view.endEditing(true)
        self.viewOfAvatars.isHidden = false
    }

    
    func getAllCountriesList() {
        WebServiceManager.getWithOutHeader(params: nil, serviceName: COUNTRYLIST, serviceType: "Country List".localized(), modelType: UserResponse.self, success: {[weak self] (response) in
            guard let self = self else {return}
            self.listCountry = (response as? UserResponse)
            if self.listCountry?.status == true {
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
            } else  {
                self.showAlert(title: KMessageTitle, message: self.listCountry!.message! , controller: self)
            }
        }) { (error) in
        }
    }
    
    func getUniversity(countryId : Int) {
        let serviceUrl = "\(UNIVERSITYLISt)\(countryId)"
        WebServiceManager.getWithOutHeader(params: nil, serviceName: serviceUrl, serviceType: "University List".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let self = self else {return}
            self.listOfUni = (response as? UserResponse)
            if self.listOfUni?.status == true {
                self.btnUniversity.isUserInteractionEnabled = true
                self.btnCampus.isUserInteractionEnabled = false
                self.btnCollege.isUserInteractionEnabled = false
            } else  {
                self.showAlert(title: KMessageTitle, message: self.listOfUni!.message! , controller: self)
            }
        }) { (error) in
        }
    }

    func getCampus(uniId : Int) {
        let serviceUrl = "\(CAMPUSLIST)\(uniId)"
        WebServiceManager.getWithOutHeader(params: nil, serviceName: serviceUrl, serviceType: "University List".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let self = self else {return}
            self.listOfCampus = (response as? UserResponse)
            if self.listOfCampus?.status == true {
                self.btnCollege.isUserInteractionEnabled = false
                self.btnCampus.isUserInteractionEnabled = true

            } else  {
                self.showAlert(title: KMessageTitle, message: self.listOfCampus!.message! , controller: self)
            }
        }) { (error) in
        }
    }

    func getColllege(collegeId : Int) {
        let serviceUrl = "\(COLLEGELIST)\(collegeId)"
        WebServiceManager.getWithOutHeader(params: nil, serviceName: serviceUrl, serviceType: "University List".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
             guard let self = self else {return}
            self.listOfCollege = (response as? UserResponse)
            if self.listOfCollege?.status == true {
                self.btnCollege.isUserInteractionEnabled = true

            } else  {
                self.showAlert(title: KMessageTitle, message: self.listOfCollege!.message! , controller: self)
            }
        }) { (error) in
        }
    }

    @IBAction private func btnGetCountryList(_ sender : UIButton) {
        var allCountry = [String]()
        for (_ , info) in (listCountry?.getCountriesAndAvatar?.countriesList?.enumerated())! {
            allCountry.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Country".localized(), rows: allCountry , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            guard let self = self else {return}
            let category = self.listCountry?.getCountriesAndAvatar?.countriesList![index]
            self.isSelectCountries = true
            self.countryId = category?.id
            self.btnUniversity.isUserInteractionEnabled = false
            self.btnCollege.isUserInteractionEnabled = false
            self.btnCampus.isUserInteractionEnabled = false
            self.getUniversity(countryId: self.countryId!)
            self.btnSelectCountry.setTitle(category?.name , for: .normal)
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)
    }
    
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            super.touchesBegan(touches, with: event)
            self.view.endEditing(true)
            self.viewOfAvatars.isHidden = true
        }

     
    
    @IBAction private func btnGetUniList(_ sender : UIButton) {
        var allUniversityList  = [String]()
        for (_ , info) in (listOfUni?.universityList?.enumerated())! {
            allUniversityList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select University ".localized(), rows: allUniversityList , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            guard let self = self else {return}
            self.isSelectUniversity = true
            let category = self.listOfUni?.universityList![index]
            self.universityId = category?.id
            
            if category!.campus_count! > 0 {
                self.btnCampus.isHidden = false
                self.btnCollege.isUserInteractionEnabled = false
                self.btnCampus.isUserInteractionEnabled = false
                self.viewOFCampus.isHidden =  false
                self.imgOfDropDown.isHidden = false
                self.heightOfCampus.constant = 36.0
                self.getCampus(uniId: self.universityId!)
                self.btnCollege.setTitle("Select College".localized(), for: .normal)
            } else {
                self.btnCampus.isHidden = true
                self.btnCollege.isUserInteractionEnabled = false
                self.btnCampus.isUserInteractionEnabled = false
                self.viewOFCampus.isHidden =  true
                self.heightOfCampus.constant = 0.0
                self.imgOfDropDown.isHidden = true
                self.btnCollege.setTitle("Select College".localized(), for: .normal)
                self.campusID = 0
                self.getColllege(collegeId: self.universityId! )

            }
            
            self.btnUniversity.setTitle(category?.name , for: .normal)
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)
    }
    
    @IBAction private func btnGetCampus_Pressed(_ sender : UIButton) {
        var allUniversityList  = [String]()
        for (_ , info) in (listOfCampus?.campusList?.enumerated())! {
            allUniversityList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Campus".localized(), rows: allUniversityList , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            guard let self = self else {return}
            let category = self.listOfCampus?.campusList![index]
            self.isSelectCampus = true
            self.campusID = category?.id
            self.btnCollege.isUserInteractionEnabled = false
            self.getColllege(collegeId: self.campusID!)
            self.btnCampus.setTitle(category?.name , for: .normal)
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)
    }

    @IBAction private func btnGetCollege(_ sender : UIButton) {
        var allUniversityList  = [String]()
        for (_ , info) in (listOfCollege?.collegeList?.enumerated())! {
            allUniversityList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select College".localized(), rows: allUniversityList , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            guard let self = self else {return}
            let category = self.listOfCollege?.collegeList![index]
            self.isSelectCollege = true
            self.collegeID = category?.id
            self.btnCollege.setTitle(category?.name , for: .normal)
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)
    }

    @IBAction private func btnStudentLevel_Pressed(_ sender : UIButton) {

        ActionSheetStringPicker.show(withTitle: "Select Student Level".localized(), rows: ["Freshman".localized() , "Junior".localized() , "Sophomore".localized() , "Senior".localized() , "Graduated".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            guard let self = self else {return}
            self.btnStudentLevel.setTitle(value as? String , for: .normal)
            self.isSelectStudentLevel = true
            self.studentLeve = index
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)
    }
    
    @IBAction func btnMale_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnMale.isSelected = true
        btnFemale.isSelected = false
        gender = "male"
    }
    
    @IBAction func btnFemale_Pressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        btnMale.isSelected = false
        btnFemale.isSelected = true
        gender = "female"
    }
    
    @IBAction func btnRegister_Pressed(_ sender: UIButton) {
        
        if campusID == 0 {
            presenter?.registeration(firstName: txtFirstName.text! , lastName: txtLastName.text! , txtEmail: txtEmail.text! , selectCountries: isSelectCountries, selectUni: isSelectUniversity, seelctCampus: true, selectCollege: isSelectCollege, password: txtPassword.text!, confirmPass: txtConfirmPass.text! , studentLeve: isSelectStudentLevel , profilePic: isSelectProfilePic)
        } else {
            presenter?.registeration(firstName: txtFirstName.text! , lastName: txtLastName.text! , txtEmail: txtEmail.text! , selectCountries: isSelectCountries, selectUni: isSelectUniversity, seelctCampus: isSelectCampus, selectCollege: isSelectCollege , password: txtPassword.text!, confirmPass: txtConfirmPass.text! , studentLeve: isSelectStudentLevel , profilePic: isSelectProfilePic )
        }
        
    }
    
    @IBAction func btnLogin_Pressed(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.pushToViewControllerWithStoryboardID(storyboardId: VCIdentifier.KUBLOGIN)

    }
    
    
}

extension UBSignUpVC: RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        
        btnRegister.isUserInteractionEnabled = false

        var param =    [ : ] as [String : Any]
        
        if campusID == 0 {
          param =  [ "first_name"                        :  txtFirstName.text!  ,
                "last_name"                         :  txtLastName.text! ,
                "country_id"                        :  "\(countryId!)" ,
                "university_id"                     : "\(universityId!)" ,
                "college_id"                        :  "\(collegeID!)" ,
                "email"                             :  txtEmail.text! ,
                "password"                          :  txtPassword.text! ,
                "password_confirmation"             :  txtConfirmPass.text! ,
                "student_level"                     :  "\(self.studentLeve!)" ,
                "gender"                            :  gender ?? " " ,
                "profile_picture"                   :  profilePicture! ,
                "client_id"                         :  "2" ,
                "client_secret"                     :  "pmGqX1ki5HnvamG3g9nPC91QVBCeP6v2uzcjdjhS" ,
                "scope"                             :  "" ,
                "grant_type"                        :  "password" ,
                "campus_id"                         :  " "
            ]
        } else {
          param =   [ "first_name"                  :  txtFirstName.text!  ,
              "last_name"                           :  txtLastName.text! ,
              "country_id"                          :  "\(countryId!)" ,
                "university_id"                     : "\(universityId!)" ,
                "college_id"                        :  "\(collegeID!)" ,
                "email"                             :  txtEmail.text! ,
                "password"                          :  txtPassword.text! ,
                "password_confirmation"             :  txtConfirmPass.text! ,
                "student_level"                     :  "\(self.studentLeve!)" ,
                "gender"                            :  gender ?? " " ,
                "profile_picture"                   :  profilePicture! ,
                "client_id"                         :  "2" ,
                "client_secret"                     :  "pmGqX1ki5HnvamG3g9nPC91QVBCeP6v2uzcjdjhS" ,
                "scope"                             :  "" ,
                "grant_type"                        :  "password" ,
                "campus_id"                         :  "\(self.campusID!)"
            ]

        }
        
//        let params =      as [String : Any]
        
        WebServiceManager.postWithOutHeader(params:param as Dictionary<String, AnyObject> , serviceName: SIGNUP, isLoaderShow: false , serviceType: "Login".localized(), isMultipart: false, modelType: UserResponse.self, success: { [weak self] (responseData) in
            guard let self = self else {return}
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.btnRegister.isUserInteractionEnabled = true
                    self.showAlertViewWithTitle(title: "Thank You !".localized() , message: "Thank you for registering! You will receive an email confirmation shortly, please check your spam/junk folder.".localized() , dismissCompletion: { [weak self] in
                         guard let self = self else {return}
                         self.listCountry = nil
                         self.listOfUni = nil
                         self.listOfCampus = nil
                         self.listOfCollege = nil
                         self.presenter = nil
                         self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.btnRegister.isUserInteractionEnabled = true
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
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
extension UBSignUpVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if  listCountry?.getCountriesAndAvatar?.avatarList?.isEmpty == false {
            numOfSections = 1
            self.collectionView.backgroundView = nil
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
            //            collectionViewCell.separatorStyle = .none
        }
        return numOfSections
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listCountry?.getCountriesAndAvatar?.avatarList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCell", for: indexPath) as! AvatarCell
        let imageUrl = listCountry?.getCountriesAndAvatar?.avatarList![indexPath.row].image_path
        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: cell.imgOfAvatar, placeHolder: "")
        let cgFloat : CGFloat = cell.imgOfAvatar.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(cell.imgOfAvatar, radius: CGFloat(someFloat))
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.collectionView.frame.size.width/4 - 5
        return CGSize(width: sizeOfCell, height: 70.0)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let avatarId = listCountry?.getCountriesAndAvatar?.avatarList![indexPath.row].id
        profilePicture = "\(avatarId!)"
        isSelectProfilePic = true
        let avatarURL = listCountry?.getCountriesAndAvatar?.avatarList![indexPath.row].image_path!
        WAShareHelper.loadImage(urlstring: avatarURL! , imageView: (self.imgOfPRofile!), placeHolder: "profile2")
        let cgFloat: CGFloat = self.imgOfPRofile.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfPRofile, radius: CGFloat(someFloat))
        self.viewOfAvatars.isHidden = true
        }
    }
    


extension UBSignUpVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view!.isDescendant(of: self.collectionView) {
            return false
        }
        return true
    }
}
