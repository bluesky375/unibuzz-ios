//
//  UBMyCVVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SlideMenuControllerSwift
  
class UBMyCVVC: UIViewController {
    var cvObj : UserResponse?
    @IBOutlet weak var tblViewss: UITableView!
    @IBOutlet weak var logoOfCv : UIImageView!
    
    @IBOutlet weak var lblSteps: UILabel!
    @IBOutlet weak var lblDetailTxt: UILabel!
    
    @IBOutlet weak var btnCreateCV: UIButton!
    @IBOutlet weak var menuButton: UIButton!
    private let refreshControl = UIRefreshControl()
    
    var cover_image: UIImage?
    var fromMenu = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.logoOfCv.isHidden = true
        self.lblSteps.isHidden = true
        self.lblDetailTxt.isHidden = true
        self.btnCreateCV.isHidden = true
        
        tblViewss.estimatedRowHeight = 286.0
        tblViewss.rowHeight = UITableView.automaticDimension
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.didLoadFeed(_:)), name: NSNotification.Name(rawValue: "CVCreate"), object: nil)
        
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        
        tblViewss.registerCells([
            CVHeaderCell.self , EducationCell.self
        ])
        
        getAllCvInfo()
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        getAllCvInfo()
    }
    
    @objc func didLoadFeed(_ notification: NSNotification) {
        getAllCvInfo()
    }
    func getAllCvInfo() {
        //        SVProgressHUD.show()
        //        var context = (cvObj)
        WebServiceManager.get(params: nil, serviceName: CVGET, serviceType: "Cv Info".localized(), modelType: UserResponse.self, success: { (response) in
            self.cvObj = (response as? UserResponse)
            //            SVProgressHUD.dismiss()
            if self.cvObj?.status == true {
                if self.cvObj?.cvData?.myCvObj == nil {
                    self.logoOfCv.isHidden = false
                    self.lblSteps.isHidden = false
                    self.lblDetailTxt.isHidden = false
                    self.btnCreateCV.isHidden = false
                    self.tblViewss.isHidden = true
                    self.refreshControl.endRefreshing()
                    
                } else {
                    self.logoOfCv.isHidden = true
                    self.lblSteps.isHidden = true
                    self.lblDetailTxt.isHidden = true
                    self.btnCreateCV.isHidden = true
                    self.tblViewss.isHidden = false
                    self.tblViewss.delegate = self
                    self.tblViewss.dataSource = self
                    self.tblViewss.reloadData()
                    self.refreshControl.endRefreshing()
                    
                }
            } else  {
                self.showAlert(title: KMessageTitle, message: self.cvObj!.message! , controller: self)
                
            }
        }) { (error) in
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if fromMenu == true {
            menuButton.setImage(UIImage(named: "arrow"), for: .normal)
        } else {
            menuButton.setImage(UIImage(named: "menu"), for: .normal)
            
        }
    }
    
    @IBAction private func btnCreateCV_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEnterCVInfoVC") as? UBEnterCVInfoVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if fromMenu == true {
            self.navigationController?.popViewController(animated: true)
        } else {
            if AppDelegate.isArabic() {
                self.slideMenuController()?.openRight()
            } else {
                self.slideMenuController()?.openLeft()
            }
            
        }
    }
    
    deinit {
        print("<<<<<<<<< UBMyCVVC delloc")
    }
}

extension UBMyCVVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 5
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(with: CVHeaderCell.self, for: indexPath)
            cell.lblName.text = self.cvObj?.cvData?.name
            cell.lblUniName.text = self.cvObj?.cvData?.university
            cell.lblCollegeName.text = self.cvObj?.cvData?.college
            cell.lblAboutInfo.text = self.cvObj?.cvData?.myCvObj?.about_me
            cell.lblPhone.text = self.cvObj?.cvData?.myCvObj?.phone
            cell.lblEmail.text = self.cvObj?.cvData?.myCvObj?.email
            cell.delegate = self
            cell.index = indexPath
            cell.lblLinkedProfile.text = self.cvObj?.cvData?.myCvObj?.linkedin
            let image = self.cvObj?.cvData?.myCvObj?.image
            let path = self.cvObj?.cvData?.myCvObj?.path
            if path == nil {
                
            }
            let fullPAth = "\(path!)/\(image!)"
            //            WAShareHelper.loadImage(urlstring: fullPAth , imageView: cell.imgOfUser! , placeHolder: "profile")
            
            WAShareHelper.loadImageWithCompletion(urlstring: fullPAth, showLoader: true, imageView: cell.imgOfUser!) {[weak self] (image) in
                self!.cover_image = image
            }
            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(with: EducationCell.self, for: indexPath)
                cell.lblTitle.text = "Objective".localized()
                cell.lblDetailText.text = self.cvObj?.cvData?.myCvObj?.objective
                cell.imgOfIcon.image = UIImage(named: "objectives_ic")
                cell.delegate = self
                cell.index = indexPath
                
                return cell
                
            }
                
            else  if indexPath.row  == 1 {
                let cell = tableView.dequeueReusableCell(with: EducationCell.self, for: indexPath)
                cell.lblTitle.text = "Education".localized()
                cell.lblDetailText.text = self.cvObj?.cvData?.myCvObj?.education
                cell.imgOfIcon.image = UIImage(named: "education_ic")
                cell.delegate = self
                cell.index = indexPath
                
                return cell
            }
            else  if indexPath.row  == 2 {
                let cell = tableView.dequeueReusableCell(with: EducationCell.self, for: indexPath)
                cell.lblTitle.text = "Experience".localized()
                cell.lblDetailText.text = self.cvObj?.cvData?.myCvObj?.experience
                cell.imgOfIcon.image = UIImage(named: "work_ic")
                
                cell.delegate = self
                cell.index = indexPath
                
                return cell
                
            }
                
            else  if indexPath.row  == 3 {
                let cell = tableView.dequeueReusableCell(with: EducationCell.self, for: indexPath)
                cell.lblTitle.text = "Skills".localized()
                cell.lblDetailText.text = self.cvObj?.cvData?.myCvObj?.skills
                cell.imgOfIcon.image = UIImage(named: "skills_ic")
                
                
                cell.delegate = self
                cell.index = indexPath
                
                return cell
                
            } else {
                let cell = tableView.dequeueReusableCell(with: EducationCell.self, for: indexPath)
                cell.lblTitle.text = "Reference".localized()
                cell.lblDetailText.text = self.cvObj?.cvData?.myCvObj?.references
                cell.imgOfIcon.image = UIImage(named: "reference_ic")
                
                cell.delegate = self
                cell.index = indexPath
                
                return cell
                
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
        
    }
}

extension UBMyCVVC : EditSkillsObjectiveDelegate  {
    func editSkills(cell : EducationCell , ind : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditBioDataVC") as? UBEditBioDataVC
        vc?.cvObj = self.cvObj
        vc?.cover_image = self.cover_image
        self.navigationController?.pushViewController(vc!, animated: true)
        
        
    }
    
}

extension UBMyCVVC : EditCvInfoDelegate {
    func editInfo(cell : CVHeaderCell , ind : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditMyCVVC") as? UBEditMyCVVC
        vc?.cvObj = self.cvObj
        vc?.cover_image = self.cover_image
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}
