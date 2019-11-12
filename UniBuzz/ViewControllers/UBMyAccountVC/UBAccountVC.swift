//
//  UBAccountVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import SlideMenuControllerSwift
  
class UBAccountVC: UIViewController {
    @IBOutlet weak var tblViewss: UITableView!
    var index: Int?
    var userObj : Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        let persistence = Persistence(with: .user)
        //        userObj  = persistence.load()
        //        tblViewss.registerCells([
        //            UBPersonalDetailsCell.self , FooterMyAccountCell.self
        //            ])
        //        tblViewss.delegate = self
        //        tblViewss.dataSource = self
        //        tblViewss.reloadData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        tblViewss.registerCells([
            UBPersonalDetailsCell.self , FooterMyAccountCell.self
        ])
        tblViewss.delegate = self
        tblViewss.dataSource = self
        tblViewss.reloadData()
    }
    
    
    
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
}

extension UBAccountVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(with: UBPersonalDetailsCell.self, for: indexPath)
            cell.lblUserName.text = userObj?.full_name
            cell.lblUniName.text = userObj?.university_name
            cell.lblCollegeName.text = userObj?.college_name
            cell.lblReferalCode.text = userObj?.referral_code ?? " "
            cell.lblEmail.text = userObj?.email
            cell.lblMobileNum.text = userObj?.phone ?? " "
            cell.lblJoinedDate.text = WAShareHelper.getFormattedDate(string: userObj!.created_at!)
            //            cell.btnEmail.text =
            
            cell.btnEmail.setTitle(userObj?.user_primary_email ?? "Add Email".localized(), for: .normal)
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: FooterMyAccountCell.self, for: indexPath)
            cell.delegate = self
            return cell
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 293.0
        } else {
            return 134.0
        }
    }
}

extension UBAccountVC: UBPersonalDetailsCellDelegate {
    func referalCode(cell: UBPersonalDetailsCell) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBReferalCodeVC") as? UBReferalCodeVC
        vc!.userObj = userObj
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func editProfileAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBEditProfileVC") as? UBEditProfileVC
        self.navigationController?.pushViewController(vc! , animated: true)
    }
    
    func addPrimaryEmail(cell: UBPersonalDetailsCell) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddPrimaryEmailVC") as? UBAddPrimaryEmailVC
        if #available(iOS 10.0 , *)  {
            vc?.modalPresentationStyle = .overCurrentContext
        } else {
            vc?.modalPresentationStyle = .currentContext
        }
        vc?.delegate = self
        
        vc?.providesPresentationContextTransitionStyle = true
        present(vc!, animated: true) {
            
        }
        
        
        
    }
}

extension UBAccountVC: FooterMyAccountCellDelegate {
    
    func myGPAAction() {
        
        let mainFileVC = WAShareHelper.getViewController(from: "Account", with: "UBMyGPAVC") as! UBMyGPAVC
        mainFileVC.fromMenu = false
        self.navigationController?.pushViewController(mainFileVC, animated: true)
    }
    
    func myCVAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBMyCVVC") as? UBMyCVVC
        vc?.fromMenu = true
        self.navigationController?.pushViewController(vc! , animated: true)
    }
    
    func myCoursesAction() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBMyCourseVC") as? UBMyCourseVC
        vc?.isComeFromScreen = false
        self.navigationController?.pushViewController(vc!, animated: true)
        //        let mainFileVC = WAShareHelper.getViewController(from: "Account", with: "UBMyCourseVC") as! UBMyCourseVC
        ////        mainFileVC.fromMenu = false
        //        self.navigationController?.pushViewController(mainFileVC, animated: true)
    }
}

extension UBAccountVC: AddEmailDelegate {
    func addEmail(user: Session) {
        self.userObj = user
        self.tblViewss.reloadData()
    }
    
    
}
