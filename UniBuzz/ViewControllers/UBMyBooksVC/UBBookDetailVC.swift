//
//  UBBookDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
//import GrowingTextView
import SVProgressHUD
  
class UBBookDetailVC: UIViewController {

    @IBOutlet weak var imgOfCover: UIImageView!
    @IBOutlet weak var lblTitleOfBook: UILabel!
    @IBOutlet weak var lblNameOfUni: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblEdition: UILabel!
    @IBOutlet weak var lblAuthor: UILabel!
    @IBOutlet weak var lblIsbn: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var txtOFDescription: UITextView!
    var bookList : BookList?
    @IBOutlet weak var btnContactSeller: UIButton!
    @IBOutlet weak var textOFMessage: UITextField!
    
    var userObj : Session?
    var bookDetail : Book?
    
    var bookId : Int?
    
    var defualtImage : String?
    var defaultitle : String?

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgOfLocation: UIImageView!

    
    @IBOutlet weak var viewOfPop: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if bookList != nil {
            WAShareHelper.setViewCornerRadius(textOFMessage, radius: 20.0)
            let persistence = Persistence(with: .user)
            userObj  = persistence.load()
            txtOFDescription.placeholder = "Enter Message".localized()
            textOFMessage.setLeftPaddingPoints(10.0)
            
            if userObj?.id == self.bookList?.user_id  {
                self.btnContactSeller.isHidden = true
            } else {
                self.btnContactSeller.isHidden = false
            }
            
            if bookList?.location == nil {
                self.imgOfLocation.isHidden = true
            } else {
                  self.imgOfLocation.isHidden = false
            }
            lblTitle.text = bookList?.titleOfBook
            defaultitle = bookList?.titleOfBook
            defualtImage = bookList?.book_cover
            viewOfPop.isHidden = true
            lblTitleOfBook.text = bookList?.titleOfBook
            lblNameOfUni.text = bookList?.university_name
            lblLocation.text = bookList?.location
            let price = bookList?.price
            
            if bookList?.type == 1  {
                 lblPrice.text = " "
            } else {
                if price != nil {
                      lblPrice.text = "AED".localized() + " \(price!)"
                } else {
                      lblPrice.text = ""
                }

            }
            lblEdition.text = bookList?.location
            lblAuthor.text = bookList?.author
            lblIsbn.text = bookList?.isbn
            lblCondition.text = "Used".localized()
            txtOFDescription.text = bookList?.descriptionOfBook


            guard  let image = bookList?.book_cover  else   {
                return imgOfCover.image = UIImage(named: "profile2")
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (imgOfCover!), placeHolder: "profile2")

        } else {
            self.btnContactSeller.isHidden = true
            if userObj?.id == self.bookList?.user_id  {
                self.btnContactSeller.isHidden = true
            } else {
                self.btnContactSeller.isHidden = false
            }

            getBookDetail()
        }
        

        
        
        // Do any additional setup after loading the view.
    }
    
    func getBookDetail() {
        let bookID = bookId
        let serviceUrl = "\(BOOKDETAIL)\(bookID!)"
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Note Detail".localized(), modelType: Book.self, success: {[weak self] (response) in
            self!.bookDetail = (response as! Book)
            if self!.bookDetail?.status == true {
                SVProgressHUD.dismiss()
                self!.getBookInfo()
                
            } else {
                self?.showAlertViewWithTitle(title: KMessageTitle, message: (self!.bookDetail?.message!)!, dismissCompletion: {
                    self?.navigationController?.popViewController(animated: true)
                })
            }
        }) { (error) in

        }
    }
    
    func getBookInfo() {
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        txtOFDescription.placeholder = "Enter Message".localized()
        textOFMessage.setLeftPaddingPoints(10.0)
        viewOfPop.isHidden = true
        lblTitleOfBook.text = bookDetail?.bookDetail!.titleOfBook
        lblNameOfUni.text = bookDetail?.bookDetail?.university_name
        lblLocation.text = bookDetail?.bookDetail?.location
        
        if userObj?.id == bookDetail?.bookDetail?.user_id  {
            self.btnContactSeller.isHidden = true
        } else {
            self.btnContactSeller.isHidden = false
        }
        if bookDetail?.bookDetail?.location == nil {
            self.imgOfLocation.isHidden = true
        } else {
            self.imgOfLocation.isHidden = false
        }
        defualtImage = bookDetail?.bookDetail?.book_cover
        lblTitle.text = bookDetail?.bookDetail?.titleOfBook
        defaultitle = bookDetail?.bookDetail?.titleOfBook
        let price = bookDetail?.bookDetail?.price

        if bookDetail?.bookDetail?.type == 1  {
             lblPrice.text = " "
        } else {
            if price != nil {
                  lblPrice.text = "AED".localized() + " \(price!)"
            } else {
                  lblPrice.text = ""
            }

        }
//        if price != nil {
//              lblPrice.text = "AED \(price!)"
//        } else {
//              lblPrice.text = ""
//        }
        lblEdition.text = bookDetail?.bookDetail?.location
        lblAuthor.text = bookDetail?.bookDetail?.author
        lblIsbn.text = bookDetail?.bookDetail?.isbn
        lblCondition.text = "Used".localized()
        txtOFDescription.text = bookDetail?.bookDetail?.descriptionOfBook
        guard  let image = bookDetail?.bookDetail?.book_cover  else   {
            return imgOfCover.image = UIImage(named: "profile2")
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (imgOfCover!), placeHolder: "profile2")

    }



    @IBAction func btnCross(_ sender: UIButton) {
        self.viewOfPop.isHidden = true
        self.textOFMessage.text = ""
    }
    
    @IBAction private func btnViewImage(_ sender : UIButton)  {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier  : "UBBookSliderVC") as? UBBookSliderVC else {
            return
        }
        vc.defaultitle = defaultitle
        vc.slideImage = defualtImage
        self.navigationController?.pushViewController(vc , animated: true )


    }

    
    @IBAction func btnSendMessage(_ sender: UIButton) {
        
        var param = [:] as [String : Any]
        let bookID = bookList?.id
        let receiverId = bookList?.user_id
        
        if textOFMessage.text!.count > 1 {
        param = ["book_id"                         :  "\(bookID!)",
                 "message"                         :   textOFMessage.text! ,
                 "receiver_id"                     :   "\(receiverId!)"
                ]
        
        SVProgressHUD.show(withStatus: "Loading".localized())
        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: CONTACTSELLER , serviceType: "Chat".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    SVProgressHUD.show(withStatus: post.message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self]  in
                        SVProgressHUD.dismiss()
                        self?.viewOfPop.isHidden = true
                        self?.view.endEditing(true)
                    })
                } else {
                    self!.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
            }, fail: { (error) in
                //
        }, showHUD: true)
        
        } else {
            self.showAlert(title: KMessageTitle, message: "Message must be greater than 1 character".localized(), controller: self)

        }
    }
    @IBAction func btnContactSeller_Pressed(_ sender: UIButton) {
        self.viewOfPop.isHidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
