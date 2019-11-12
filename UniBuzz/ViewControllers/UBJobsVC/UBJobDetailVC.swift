//
//  UBJobDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBJobDetailVC: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    var bookDetail : JobList?
    var jobDetailInfo : Job?
    @IBOutlet weak var btnApplyJob    : UIButton!
    var isComeFromAppliedJob : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewss.registerCells([
            HeaderOJobCell.self , JobDescriptionCell.self ,
            ])
        
        
        if isComeFromAppliedJob == true {
//            btnApplyJob.isHidden = true
            btnApplyJob.setTitle("Already Applied".localized(), for: .normal)
            
        } else {
            btnApplyJob.setTitle("Apply Now".localized(), for: .normal)

            btnApplyJob.isHidden = false
        }
        tblViewss.estimatedRowHeight = 50.0
        tblViewss.rowHeight = UITableView.automaticDimension
        getViewBookInfo()
        // Do any additional setup after loading the view.
    }
    
    func getViewBookInfo() {
        let bookId = bookDetail?.id
        let serviceUrl = "\(JOBVIEW)\(bookId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: Job.self, success: {[weak self] (response) in
            guard let this = self else {return}
            this.jobDetailInfo = (response as! Job)
            if this.jobDetailInfo?.status == true {
                
                if this.jobDetailInfo?.jobDetail?.myApplication != nil {
                    this.btnApplyJob.setTitle("Already Applied".localized(), for: .normal)
                } else {
                    this.btnApplyJob.setTitle("Apply Now".localized(), for: .normal)
                }
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                

            } else {
                self?.showAlert(title: KMessageTitle, message: this.jobDetailInfo!.message! , controller: self)
            }
        }) { (error) in
        }
    }
    
    @IBAction private func btnApplied(_ sender : UIButton) {
        if jobDetailInfo?.jobDetail?.user_cv == true {
            if jobDetailInfo?.jobDetail?.myApplication == nil {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAppliedJobVC") as? UBAppliedJobVC
                vc!.bookDetail = self.bookDetail
                self.navigationController?.pushViewController(vc!, animated: true)

            }

        } else {
            let alertController = UIAlertController(title: KMessageTitle , message: "You need to add your cv for applying jobs".localized() , preferredStyle: UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title: "Create".localized(), style: .cancel, handler: { action -> Void in
                //Do some other stuff

                let storyboard = UIStoryboard.init(name: "Account", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "UBMyCVVC") as? UBMyCVVC
                vc?.fromMenu = true
                self.navigationController?.pushViewController(vc! , animated: true)

                
            }))
            alertController.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: { action -> Void in
                //Do some other stuff
            }))
            present(alertController, animated: true, completion:nil)

        }
//        if isComeFromAppliedJob == false {
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAppliedJobVC") as? UBAppliedJobVC
//            vc!.bookDetail = self.bookDetail
//            self.navigationController?.pushViewController(vc!, animated: true)
//        }
    }
}

extension UBJobDetailVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(with: HeaderOJobCell.self, for: indexPath)
            cell.lblJobTitle.text  = jobDetailInfo?.jobDetail?.titleOfJob
            cell.lblCompanyName.text  = jobDetailInfo?.jobDetail!.company?.companyInfo?.company_name
            cell.lblJobType.text  = jobDetailInfo?.jobDetail!.availability
//            cell.lblNationality.text  = jobDetailInfo?.jobDetail!.type
            cell.lblSaalaryRange.text  = jobDetailInfo?.jobDetail!.salary
            
            if jobDetailInfo?.jobDetail!.start_date != nil  {
                cell.lblPostedDate.text =         WAShareHelper.getFormattedDateOnDate(string: (jobDetailInfo?.jobDetail!.start_date)!)
            } else {
                cell.lblPostedDate.text =  " "
            }
            if jobDetailInfo?.jobDetail!.end_date != nil {
                cell.lblExpiryDate.text =         WAShareHelper.getFormattedDateOnDate(string: (jobDetailInfo?.jobDetail!.end_date)!)
            } else {
                cell.lblExpiryDate.text =        " "
            }
            
//            cell.lblExpiryDate.text =         WAShareHelper.getFormattedDateOnDate(string: (jobDetailInfo?.jobDetail!.end_date)!)

            
            cell.delegate = self
            if jobDetailInfo?.jobDetail!.jobCity != nil {
                cell.lblJobAddress.text  = jobDetailInfo?.jobDetail!.jobCity?.name
            } else {
                cell.lblJobAddress.text  = "Not Specified".localized()
            }
            guard  let image = jobDetailInfo?.jobDetail!.company?.companyInfo?.company_logo  else   {
                  return cell
            }
            WAShareHelper.loadImage(urlstring: image , imageView: (cell.companyLogo!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.companyLogo.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.companyLogo, radius: CGFloat(someFloat))
            return cell
        }
        else if indexPath.section == 1{
            let cellss = tableView.dequeueReusableCell(with: JobDescriptionCell.self, for: indexPath)

            cellss.lblTitle.text = "JOB DETAILS".localized()
            cellss.lblDescription.text =  jobDetailInfo?.jobDetail?.job_desc
            return cellss

            
        }
        else if indexPath.section == 2{
            let cellss = tableView.dequeueReusableCell(with: JobDescriptionCell.self, for: indexPath)

            cellss.lblTitle.text = "REQUIREMENTS".localized()
            cellss.lblDescription.text =  jobDetailInfo?.jobDetail?.job_requirements
            return cellss

        }
        else if indexPath.section == 3{
            let cellss = tableView.dequeueReusableCell(with: JobDescriptionCell.self, for: indexPath)

            cellss.lblTitle.text = "SKILLS".localized()
            cellss.lblDescription.text =  jobDetailInfo?.jobDetail?.job_skills
            return cellss

        }
        else  {
            let cellss = tableView.dequeueReusableCell(with: JobDescriptionCell.self, for: indexPath)

            cellss.lblTitle.text = "OTHER BENEFITS".localized()
            cellss.lblDescription.text =  jobDetailInfo?.jobDetail?.job_other_benefits
            return cellss

        }
        
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 241.0
        } else {
            return UITableView.automaticDimension

        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension UBJobDetailVC : CompanyInfoDelegate {
    func companyDetail(cell : HeaderOJobCell ) {
        
//        if jobDetailInfo?.jobDetail?.myApplication == nil {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCompanyProfileVC") as? UBCompanyProfileVC
            vc?.jobDetail = self.bookDetail
            self.navigationController?.pushViewController(vc!, animated: true)

//        }
    }
 
}
