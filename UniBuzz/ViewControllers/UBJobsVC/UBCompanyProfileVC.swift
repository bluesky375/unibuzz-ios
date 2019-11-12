//
//  UBCompanyProfileVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
class UBCompanyProfileVC: UIViewController {
    @IBOutlet weak var tblViewss : UITableView!
    var jobDetail : JobList?
    var companyInfo : Job?
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewss.registerCells([
            CompanyHeaderCell.self , AllJobCell.self ,
        ])
        getCompanyInfo()
    }
    
    func getCompanyInfo() {
        let companyId = jobDetail?.company_id
        let serviceUrl = "\(COMPANYVIEW)\(companyId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: Job.self, success: {[weak self] (response) in
            guard let this = self else {return}
            this.companyInfo = (response as! Job)
            if this.companyInfo?.status == true {
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                
            } else {
                self?.showAlert(title: KMessageTitle, message: this.companyInfo!.message! , controller: self)
            }
        }) { (error) in
        }
    }
}

extension UBCompanyProfileVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
           return companyInfo?.company?.companyJobs?.count ?? 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(with: CompanyHeaderCell.self, for: indexPath)
            cell.lblCompanyName.text  = companyInfo?.company?.companyInfo?.company_name
            cell.lblDescription.text  = companyInfo?.company?.companyInfo?.company_desc
            cell.lblPhone.text  = companyInfo?.company?.companyInfo?.telephone
            cell.lblWebsite.text  = companyInfo?.company?.companyInfo?.website
            cell.lblAddress.text  = companyInfo?.company?.companyInfo?.address
            guard  let image = companyInfo?.company?.companyInfo?.company_logo  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring: image , imageView: (cell.companyLogo!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.companyLogo.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.companyLogo, radius: CGFloat(someFloat))
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(with: AllJobCell.self, for: indexPath)
            cell.lblJobTitle.text  = companyInfo?.company?.companyJobs![indexPath.row].titleOfJob
            cell.lblCompanyName.text  = companyInfo?.company?.companyJobs![indexPath.row].company?.companyInfo?.company_name
            cell.lblJobType.text  = companyInfo?.company?.companyJobs![indexPath.row].availability
            
            if companyInfo?.company?.companyJobs![indexPath.row].nationality == 0 {
                cell.lblNationality.text  =  "All".localized()
            } else {
                cell.lblNationality.text  =  "Local".localized()
            }
            cell.lblSaalaryRange.text  = companyInfo?.company?.companyJobs![indexPath.row].salary
            
            cell.delegate = self
            cell.checkIndex = indexPath
            if companyInfo?.company?.companyJobs![indexPath.row].jobCity != nil {
                cell.lblAddress.text  = companyInfo?.company?.companyJobs![indexPath.row].jobCity?.name
            } else {
                cell.lblAddress.text  = "Not Specified".localized()
            }
            
            cell.btnFav.isHidden = true
            cell.lblCompanyName.isHidden = true
//            if isNoteFav.contains((self.listOfJob?.jobObj?.jobList![indexPath.row].id)!) {
//                cell.btnFav.isSelected = true
//            } else {
//                cell.btnFav.isSelected = false
//            }
//
            
            cell.lblJobCategori.text  = companyInfo?.company?.companyJobs![indexPath.row].jobCategory?.name
            let postedDate = WAShareHelper.getFormattedDate(string: ( companyInfo?.company?.companyJobs![indexPath.row].created_at)!)
            cell.lblDatePosted.text = "Posted on :".localized() + " \(postedDate)"
            
            guard  let image = jobDetail?.company?.companyInfo?.company_logo  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring: image , imageView: (cell.companyLogo!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.companyLogo.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.companyLogo, radius: CGFloat(someFloat))
            

            return cell
            
            
        }
      
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 241.0
            
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
        vc?.bookDetail = companyInfo?.company?.companyJobs![indexPath.row]
        vc?.isComeFromAppliedJob = false
        self.navigationController?.pushViewController(vc!, animated: true)

    }
}

extension UBCompanyProfileVC : JobFavoruiteDelegate {
    func jobfav(cell: AllJobCell, selectIndex: IndexPath) {
        
    }
    
    func jobDetail(cell: AllJobCell, selectIndex: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
        vc?.bookDetail = companyInfo?.company?.companyJobs![selectIndex.row]
        vc?.isComeFromAppliedJob = false
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    

}
