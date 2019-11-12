//
//  UBJobApplication.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
class UBJobApplication: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
//    var isSearch  : Bool?
//    @IBOutlet weak var searchBar: UISearchBar!
    var listOfJob : Job?
    private var isNoteFav  : [Int] = []
    private let refreshControl = UIRefreshControl()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        searchBar.showsCancelButton = false

        tblViewss.registerCells([
                AppliedJobsCell.self
            ])
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        
        getViewApplication()
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet() {
             getViewApplication()
        }  else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
               self.refreshControl.endRefreshing()
            }
         }
       }

    func getViewApplication() {
      
        WebServiceManager.get(params: nil, serviceName: JOBAPPLICATION , serviceType: "Job Application".localized(), modelType: Job.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfJob = (response as! Job)
            if this.listOfJob?.status == true {
                
//                if this.listOfJob?.jobObj?.job?.jobList != nil {
                    if (this.listOfJob?.getAllApplication?.jobList!.count)! > 0 {
                        for (_ , jobFav) in (((this.listOfJob?.getAllApplication?.jobList?.enumerated()))!) {
                            if jobFav.is_favorite == true {
                                self!.isNoteFav.append(jobFav.id!)
                            }
                        }
                    }
                
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                this.refreshControl.endRefreshing()

//                }
                
                

            }
            else {
                self!.showAlert(title: KMessageTitle, message: (this.listOfJob?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
//    func getSearchResult(search : String) {
//        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
//        let serviceUrl = "\(JOBAPPLICATION)?q=\(allSearch)"
//        self.searchBar.resignFirstResponder()
//
//        WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Classified List", modelType: Job.self, success: {[weak self] (response) in
//                guard let this = self else {
//                    return
//                }
//            this.listOfJob = (response as! Job)
////                if this.listOfJob?.status == true {
//
//            //                if this.listOfJob?.jobObj?.job?.jobList != nil {
//                  if (this.listOfJob?.getAllApplication?.jobList!.count)! > 0 {
//                      for (_ , jobFav) in (((this.listOfJob?.getAllApplication?.jobList?.enumerated()))!) {
//                             if jobFav.is_favorite == true {
//                                self!.isNoteFav.append(jobFav.id!)
//                            }
//                         }
//                     }
//
//
//            if this.listOfJob?.status == true {
//              if (this.listOfJob?.getAllApplication?.jobList!.count)! > 0 {
//                  for (_ , jobFav) in (((this.listOfJob?.getAllApplication?.jobList?.enumerated()))!) {
//                         if jobFav.is_favorite == true {
//                            self!.isNoteFav.append(jobFav.id!)
//                        }
//                     }
//                 }
//                this.tblViewss.reloadData()
//                this.refreshControl.endRefreshing()
//                }
//                else {
//                    self!.showAlert(title: KMessageTitle, message: (this.listOfJob?.message!)!, controller: self)
//                }
//            })
//        { (error) in
//
//        }
//    }
}

extension UBJobApplication : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfJob?.getAllApplication?.jobList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AppliedJobsCell.self, for: indexPath)
        cell.lblJobTitle.text  = self.listOfJob?.getAllApplication?.jobList![indexPath.row].titleOfJob
        cell.lblJobType.text  = self.listOfJob?.getAllApplication?.jobList![indexPath.row].type
        cell.lblCoverLetter.text  = self.listOfJob?.getAllApplication?.jobList![indexPath.row].myApplication?.job_cover_letter
        cell.delegate = self
        cell.checkIndex = indexPath
        if self.listOfJob?.getAllApplication?.jobList![indexPath.row].status == 0 {
            cell.lblIsJobOpen.text = "Open".localized()
            cell.lblIsJobOpen.textColor = UIColor(hex: "#42a542")
            cell.viewOfJobStatus.backgroundColor = UIColor(hex: "#ebf9ea")
        } else {
            cell.lblIsJobOpen.text = "Closed".localized()
            cell.lblIsJobOpen.textColor = UIColor(hex: "#a34141")
            cell.viewOfJobStatus.backgroundColor = UIColor(hex: "#f7ebeb")
        }
        if listOfJob?.getAllApplication?.jobList![indexPath.row].myApplication?.type == 0 {
            cell.lblJobStatus.text  = "Pending".localized()
            cell.lblJobStatus.textColor = UIColor(hex: "#d8b50b")
        } else if listOfJob?.getAllApplication?.jobList![indexPath.row].myApplication?.type == 1 {
            cell.lblJobStatus.text  = "Shortlisted".localized()
            cell.lblJobStatus.textColor = UIColor(hex: "#d8b50b")

        } else if listOfJob?.getAllApplication?.jobList![indexPath.row].myApplication?.type == 2 {
            cell.lblJobStatus.text  = "Rejected".localized()
            cell.lblJobStatus.textColor = UIColor(hex: "#a34141")

        } else if listOfJob?.getAllApplication?.jobList![indexPath.row].myApplication?.type == 3 {
            cell.lblJobStatus.text  = "Interviewing".localized()
            cell.lblJobStatus.textColor = UIColor(hex: "#d8b50b")

        } else if listOfJob?.getAllApplication?.jobList![indexPath.row].myApplication?.type == 4 {
            cell.lblJobStatus.text  = "Accepted".localized()
            cell.lblJobStatus.textColor = UIColor(hex: "#42a542")

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 210.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
        vc?.bookDetail = listOfJob?.getAllApplication?.jobList![indexPath.row]
        vc?.isComeFromAppliedJob = false
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
}

extension  UBJobApplication : AppliedJobDelegate {
    func jobDetail(cell : AppliedJobsCell , selectIndex : IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobDetailVC") as? UBJobDetailVC
        vc?.bookDetail = listOfJob?.getAllApplication?.jobList![selectIndex.row]
        vc?.isComeFromAppliedJob = true
        self.navigationController?.pushViewController(vc!, animated: true)

    }

}



//extension UBJobApplication : UISearchBarDelegate {
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearch = false
//        //        getAllGroupList(page: 1)
//        getViewApplication()
//        searchBar.showsCancelButton = false
//        searchBar.resignFirstResponder()
//    }
//    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = true
//        isSearch = true
//        
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        searchBar.resignFirstResponder()
//        getSearchResult(search: searchBar.text!)
//        isSearch = true
//        
//        
//    }
//    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        //        searchBar.showsCancelButton = true
//        
//    }
//    
//    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
//        searchBar.showsCancelButton = true
//        isSearch = false
//        
//        return true
//    }
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
//        
//    }
//}
