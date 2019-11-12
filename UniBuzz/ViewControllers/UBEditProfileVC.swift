//
//  UBEditProfileVC.swift
//  UniBuzz
//
//  Created by Asim Khan on 8/5/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0
import DatePickerDialog
  
class UBEditProfileVC: UIViewController {

    @IBOutlet weak var firstName: WATextField!
    @IBOutlet weak var lastName: WATextField!
    @IBOutlet weak var passwordName: WATextField!
    @IBOutlet weak var confirmPasswordName: WATextField!
    @IBOutlet weak var dob: WATextField!
    @IBOutlet weak var phoneNumber: WATextField!
    @IBOutlet weak var profileImage: WAImageView!
    var profile : UserResponse?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewOfAvatars: UIView!
    var userSession : AvatarSession?
    var profilePicture  : String?
    var listCountry : UserResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let persistence = Persistence(with: .user)
        let obj: Session? = persistence.load()
        self.profilePicture = String(obj!.profile_picture!)
        firstName.text = obj?.first_name
        lastName.text = obj?.last_name
        self.dob.text = obj?.dob
        phoneNumber.text = obj?.phone
        let imageUrl = obj?.profile_image
        WAShareHelper.loadImage(urlstring: (imageUrl!) , imageView: profileImage, placeHolder: "")
        getAllAvatar()
        
        let tapGestureRecognizerforDp = UITapGestureRecognizer(target:self, action:#selector(UBEditProfileVC.imageTappedForDp(img:)))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGestureRecognizerforDp)

        let tapGestureRecognizerfor = UITapGestureRecognizer(target:self, action:#selector(UBEditProfileVC.imageTappedFor(img:)))
        viewOfAvatars.isUserInteractionEnabled = true
        tapGestureRecognizerfor.delegate = self
        viewOfAvatars.addGestureRecognizer(tapGestureRecognizerfor)

    }
    
    @objc func imageTappedForDp(img: AnyObject)
    {
        viewOfAvatars.isHidden = false
    }
    
    @objc func imageTappedFor(img: AnyObject)
    {
        viewOfAvatars.isHidden = true
    }

    func getAllAvatar() {
        WebServiceManager.getWithOutHeader(params: nil, serviceName: COUNTRYLIST, serviceType: "Country List".localized(), modelType: UserResponse.self, success: { (response) in
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
    
//    func getAllAvatar() {
//
//        let endPoint = AuthEndpoint.profile
//        NetworkLayer.fetch(endPoint, with: AvatarResponse.self) { (result ) in
//            switch result {
//            case .success(let response):
//                SVProgressHUD.dismiss()
//                if response.status == true {
//                    self.userSession = response.data
//                    self.collectionView.delegate = self
//                    self.collectionView.dataSource = self
//                    self.collectionView.reloadData()
//                } else {
//                    self.showAlert(title: KMessageTitle, message: response.message ?? "Server Error" , controller: self)
//                }
//            case .failure(_): break
//
//            }
//        }
//    }
    
    func datePickerTapped() {
        
        if let dobText = self.dob.text, !dobText.isEmpty {
            let currentDate = WAShareHelper.getFormattedDate(from: dobText)
            //            let currentDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            var dateComponents = DateComponents()
            dateComponents.year = 19
            let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate)
            
            let datePicker = DatePickerDialog(textColor: .black,
                                              buttonColor: .black,
                                              font: UIFont.boldSystemFont(ofSize: 17),
                                              showCancelButton: true)
            datePicker.show("DatePickerDialog".localized(),
                            doneButtonTitle: "Done".localized(),
                            cancelButtonTitle: "Cancel".localized(),
                            minimumDate: threeMonthAgo,
                            maximumDate: currentDate,
                            datePickerMode: .date) { (date) in
                                
                                if let dt = date {
                                    let dateOfBirth = date
                                    let today = NSDate()
                                    let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                                    
                                    let age = gregorian.components([.year], from: dateOfBirth!, to: today as Date, options: [])
                                    
                                    if age.year! < 18 {
                                        // user is under 18
                                        self.showAlert(title: "Alert".localized(), message: "Age should be greater than 18!".localized(), controller: self)
                                    }else {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd"
                                        let dateValue = formatter.string(from: dt)
                                        self.dob.text = dateValue
                                    }
                                }
            }
        }else {
            
            let currentDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
            var dateComponents = DateComponents()
            dateComponents.year = 19
            let threeMonthAgo = Calendar.current.date(byAdding: dateComponents, to: currentDate!)
            
            let datePicker = DatePickerDialog(textColor: .black,
                                              buttonColor: .black,
                                              font: UIFont.boldSystemFont(ofSize: 17),
                                              showCancelButton: true)
            datePicker.show("DatePickerDialog".localized(),
                            doneButtonTitle: "Done".localized(),
                            cancelButtonTitle: "Cancel".localized(),
                            minimumDate: threeMonthAgo,
                            maximumDate: currentDate,
                            datePickerMode: .date) { (date) in
                                
                                if let dt = date {
                                    let dateOfBirth = date
                                    let today = NSDate()
                                    let gregorian = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                                    
                                    let age = gregorian.components([.year], from: dateOfBirth!, to: today as Date, options: [])
                                    
                                    if age.year! < 18 {
                                        // user is under 18
                                        self.showAlert(title: "Alert".localized(), message: "Age should be greater than 18!".localized(), controller: self)
                                    }else {
                                        let formatter = DateFormatter()
                                        formatter.dateFormat = "yyyy-MM-dd"
                                        let dateValue = formatter.string(from: dt)
                                        self.dob.text = dateValue
                                    }
                                }
            }
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


    
    @IBAction func btnUpdateProfile_Pressed(_ sender: UIButton) {
        
        if firstName.text!.isEmpty {
             self.showAlert(title: "Oops".localized(), message: "Please Enter the First Name".localized(), controller: self)
        } else if !isValidName(name: firstName.text!) {
             self.showAlert(title: "Oops".localized(), message: "First Name must be alphabet characters.\n".localized(), controller: self)
        } else if lastName.text!.isEmpty {
            self.showAlert(title: "Oops".localized(), message: "Please Enter the Last Name".localized(), controller: self)
        }
        else if !isValidName(name: lastName.text!) {
            self.showAlert(title: "Oops".localized(), message: "Last Name must be alphabet characters.\n".localized(), controller: self)
        }
        else if  phoneNumber.text == "" &&  phoneNumber.text!.count < 10 && phoneNumber.text!.count >  14 {
            self.showAlert(title: "Oops".localized(), message: "Phone Number must be greater than 10 character.".localized(), controller: self)
        }
        else {
            SVProgressHUD.show()
            let persistence = Persistence(with: .user)
            let endPoint = AuthEndpoint.updateProfile(firstName: firstName.text!, lastName: lastName.text!, password: passwordName.text!, confirmPassword: confirmPasswordName.text!, dob: dob.text!, phoneNumber: phoneNumber.text!, profilePicture: profilePicture!)
        
            NetworkLayer.fetch(endPoint, with: LoginResponse.self) { (result ) in
            switch result {
            case .success(let response):
                SVProgressHUD.dismiss()
                if response.status == true {
                    persistence.save(response.data, success: { success in
                        self.navigationController?.popViewController(animated: true)
                    })
                } else {
                    self.showAlert(title: KMessageTitle, message: response.message ?? "Server Error".localized() , controller: self)
                }
            case .failure(_): break
                
            }
            
        }
      }
    }
    
}

extension UBEditProfileVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == self.dob {
            self.firstName.resignFirstResponder()
            self.lastName.resignFirstResponder()
            self.passwordName.resignFirstResponder()
            self.confirmPasswordName.resignFirstResponder()
            self.phoneNumber.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.dob {
            self.passwordName.resignFirstResponder()
            self.confirmPasswordName.resignFirstResponder()
            self.dob.resignFirstResponder()
            datePickerTapped()
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.phoneNumber {
            let currentText = phoneNumber.text ?? ""
            guard let stringRange = Range(range, in: currentText) else { return false }
            
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            return updatedText.count <= 14
        }
        
        return true
        
    }
    
    @objc func date(date: Any) {
        print(WAShareHelper.getFormattedDate2(string: date as! Date))
    }
}

extension UBEditProfileVC : UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout, UICollectionViewDataSource
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
        let cgFloat: CGFloat = cell.imgOfAvatar.frame.size.width/2.0
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
        let avatarURL = listCountry?.getCountriesAndAvatar?.avatarList![indexPath.row].image_path!
        self.profileImage.setImage(with: avatarURL, placeholder: UIImage(named: "profile2"))
//        WAShareHelper.loadImage(urlstring: avatarURL! , imageView: (self.imgOfPRofile!), placeHolder: "profile2")
        let cgFloat: CGFloat = self.profileImage.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.profileImage, radius: CGFloat(someFloat))
        
        self.viewOfAvatars.isHidden = true

        
//        let avatarId = self.userSession?.userAvat![indexPath.row].id
//        profilePicture = "\(avatarId!)"
//        let avatarURL = self.userSession!.userAvat![indexPath.row].imagePath!
//        self.profileImage.sd_setImage(with: URL(string: avatarURL)) { (image, error, cache, url) in
//
//        }
//        self.viewOfAvatars.isHidden = true
    }
    
}

extension UBEditProfileVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view!.isDescendant(of: self.collectionView) {
            return false
        }
        return true
    }
}
