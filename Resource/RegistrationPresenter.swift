//
//  RegistrationPresenter.swift
//  GARAGE SALE
//
//  Created by Ahmed Durrani on 24/01/2019.
//  Copyright © 2019 TeachEase Solution. All rights reserved.
//

import Foundation
  

protocol RegistrationDelegate{
    func showProgress()
    func hideProgress()
    func registrationDidSucceed()
    func registrationDidFailed(message: String)
}

class RegistrationPresenter  {
    var delegate: RegistrationDelegate
    
    init(delegate: RegistrationDelegate) {
        self.delegate = delegate
    }
    
    func signIn(email: String, password: String){
        if email.isEmpty {
            print("omayib")
            self.delegate.registrationDidFailed(message: kValidationEmailEmpty)
        } else if !(UtilityHelper.isValidEmailAddress(email)) {
            self.delegate.registrationDidFailed(message: kValidationEmailInvalidInput)

        }
        else if password.isEmpty {
            self.delegate.registrationDidFailed(message: kValidationPasswordEmpty)
        } else if password.count < kPasswordRequiredLength {
            self.delegate.registrationDidFailed(message: KValidationPassword)
        } else {
            self.delegate.registrationDidSucceed()
        }
    }
    
    func registeration(firstName : String , lastName : String  ,  txtEmail : String , selectCountries : Bool , selectUni : Bool , seelctCampus : Bool ,  selectCollege : Bool , password : String , confirmPass : String , studentLeve : Bool , profilePic : Bool){
        
        if firstName.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the First Name".localized())
        } else if !isValidName(name: firstName) {
            self.delegate.registrationDidFailed(message: "Full Name must be alphabet characters.\n".localized())
        }
        else if lastName.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Last Name".localized())
        } else if !isValidName(name: lastName) {
            self.delegate.registrationDidFailed(message: "Last Name must be alphabet characters.\n".localized())
        }
        else if  txtEmail.isEmpty {
            self.delegate.registrationDidFailed(message: kValidationEmailEmpty)
        } else if !(UtilityHelper.isValidEmailAddress(txtEmail)) {
            self.delegate.registrationDidFailed(message: kValidationEmailInvalidInput)
        }
        else if selectCountries == false   {
            self.delegate.registrationDidFailed(message: "Please select the Country".localized())
        } else if selectUni == false  {
            self.delegate.registrationDidFailed(message: "Please select the University".localized())
        } else if seelctCampus == false  {
            self.delegate.registrationDidFailed(message: "Please select the Campus".localized())
        } else if selectCollege == false  {
            self.delegate.registrationDidFailed(message: "Please select the College".localized())
        } else if password.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please Enter the Password".localized())
        }  else if confirmPass.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please Enter the Confirm Password".localized())
        } else if password != confirmPass {
            self.delegate.registrationDidFailed(message: KPasswordMismatch)
        } else if studentLeve == false  {
            self.delegate.registrationDidFailed(message: "Please select the Student Level".localized())
        } else if profilePic == false  {
            self.delegate.registrationDidFailed(message: "Please select your avatar".localized())
        }
        else {
            self.delegate.registrationDidSucceed()
        }
        
        
    }

    
    func GroupCreate(groupName: String, groupDes: String){
        if groupName.isEmpty {
            self.delegate.registrationDidFailed(message: "Enter the group Name".localized())
        }
        else if groupName.count < 3 {
            self.delegate.registrationDidFailed(message: "Group Name must be greater then 3 ".localized())
        } else if groupName.count > 50 {
            self.delegate.registrationDidFailed(message: "Group Name must be Less then 50 ".localized())
        }
        else if groupDes.isEmpty {
            self.delegate.registrationDidFailed(message: "Enter the group description".localized())
        } else if groupDes.count > 150 {
            self.delegate.registrationDidFailed(message: "Group description must be Less then 150 ".localized())
        }
        else {
            self.delegate.registrationDidSucceed()
        }
    }
    
    func AddBookInfo(bookISBN : String){
        if bookISBN.isEmpty {
            self.delegate.registrationDidFailed(message: "Enter the ISBN Number".localized())
        }
        else if bookISBN.count < 10 {
            self.delegate.registrationDidFailed(message: "ISBN must not be less than 10 characters".localized())
        } else if bookISBN.count > 13 {
            self.delegate.registrationDidFailed(message: "ISBN must not be greater than 13 characters".localized())
        }
        else {
            self.delegate.registrationDidSucceed()
        }
    }


    func cvCreateInfo(objective : String, education : String  , exeperience : String , skills : String , reference : String ){
        if objective.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Objective".localized())
        } else if education.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Education".localized())
        } else if exeperience.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please Enter the Experience".localized())
        } else if skills.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please Enter the Skills".localized())
        } else if reference.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please Enter the reference".localized())
        }
        else {
            self.delegate.registrationDidSucceed()
        }
        
        
    }
    
    func basicUserInfo(profilePic : Bool , aboutMe : String  , txtPhone : String , txtEmail : String , nationalities : Bool , addrss : String , language : String , website : String , linked : String ){
        if profilePic == false {
            self.delegate.registrationDidFailed(message: "Please select the profile picture".localized())
        } else if aboutMe.isEmpty {
            self.delegate.registrationDidFailed(message: "Please enter the About me ".localized())
        }
        else if txtPhone.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please enter the phone number".localized())
        }
        else if txtPhone.count < 10 {
            self.delegate.registrationDidFailed(message: "Phone number must not be less than 10 characters".localized())
        }
        else if txtPhone.count > 13 {
            self.delegate.registrationDidFailed(message: "Phone number must not be greater than 13 characters".localized())
        }
        else if txtEmail.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please enter the email".localized())
        }  else if !(UtilityHelper.isValidEmailAddress(txtEmail)) {
            self.delegate.registrationDidFailed(message: kValidationEmailInvalidInput)
        }
        else if nationalities == false   {
            self.delegate.registrationDidFailed(message: "Please select the nationalities".localized())
        } else if addrss.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please enter the address".localized())
        } else if language.isEmpty  {
            self.delegate.registrationDidFailed(message: "Please enter the language".localized())
        }
//        else if website.isEmpty  {
//            self.delegate.registrationDidFailed(message: "Please Enter the Website Url")
//        }
//        else if verifyUrl(urlString: website) == false {
//            self.delegate.registrationDidFailed(message: "Please Enter Valid Website Url")
//        }
//        else if linked.isEmpty  {
//            self.delegate.registrationDidFailed(message: "Please Enter the LinkedIn Url")
//        }
//        else if verifyUrl(urlString: linked) == false {
//            self.delegate.registrationDidFailed(message: "Please Enter Valid LinkedIn Url")
//        }
        else {
            self.delegate.registrationDidSucceed()
        }
        
        
    }
    
    func postCreate(isSelectGroup : Bool , txtAdd : String  ){
        if isSelectGroup == false {
            self.delegate.registrationDidFailed(message: "Please Select the Group".localized())
        } else if txtAdd.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Comment".localized())
        } else if txtAdd.count > 5   {
            self.delegate.registrationDidFailed(message: "Comment must be greater than 5 characters".localized())
        }
        else {
            self.delegate.registrationDidSucceed()
        }
    }

    func pollCreate(isSelectGroup : Bool , txtAdd : String , option1 : String , option2 : String , option3 : String , option4 : String ,  option5 : String , option1Hide : Bool  , option2Hide : Bool , option3Hide : Bool ){
        if isSelectGroup == false {
            self.delegate.registrationDidFailed(message: "Please Select the Group".localized())
        } else if txtAdd.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Comment".localized())
        } else if txtAdd.count < 5   {
            self.delegate.registrationDidFailed(message: "Comment must be greater than 5 characters".localized())
        } else if option1.isEmpty {
            self.delegate.registrationDidFailed(message: "Please enter option 1".localized())

        } else if option2.isEmpty {
            self.delegate.registrationDidFailed(message: "Please enter option 2".localized())
        }
            
        else  if option1Hide == false {
             if option3.isEmpty {
                self.delegate.registrationDidFailed(message: "Please enter option 3".localized())
            }
        }
        else  if option2Hide == false {
             if option4.isEmpty {
                self.delegate.registrationDidFailed(message: "Please enter option 4".localized())
            }
            
        }
        else  if option3Hide == false {
                if option5.isEmpty {
                self.delegate.registrationDidFailed(message: "Please enter option 5".localized())
            }
        }
        else {
            self.delegate.registrationDidSucceed()
        }
    }
    
    
    func pollCreateValidator(isSelectGroup : Bool , txtAdd : String , option1 : String , option2 : String , option3 : Bool , option4 : Bool ,  option5 : Bool ){
        if isSelectGroup == false {
            self.delegate.registrationDidFailed(message: "Please Select the Group".localized())
        } else if txtAdd.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Comment".localized())
        } else if txtAdd.count < 5   {
            self.delegate.registrationDidFailed(message: "Comment must be greater than 5 characters".localized())
        } else if option1.isEmpty {
            self.delegate.registrationDidFailed(message: "Please enter option 1".localized())
            
        } else if option2.isEmpty {
            self.delegate.registrationDidFailed(message: "Please enter option 2".localized())
        }
            
        else  if option3 == true {
            self.delegate.registrationDidFailed(message: "Please enter option 3".localized())

        }
        else  if option4 == true {
                self.delegate.registrationDidFailed(message: "Please enter option 4".localized())
        }
            
        else  if option5 == true {
                self.delegate.registrationDidFailed(message: "Please enter option 5".localized())
        }
        else {
            self.delegate.registrationDidSucceed()
        }
    }
    

    
    func forgotPasswordValidation(email: String ){
        if email.isEmpty {
            self.delegate.registrationDidFailed(message: kValidationEmailEmpty)
        } else if !(UtilityHelper.isValidEmailAddress(email)) {
            self.delegate.registrationDidFailed(message: kValidationEmailInvalidInput)
        } else {
            self.delegate.registrationDidSucceed()
            
        }
    }

    func adddProductInfo(productTitle: String, price : String  , postImage : Bool){
        if productTitle.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Title".localized())
        } else if price.isEmpty {
            self.delegate.registrationDidFailed(message: "Please Enter the Price".localized())
        }
            
        else if postImage == false {
            self.delegate.registrationDidFailed(message: "Please Selected the Main Image")
        } else {
            self.delegate.registrationDidSucceed()
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
    
    func sendMessageValidation(message: String){
        if message.isEmpty {
            self.delegate.registrationDidFailed(message: "Enter the Message".localized())
        }
        else if message.count < 1  {
            self.delegate.registrationDidFailed(message: "Minimum Character must be 1".localized())
        }  else {
            self.delegate.registrationDidSucceed()
        }
    }


    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.shared.canOpenURL(url as URL)
            }
        }
        return false
    }

    
    
//    func registerValidation(fullName : String , email: String, phone : String ,  password: String , confrimPasswrod : String , age : String , address : String ){
//
//        if fullName.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationNameInput)
//        }
//
//        else if !isValidName(name: fullName) {
//            self.delegate.registrationDidFailed(message: kValidationNameInputCharacter)
//        }
//        else if email.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationEmailEmpty)
//
//        }
//        else if !(UtilityHelper.isValidEmailAddress(email)) {
//            self.delegate.registrationDidFailed(message: kValidationEmailInvalidInput)
//
//        } else if phone.isEmpty  {
//            self.delegate.registrationDidFailed(message: kValidationPhoneNumEmpty)
//
//        }
//
//        else if password.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationPasswordEmpty)
//        } else if password.count < kPasswordRequiredLength {
//            self.delegate.registrationDidFailed(message: KValidationPassword)
//        } else if confrimPasswrod.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationConfirmPasswordEmpty)
//        } else if confrimPasswrod.count < kPasswordRequiredLength {
//            self.delegate.registrationDidFailed(message: KValidationPassword)
//        } else if password != confrimPasswrod {
//            self.delegate.registrationDidFailed(message: KPasswordMismatch)
//        } else if age.isEmpty {
//            self.delegate.registrationDidFailed(message: "Please enter the age.")
//        }  else if address.isEmpty {
//            self.delegate.registrationDidFailed(message: "Please enter the address.")
//        }
//        else {
//            self.delegate.registrationDidSucceed()
//        }
//
//
//    }
//
//    func IsAddProduct(productName : String , isCategorue: Bool, address : String ,  productDesc: String , price : String , sizeSelect : Bool  , colorSelect : Bool , condition : Bool , shipFrom : String){
//
//        if productName.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationProductInput)
//        }
//
//        else if !isValidName(name: productName) {
//            self.delegate.registrationDidFailed(message: kValidationProductNameInputCharacter)
//        }
//        else if isCategorue == false  {
//            self.delegate.registrationDidFailed(message: KCategoriesSelect)
//        }
//        else if address.isEmpty {
//            self.delegate.registrationDidFailed(message: "Address can't be blank")
//        }
//
//        else if productDesc.isEmpty {
//            self.delegate.registrationDidFailed(message: KPRoductDescription)
//        }
//
//        else if price.isEmpty {
//            self.delegate.registrationDidFailed(message: "Price can't be empty")
//        }
//
//        else if sizeSelect == false  {
//            self.delegate.registrationDidFailed(message: "Please select the size")
//        }
//
//        else if colorSelect == false  {
//            self.delegate.registrationDidFailed(message: "Please select the color")
//        }
//        else if condition == false  {
//            self.delegate.registrationDidFailed(message: "Please select the condition of product")
//        }
//
//       else if shipFrom.isEmpty {
//            self.delegate.registrationDidFailed(message: "Please enter the Ship Address")
//        }
//
//        else {
//            self.delegate.registrationDidSucceed()
//        }
//
//
//    }
//
//
//    func registerCardInfo(cardNum : String , cardHolderName: String, expiryDate : String ,  cvvNum: String){
//
//        if cardNum.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationCardNumInput)
//        }
//        else if cardHolderName.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationCardHolderNameInput)
//
//        }
//        else if !isValidName(name: cardHolderName) {
//            self.delegate.registrationDidFailed(message: kValidationCardHolderNameInputCharacter)
//        }
//        else if expiryDate.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationCardExpiryDate)
//
//        }
//        else if cvvNum.isEmpty  {
//            self.delegate.registrationDidFailed(message: kValidationCardCcvNum)
//
//        }
//        else {
//            self.delegate.registrationDidSucceed()
//        }
//
//
//    }
//
//
//    func isValidName(name: String) -> Bool {
//        let decimalCharacters = NSCharacterSet.decimalDigits
//        let decimalRange = name.rangeOfCharacter(from: decimalCharacters, options: String.CompareOptions.numeric, range: nil)
//
//        if decimalRange != nil {
//            return false
//        }
//        return true
//    }
//    func forgotPasswordValidation(email: String ){
//        if email.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationEmailEmpty)
//        } else if !(UtilityHelper.isValidEmailAddress(email)) {
//            self.delegate.registrationDidFailed(message: kValidationEmailInvalidInput)
//        } else {
//            self.delegate.registrationDidSucceed()
//
//        }
//    }
//
//    func validationOnChangePassword(password: String , confirmPass : String){
//        if password.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationPasswordEmpty)
//        }
//        else if confirmPass.isEmpty {
//            self.delegate.registrationDidFailed(message: kValidationConfirmPasswordEmpty)
//        } else if password != confirmPass  {
//            self.delegate.registrationDidFailed(message: KPasswordMismatch)
//
//        } else {
//            self.delegate.registrationDidSucceed()
//
//        }
//    }
//
//    func validationForUploadingIdentification(idNum: String , isImageSelect : Bool){
//        if idNum.isEmpty {
//            self.delegate.registrationDidFailed(message: KIDNumberValidat)
//        }
//        else if isImageSelect == false {
//            self.delegate.registrationDidFailed(message: KIMAGeSELECT)
//        }
//
//        else {
//            self.delegate.registrationDidSucceed()
//        }
//    }
    
}

//extension String {
//    var isPhoneNumber: Bool {
//        do {
//            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
//            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
//            if let res = matches.first {
//                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
//            } else {
//                return false
//            }
//        } catch {
//            return false
//        }
//    }
//}
