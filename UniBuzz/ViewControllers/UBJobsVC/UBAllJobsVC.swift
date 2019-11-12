//
//  UBAllJobsVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBAllJobsVC: UIViewController {

    @IBOutlet weak var tblViewss : UITableView!
    var isSearch  : Bool?
    @IBOutlet weak var searchBar : UISearchBar!
    var listOfJob : Job?
    private var isNoteFav  : [Int] = []
    private let refreshControl = UIRefreshControl()
    
    var isSelectFilter : Bool?
//    var isSearch  : Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        isSelectFilter = false
        isSearch = false
        searchBar.showsCancelButton = false

        tblViewss.registerCells([
            AllJobCell.self , UBFilterJobCell.self ,
        ])
        
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)

        getAllJobs()
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            getAllJobs()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
     }

    func getAllJobs() {
        WebServiceManager.get(params: nil, serviceName: JOBLIST , serviceType: "Group List".localized(), modelType: Job.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfJob = (response as! Job)
            if this.listOfJob?.status == true {
                for (_ , jobFav) in (((this.listOfJob?.jobObj?.job?.jobList?.enumerated()))!) {
                    if jobFav.is_favorite == true {
                        self!.isNoteFav.append(jobFav.id!)
                    }
                }
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                this.refreshControl.endRefreshing()
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (this.listOfJob?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    func jobeFav(note : JobList , index : IndexPath) {
        
        let noteId = note.id
        let endPoint = "\(JOBFAV)\(noteId!)"
        //        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.noteFav(noteId: "\(noteId!)")
        //        group.enter()
        NetworkLayer.fetchPost(endPointss , url: endPoint , with: LoginResponse.self) { [weak self] (result) in
            switch result {
            case .success(let response):
                if response.status == true {
                }
            case .failure(let error):
                break
            }
            
        }
    }
    
//    @IBAction func btnSort_Pressed(_ sender: UIButton) {
//
//    }
//
//    @IBAction func btnApplyFilter(_ sender: UIButton) {
//        sender.isSelected = !sender.isSelected
//        if sender.isSelected == true {
//            isSelectFilter = true
//            self.tblViewss.reloadData()
//
//        } else {
//            isSelectFilter = false
//            self.tblViewss.reloadData()
//
//        }
//    }
    
        func getSearchResult(search : String) {
            let allSearch = search.replacingOccurrences(of: " ", with: "%20")
            let serviceUrl = "\(JOBLIST)?q=\(allSearch)"
            self.searchBar.resignFirstResponder()

            WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Classified List".localized(), modelType: Job.self, success: {[weak self] (response) in
                    guard let this = self else {
                        return
                    }
                    this.listOfJob = (response as! Job)
                    if this.listOfJob?.status == true {
                        for (_ , jobFav) in (((this.listOfJob?.jobObj?.job?.jobList?.enumerated()))!) {
                            if jobFav.is_favorite == true {
                                self!.isNoteFav.append(jobFav.id!)
                            }
                        }
                        this.tblViewss.reloadData()
                        this.refreshControl.endRefreshing()
                    }
                    else {
                        self!.showAlert(title: KMessageTitle, message: (this.listOfJob?.message!)!, controller: self)
                    }
                }) { (error) in
                }
        }
}

extension UBAllJobsVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isSelectFilter == true {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectFilter  == true {
            if section == 0 {  return 1 }
            else {
                return  (self.listOfJob?.jobObj?.job?.jobList!.count)!
                
            }
        } else {
              return self.listOfJob?.jobObj?.job?.jobList?.count ?? 0
            
        }
        
//        return
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if isSelectFilter == true {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(with: AllJobCell.self, for: indexPath)
              
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(with: AllJobCell.self, for: indexPath)
                cell.lblJobTitle.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].titleOfJob
                cell.lblCompanyName.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].company?.companyInfo?.company_name
                cell.lblJobType.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].availability
                if self.listOfJob?.jobObj?.job?.jobList![indexPath.row].nationality == 0 {
                     cell.lblNationality.text  =  "All".localized()
                } else {
                    cell.lblNationality.text  =  "Local".localized()
                }
                cell.lblSaalaryRange.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].salary
                cell.delegate = self
                cell.checkIndex = indexPath
                if self.listOfJob?.jobObj?.job?.jobList![indexPath.row].jobCity != nil {
                    cell.lblAddress.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].jobCity?.name
                } else {
                    cell.lblAddress.text  = "Not Specified".localized()
                }
                if isNoteFav.contains((self.listOfJob?.jobObj?.job?.jobList![indexPath.row].id)!) {
                    cell.btnFav.isSelected = true
                } else {
                    cell.btnFav.isSelected = false
                }
                cell.lblJobCategori.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].jobCategory?.name
                let postedDate = WAShareHelper.getFormattedDateNotTime(string: ( self.listOfJob?.jobObj?.job?.jobList![indexPath.row].created_at)!)
                cell.lblDatePosted.text = "Posted on :".localized() + " \(postedDate)"
                guard  let image = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].company?.companyInfo?.company_logo  else   {
                    return cell
                }
                WAShareHelper.loadImage(urlstring: image , imageView: (cell.companyLogo!), placeHolder: "profile2")
                let cgFloat: CGFloat = cell.companyLogo.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(cell.companyLogo, radius: CGFloat(someFloat))
                return cell

            }
        } else {
            let cell = tableView.dequeueReusableCell(with: AllJobCell.self, for: indexPath)
            cell.lblJobTitle.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].titleOfJob
            cell.lblCompanyName.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].company?.companyInfo?.company_name
            cell.lblJobType.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].availability
            if self.listOfJob?.jobObj?.job?.jobList![indexPath.row].nationality == 0 {
                 cell.lblNationality.text  =  "All".localized()
            } else {
                cell.lblNationality.text  =  "Local".localized()
            }
            cell.lblSaalaryRange.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].salary
            cell.delegate = self
            cell.checkIndex = indexPath
            if self.listOfJob?.jobObj?.job?.jobList![indexPath.row].jobCity != nil {
                cell.lblAddress.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].jobCity?.name
            } else {
                cell.lblAddress.text  = "Not Specified".localized()
            }
            if isNoteFav.contains((self.listOfJob?.jobObj?.job?.jobList![indexPath.row].id)!) {
                cell.btnFav.isSelected = true
            } else {
                cell.btnFav.isSelected = false
            }
            cell.lblJobCategori.text  = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].jobCategory?.name
            let postedDate = WAShareHelper.getFormattedDateNotTime(string: ( self.listOfJob?.jobObj?.job?.jobList![indexPath.row].created_at)!)
            cell.lblDatePosted.text = "Posted on :".localized() + " \(postedDate)"
            guard  let image = self.listOfJob?.jobObj?.job?.jobList![indexPath.row].company?.companyInfo?.company_logo  else   {
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
        if isSelectFilter == true {
            if indexPath.section == 0 {
                return 165.0
            } else {
                return 241.0

            }
        } else {
            return 241.0
        }
//        if indexPath.section == 0 {
//            if indexPath.row == 0 {
//
//            }
//        } else {
//             return 241.0
//        }
       
  
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSelectFilter == true {
            if indexPath.section == 1 {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
                vc?.bookDetail = self.listOfJob?.jobObj?.job?.jobList![indexPath.row]
                vc?.isComeFromAppliedJob = false
                self.navigationController?.pushViewController(vc!, animated: true)

            }
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
            vc?.bookDetail = self.listOfJob?.jobObj?.job?.jobList![indexPath.row]
            vc?.isComeFromAppliedJob = false
            self.navigationController?.pushViewController(vc!, animated: true)

        }

    }
}

extension UBAllJobsVC : JobFavoruiteDelegate {
    func jobfav(cell : AllJobCell , selectIndex : IndexPath) {
        // Book Marked button selection
        let  noteObj = self.listOfJob?.jobObj?.job?.jobList![selectIndex.row]
        
        if cell.btnFav.isSelected == true {
            DispatchQueue.global().async { [weak self] in
                self!.jobeFav(note: noteObj! , index: selectIndex)
                DispatchQueue.main.sync { [weak self] in
                    self!.isNoteFav.append((noteObj?.id!)!)
                    self!.listOfJob?.jobObj?.job?.jobList![selectIndex.row].is_favorite = true
                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
                self!.jobeFav(note: noteObj! , index: selectIndex)
                
                DispatchQueue.main.sync { [weak self] in
                    if let index  = self!.isNoteFav.index(where: {$0 == noteObj?.id}) {
                        self!.isNoteFav.remove(at: index)
                    }
                    self!.listOfJob?.jobObj?.job?.jobList![selectIndex.row].is_favorite = false
                }
            }
        }
    }
    
    func jobDetail(cell: AllJobCell, selectIndex: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
        vc?.bookDetail = self.listOfJob?.jobObj?.job?.jobList![selectIndex.row]
        vc?.isComeFromAppliedJob = false
        
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension UBAllJobsVC : UISearchBarDelegate {
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            //        getAllGroupList(page: 1)
            isSearch = false
            //        getAllGroupList(page: 1)
            getAllJobs()
            searchBar.showsCancelButton = false
            searchBar.resignFirstResponder()
        }
        
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = true
            isSearch = true
            
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
            getSearchResult(search: searchBar.text!)
            isSearch = true
            
            
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            //        searchBar.showsCancelButton = true
            
        }
        
        func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
            searchBar.showsCancelButton = true
            isSearch = false
            
            return true
        }
        func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
            searchBar.showsCancelButton = false
            
        }
    }
