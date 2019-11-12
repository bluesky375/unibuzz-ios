//
//  UBAddBookVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import BarcodeScanner
import SVProgressHUD
  

class UBAddBookVC: UIViewController {
    var isSearch  : Bool?

    @IBOutlet weak var txtFieldOfISBN: UITextField!
    @IBOutlet weak var imgOfBook: UIImageView!
    var isbnBook : Book?

    @IBOutlet weak var btnAcedimic: UIButton!
    @IBOutlet weak var btnNonAcedmic: UIButton!
    @IBOutlet weak var btnSell: UIButton!
    @IBOutlet weak var btnDonate : UIButton!
    var isAcademicOrNonAcademic : Int?
    var isSellOrDonate : Int?
    var presenter: RegistrationPresenter?
    
    var bookinfo : BookList?

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if bookinfo != nil {
//            txtFieldOfISBN.text = bookinfo?.isbn
//            if bookinfo?.type == 0 {
//                isSellOrDonate = 0
//                btnSell.isSelected = false
//                btnDonate.isSelected = true
//                imgOfBook.setImage(with: bookinfo?.imageUrl , placeholder: UIImage(named: "profile2"))
//            } else {
//                isSellOrDonate = 1
//                btnSell.isSelected = true
//                btnDonate.isSelected = false
//            }
//            isAcademicOrNonAcademic = 1
////            txtFieldOfISBN.text = "0735619360"
//            txtFieldOfISBN.delegate = self
//            btnAcedimic.isSelected = true
//            btnNonAcedmic.isSelected = false
////            btnSell.isSelected = true
////            btnDonate.isSelected = false
//
//
//        } else {
//            isAcademicOrNonAcademic = 1
//            isSellOrDonate = 1
//            txtFieldOfISBN.text = "0735619360"
//            txtFieldOfISBN.delegate = self
//            btnAcedimic.isSelected = true
//            btnNonAcedmic.isSelected = false
//            btnSell.isSelected = true
//            btnDonate.isSelected = false
//        }
        
        isAcademicOrNonAcademic = 1
        isSellOrDonate = 1
//        txtFieldOfISBN.text = "0735619360"
        txtFieldOfISBN.delegate = self
        btnAcedimic.isSelected = true
        btnNonAcedmic.isSelected = false
        btnSell.isSelected = true
        btnDonate.isSelected = false
        presenter = RegistrationPresenter(delegate: self)
    }

    @IBAction private func btnContinue(_ sender : UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSubmitBookInfoVC") as? UBSubmitBookInfoVC
        vc?.bookISBN = self.isbnBook?.bookISBN
        vc?.isSellOrDonate = isSellOrDonate
        vc?.isAcademicOrNonAcademic = isAcademicOrNonAcademic
        vc?.isbn = txtFieldOfISBN.text ?? " "
        self.navigationController?.pushViewController(vc!, animated: true)

//        self.presenter?.signIn(email: txtEmail.text!, password: txtPassword.text!)
//        self.presenter?.AddBookInfo(bookISBN: "abc")
        
    }
    
    @IBAction private func btnAcedimic_Pressed(_ sender : UIButton) {
//        sender.isSelected = !sender.isSelected
        btnAcedimic.isSelected = true
        btnNonAcedmic.isSelected = false
        isAcademicOrNonAcademic = 1


        
    }
    
    @IBAction private func btnNonAcedimic_Pressed(_ sender : UIButton) {
        btnAcedimic.isSelected = false
        btnNonAcedmic.isSelected = true
        isAcademicOrNonAcademic = 0


        
    }

    @IBAction private func btnSell_Pressed(_ sender : UIButton) {
        btnSell.isSelected = true
        btnDonate.isSelected = false
        isSellOrDonate = 1

        
    }
    @IBAction private func btnDonate_Pressed(_ sender : UIButton) {
        btnSell.isSelected = false
        btnDonate.isSelected = true
        isSellOrDonate = 0

    }
    @IBAction private func btnScan(_ sender : UIButton) {
        
        let viewController = makeBarcodeScannerViewController()
//        viewController.codeDelegate = self
//        viewController.errorDelegate = self
//        viewController.dismissalDelegate = self
        //        viewController.title = "Barcode Scanner"
        present(viewController, animated: true, completion: nil)

    }
    
    private func makeBarcodeScannerViewController() -> BarcodeScannerViewController {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self
        viewController.errorDelegate = self
        viewController.dismissalDelegate = self
        return viewController
    }

    @IBAction private func btnSearchManuallyPressed(_ sender : UIButton) {
//
//        if txtFieldOfISBN.text!.isEmpty {
//            self.showAlert(title: KMessageTitle, message: "Enter the ISBN Number", controller: self)
//        }
//        else if txtFieldOfISBN.text!.count < 10 {
//            self.showAlert(title: KMessageTitle, message: "ISBN must not be less than 10 characters", controller: self)
//
//        } else if txtFieldOfISBN.text!.count > 13 {
//            self.showAlert(title: KMessageTitle, message: "ISBN must not be greater than 13 characters", controller: self)
//
//        }
//        else {

         txtFieldOfISBN.resignFirstResponder()
        let serviceUrl = "\(BOOKISBN)\(txtFieldOfISBN.text!)"
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Free Book List".localized(), modelType: Book.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()
            guard let this = self else {
                return
            }
            this.isbnBook = (response as! Book)
            if this.isbnBook?.status == true {
                guard  let image = this.isbnBook?.bookISBN?.thumbnail  else   {
                    return this.imgOfBook.isHidden =  true
                }
                WAShareHelper.loadImage(urlstring:image , imageView: (this.imgOfBook!), placeHolder: "profile2")
                
            } else {
                self?.showAlert(title: KMessageTitle, message: this.isbnBook!.message! , controller: self)
                
                
            }
        }) { (error) in
            
        }
            
//        }
       

    }
    
}

extension UBAddBookVC: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        let serviceUrl = "\(BOOKISBN)\(code)"
        SVProgressHUD.show()

        WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Free Book List".localized(), modelType: Book.self, success: {[weak self] (response) in
            SVProgressHUD.dismiss()

            guard let this = self else {
                return
            }
            this.isbnBook = (response as! Book)
            this.txtFieldOfISBN.text = code
            
            if this.isbnBook?.status == true {
                controller.dismiss(animated: true, completion: nil)
                guard  let image = this.isbnBook?.bookISBN?.thumbnail  else   {
                    return this.imgOfBook.isHidden =  true
                }
                WAShareHelper.loadImage(urlstring:image , imageView: (this.imgOfBook!), placeHolder: "profile2")
                
            } else {
                controller.dismiss(animated: true, completion: nil)
                self?.showAlert(title: KMessageTitle, message: this.isbnBook!.message! , controller: self)
            }
            
           
        }) { (error) in
            controller.dismiss(animated: true, completion: nil)

        }
    }
}

// MARK: - BarcodeScannerErrorDelegate

extension UBAddBookVC: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

// MARK: - BarcodeScannerDismissalDelegate

extension UBAddBookVC: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
    
    }
}

extension UBAddBookVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField : UITextField) -> Bool {
        
        return true
    }

}

extension UBAddBookVC : RegistrationDelegate {
    func showProgress(){
        
    }
    func hideProgress(){
        
    }
    
    func registrationDidSucceed(){
        
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSubmitBookInfoVC") as? UBSubmitBookInfoVC
            vc?.bookISBN = self.isbnBook?.bookISBN
            vc?.isSellOrDonate = isSellOrDonate
            vc?.isAcademicOrNonAcademic = isAcademicOrNonAcademic
            vc?.isbn = txtFieldOfISBN.text ?? " "
            self.navigationController?.pushViewController(vc!, animated: true)

      
    }
    
    func registrationDidFailed(message: String){
        self.showAlert(title: KMessageTitle , message: message, controller: self)
    }
}
