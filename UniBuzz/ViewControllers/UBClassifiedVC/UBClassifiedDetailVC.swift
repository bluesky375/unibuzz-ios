//
//  UBClassifiedDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage
  
//import GrowingTextView
import SVProgressHUD

  
  

class UBClassifiedDetailVC: UIViewController {

    @IBOutlet weak var imgOfSlider: ImageSlideshow!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblUsage: UILabel!
    @IBOutlet weak var lblCondition: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    var classified : ClassifiedPost?
    @IBOutlet weak var viewOfPop: UIView!
//    @IBOutlet weak var textOFMessage: GrowingTextView!
    @IBOutlet weak var lblTitleOfSelectCategorie : UILabel!
    @IBOutlet weak var btnContactSeller: UIButton!
    @IBOutlet weak var textOFMessage: UITextField!
    var classifieDetail : WelcomeClassified?

    var userObj : Session?
    var bookId : Int?
    private var slideImage : [String] = []
//    var bookId : Int?
    var sendBookId : Int?
    var receiverId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WAShareHelper.setViewCornerRadius(textOFMessage, radius: 20.0)
        textOFMessage.setLeftPaddingPoints(10.0)
        
        if classified != nil {
             let persistence = Persistence(with: .user)
             userObj  = persistence.load()
             if userObj?.id == self.classified?.userID  {
                 self.btnContactSeller.isHidden = true
             } else {
                 self.btnContactSeller.isHidden = false
             }
            
            self.sendBookId = classified?.id
            self.receiverId = classified?.userID

            lblTitleOfSelectCategorie.text = classified?.postTitle
            imgOfSlider.slideshowInterval = 3.0
            imgOfSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
            imgOfSlider.contentScaleMode = UIView.ContentMode.scaleToFill
            let pageControl = UIPageControl()
            pageControl.currentPageIndicatorTintColor = UIColor(red: 103/255.0, green: 114/255.0, blue: 229/255.0, alpha: 1.0)
            pageControl.pageIndicatorTintColor = UIColor.lightGray
            imgOfSlider.pageIndicator = pageControl
            imgOfSlider.activityIndicator = DefaultActivityIndicator()
            imgOfSlider.contentScaleMode = UIView.ContentMode.scaleToFill
            imgOfSlider.clipsToBounds = true
            imgOfSlider.activityIndicator = DefaultActivityIndicator()
            slideImage.append(classified!.postImage!)
            
//            if self.classified?.postImage?.count == 0 {
//            }  else
            var sdWebImages = [SDWebImageSource]()
            let imgPAth = classified!.image_path
            for (_ , obj) in ((self.classified?.postImages?.enumerated())!) {
                slideImage.append(obj.name!)
            }
            
            for(_ , imgName) in self.slideImage.enumerated() {
                let imgFullUrl = "\(imgPAth!)/\(imgName)"
                sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
            }
            
            imgOfSlider.setImageInputs(sdWebImages)
            lblTitle.text = classified?.postTitle
            let price = classified!.price
            lblPrice.text =  "AED".localized() + " \(price!)"
            lblCreated.text = WAShareHelper.getFormattedDate(string: (classified?.dateCreated!)!)
            lblAge.text = classified?.ageName
            lblUsage.text = classified?.usageName
            lblCondition.text = classified?.conditionName
            lblDescription.text = classified?.datumDescription
            lblLocation.text = classified?.location

        } else {
//            self.btnContactSeller.isHidden = true
            getClassifiedDetail()
        }
    }
    
    func getClassifiedDetail() {
        let bookID = bookId
        let serviceUrl = "\(CLASSIFIEDVIEW)\(bookID!)"
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Note Detail".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            self!.classifieDetail = (response as! WelcomeClassified)
            if self!.classifieDetail?.status == true {
                SVProgressHUD.dismiss()
                self!.getClassifiedInfo()
                
            } else {
                self?.showAlertViewWithTitle(title: KMessageTitle, message: (self!.classifieDetail?.message!)!, dismissCompletion: {
                    self?.navigationController?.popViewController(animated: true)
                })
//                self!.showAlert(title: KMessageTitle, message: (self!.classifieDetail?.message!)!, controller: self)
            }
        }) { (error) in

        }
    }
    
    func getClassifiedInfo() {
        
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()

        if userObj?.id == self.classifieDetail?.classifiedDetail?.userID  {
            self.btnContactSeller.isHidden = true
        } else {
            self.btnContactSeller.isHidden = false
        }
        
        self.sendBookId = classifieDetail?.classifiedDetail?.id
        self.receiverId = classifieDetail?.classifiedDetail?.userID

        lblTitleOfSelectCategorie.text = classifieDetail?.classifiedDetail?.postTitle
        imgOfSlider.slideshowInterval = 3.0
        imgOfSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
        imgOfSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor(red: 103/255.0, green: 114/255.0, blue: 229/255.0, alpha: 1.0)
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        imgOfSlider.pageIndicator = pageControl
        imgOfSlider.activityIndicator = DefaultActivityIndicator()
        imgOfSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
        imgOfSlider.clipsToBounds = true
        imgOfSlider.activityIndicator = DefaultActivityIndicator()

        let imgPAth = classifieDetail?.classifiedDetail!.image_path
//        let postImage = classifieDetail?.classifiedDetail?.postImage
        var sdWebImages = [SDWebImageSource]()
//        let imgFullUrls = "\(postImage!)/\(imgPAth!)"
//        sdWebImages.append(SDWebImageSource(urlString: imgFullUrls)!)
        slideImage.append((classifieDetail?.classifiedDetail!.postImage!)!)

//        var sdWebImages = [SDWebImageSource]()
//        let imgPAth = classifieDetail?.classifiedDetail!.image_path
        for (_ , obj) in ((classifieDetail?.classifiedDetail?.postImages?.enumerated())!) {
            slideImage.append(obj.name!)
        }
        
        for(_ , imgName) in self.slideImage.enumerated() {
            let imgFullUrl = "\(imgPAth!)/\(imgName)"
            sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
        }
        imgOfSlider.setImageInputs(sdWebImages)
        lblTitle.text = classifieDetail?.classifiedDetail?.postTitle
        let price = classifieDetail?.classifiedDetail!.price
        lblPrice.text =  "AED".localized() + " \(price!)"
        lblCreated.text = WAShareHelper.getFormattedDate(string: (classifieDetail?.classifiedDetail?.dateCreated!)!)
        lblAge.text = classifieDetail?.classifiedDetail?.ageName
        lblUsage.text = classifieDetail?.classifiedDetail?.usageName
        lblCondition.text = classifieDetail?.classifiedDetail?.conditionName
        lblDescription.text = classifieDetail?.classifiedDetail?.datumDescription
        lblLocation.text = classifieDetail?.classifiedDetail?.location

    }
      

    @IBAction func btnSlideImage(_ sender: UIButton) {
        
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier  : "UBClassifiedImageSlider") as? UBClassifiedImageSlider else {
            return
        }
        if classified != nil {
            vc.classified = self.classified
         } else {
            vc.classified = classifieDetail?.classifiedDetail
          }
        //        vc.classified = self.classified
          self.navigationController?.pushViewController(vc , animated: true )

        
//           let vc = self.storyboard?.instantiateViewController(withIdentifier : "UBClassifiedImageSlider") as? UBClassifiedImageSlider
//           vc?.classified = self.classified
//           self.navigationController?.pushViewController(vc!, animated: true)
       }

    
    @IBAction func btnCross(_ sender: UIButton) {
        self.viewOfPop.isHidden = true
        self.textOFMessage.text = ""
        self.view.endEditing(true)
    }

    @IBAction func btnSendMessage(_ sender: UIButton) {
        var param = [:] as [String : Any]
        
        param = ["id"                         :  "\(self.sendBookId!)",
                "message"                          :   textOFMessage.text! ,
                "receiver_id"                         :   "\(receiverId!)"
        ]
        SVProgressHUD.show(withStatus: "Loading".localized())
        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: CLASSIFIEDCONTACTSELLER , serviceType: "Chat".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    SVProgressHUD.show(withStatus: post.message)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self]  in
                        SVProgressHUD.dismiss()
                        self?.textOFMessage.text = ""
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
