//
//  UBClassifiedCarDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 17/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage
import GrowingTextView
import SVProgressHUD
  
  
  
class UBClassifiedCarDetailVC: UIViewController {
    
    @IBOutlet weak var imgOfSlider: ImageSlideshow!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblCreated: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    
    @IBOutlet weak var lblCarYear: UILabel!
    @IBOutlet weak var lblKilometer: UILabel!
    @IBOutlet weak var lblColor: UILabel!
    @IBOutlet weak var lblDoor: UILabel!
    @IBOutlet weak var lblSpec: UILabel!
    @IBOutlet weak var lblTrans: UILabel!
    @IBOutlet weak var lblBodyType: UILabel!
    @IBOutlet weak var lblWarrenty: UILabel!
    @IBOutlet weak var lblBodyCondition: UILabel!
    @IBOutlet weak var lblMechanicalCondition: UILabel!
    @IBOutlet weak var lblFuelType: UILabel!
    @IBOutlet weak var lblNumberOfCylender: UILabel!
    @IBOutlet weak var lblHorsePower: UILabel!
    
    
    @IBOutlet weak var viewOfPop: UIView!
//    @IBOutlet weak var textOFMessage: GrowingTextView!
    
    @IBOutlet weak var textOFMessage: UITextField!
    @IBOutlet weak var lblTitleOfSelectCategorie : UILabel!
    @IBOutlet weak var btnContactSeller: UIButton!
    var userObj : Session?
    var classified : ClassifiedPost?
    
    var classifieDetail : WelcomeClassified?
    var bookId : Int?
    private var slideImage : [String] = []
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
                       imgOfSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
                       let pageControl = UIPageControl()
                       pageControl.currentPageIndicatorTintColor = UIColor(red: 103/255.0, green: 114/255.0, blue: 229/255.0, alpha: 1.0)
                       pageControl.pageIndicatorTintColor = UIColor.lightGray
                       imgOfSlider.pageIndicator = pageControl
                       imgOfSlider.activityIndicator = DefaultActivityIndicator()
                       imgOfSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
                       imgOfSlider.clipsToBounds = true
                       imgOfSlider.activityIndicator = DefaultActivityIndicator()
                        slideImage.append(classified!.postImage!)

                       var sdWebImages = [SDWebImageSource]()
                       let imgPAth = classified!.image_path
                    
//                    var sdWebImages = [SDWebImageSource]()
//                    let imgPAth = classified!.image_path
                        for (_ , obj) in ((self.classified?.postImages?.enumerated())!) {
                            slideImage.append(obj.name!)
                        }
                    
                        for(_ , imgName) in self.slideImage.enumerated() {
                            let imgFullUrl = "\(imgPAth!)/\(imgName)"
                            sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
                        }

                    
//                       if (self.classified?.postImages!.count)! > 0 {
//                           for (_ , obj) in ((self.classified?.postImages?.enumerated())!) {
//                               let imageName = obj.name
//                               let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//
//                               sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//                           }
//                       } else {
//                           let imageName = classified?.postImage
//                           let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//
//                           sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//
//                       }
                     
                       imgOfSlider.setImageInputs(sdWebImages)
                       let price = classified?.price ?? " "
                       
                       lblPrice.text = "AED".localized() + " \(price)"
                       lblTitle.text = classified?.postTitle
                       lblCreated.text = WAShareHelper.getFormattedDate(string: (classified?.dateCreated!)!)
                       lblDescription.text = classified?.datumDescription
                       lblLocation.text = classified?.location
                       
                       
                       lblCarYear.text = classified?.yearName
                       lblKilometer.text = classified?.kilometer ?? " "
                       lblColor.text = classified?.bodyColorName ?? " "
                       lblDoor.text = classified?.doorsName ?? " "
                       lblSpec.text = classified?.regionalSpecName ?? " "
                       lblTrans.text = classified?.transmissionName ?? " "
                       lblBodyType.text = classified?.bodyTypeName ?? " "
                       lblWarrenty.text = classified?.warrantyName ?? " "
                       
                       
                       lblBodyCondition.text = classified?.bodyConditionName ?? " "
                       lblMechanicalCondition.text = classified?.mechanicalConditionName ?? " "
                       lblFuelType.text = classified?.fuelTypeName ?? " "
                       lblNumberOfCylender.text = classified?.cylinderName ?? " "
                       lblHorsePower.text = classified?.horsepowerName ?? " "

                } else {
                    getClassifiedDetail()
                }
        

        // Do any additional setup after loading the view.
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

                
            }
        }) { (error) in

        }
    }
    
    func getClassifiedInfo() {
          let persistence = Persistence(with: .user)
          userObj  = persistence.load()
             if userObj?.id == classifieDetail?.classifiedDetail?.userID  {
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
        
            slideImage.append((classifieDetail?.classifiedDetail!.postImage!)!)

            var sdWebImages = [SDWebImageSource]()
            let imgPAth = classifieDetail?.classifiedDetail!.image_path
            for (_ , obj) in ((classifieDetail?.classifiedDetail?.postImages?.enumerated())!) {
                slideImage.append(obj.name!)
            }
                                
                                    for(_ , imgName) in self.slideImage.enumerated() {
                                        let imgFullUrl = "\(imgPAth!)/\(imgName)"
                                        sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
                                    }

//          var sdWebImages = [SDWebImageSource]()
//          let imgPAth = classifieDetail?.classifiedDetail!.image_path
//
//          if (classifieDetail?.classifiedDetail?.postImages!.count)! > 0 {
//              for (_ , obj) in ((classifieDetail?.classifiedDetail?.postImages?.enumerated())!) {
//                  let imageName = obj.name
//                  let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//
//                  sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//              }
//          } else {
//              let imageName = classifieDetail?.classifiedDetail?.postImage
//              let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//
//              sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//
//          }
            self.sendBookId = classifieDetail?.classifiedDetail?.id
            self.receiverId = classifieDetail?.classifiedDetail?.userID


          imgOfSlider.setImageInputs(sdWebImages)
          let price = classifieDetail?.classifiedDetail?.price ?? " "
          
          lblPrice.text = "AED".localized() + " \(price)"
          lblTitle.text = classifieDetail?.classifiedDetail?.postTitle
          lblCreated.text = WAShareHelper.getFormattedDate(string: (classifieDetail?.classifiedDetail?.dateCreated!)!)
          lblDescription.text = classifieDetail?.classifiedDetail?.datumDescription
          lblLocation.text = classifieDetail?.classifiedDetail?.location
          lblCarYear.text = classifieDetail?.classifiedDetail?.yearName
          lblKilometer.text = classifieDetail?.classifiedDetail?.kilometer ?? " "
          lblColor.text = classifieDetail?.classifiedDetail?.bodyColorName ?? " "
          lblDoor.text = classifieDetail?.classifiedDetail?.doorsName ?? " "
          lblSpec.text = classifieDetail?.classifiedDetail?.regionalSpecName ?? " "
          lblTrans.text = classifieDetail?.classifiedDetail?.transmissionName ?? " "
          lblBodyType.text = classifieDetail?.classifiedDetail?.bodyTypeName ?? " "
          lblWarrenty.text = classifieDetail?.classifiedDetail?.warrantyName ?? " "
          
          
          lblBodyCondition.text = classifieDetail?.classifiedDetail?.bodyConditionName ?? " "
          lblMechanicalCondition.text = classifieDetail?.classifiedDetail?.mechanicalConditionName ?? " "
          lblFuelType.text = classifieDetail?.classifiedDetail?.fuelTypeName ?? " "
          lblNumberOfCylender.text = classifieDetail?.classifiedDetail?.cylinderName ?? " "
          lblHorsePower.text = classifieDetail?.classifiedDetail?.horsepowerName ?? " "

    }

    @IBAction func btnCross_Pressed(_ sender: UIButton) {
        self.view.endEditing(true)
        self.viewOfPop.isHidden = true
        self.textOFMessage.text = ""
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

        
    }

    @IBAction func btnSendMessage(_ sender: UIButton) {
        var param = [:] as [String : Any]
        param = ["id"                                :  "\(self.sendBookId!)",
                "message"                            :   textOFMessage.text ?? " " ,
                "receiver_id"                        :   "\(receiverId!)"
                ]
        
        SVProgressHUD.show(withStatus: "Loading".localized())
        WebServiceManager.postJson(params:param as Dictionary<String, AnyObject> , serviceName: CLASSIFIEDCONTACTSELLER , serviceType: "Chat".localized(), modelType: UserResponse.self, success: {[weak self] (responseData) in
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
