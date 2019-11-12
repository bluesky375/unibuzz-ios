//
//  UBSolutionsViewController.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 12/10/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
  
class UBSolutionsViewController: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    var listOfSol : WelcomeSolution?
    private var isMath  : [Int] = []
    private var isChmistry  : [Int] = []
    private var isPhysics  : [Int] = []
    
    var isSearch  : Bool?
    @IBOutlet weak var searchBar: UISearchBar!
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isSearch = false
        searchBar.showsCancelButton = false
        //        tblViewss.rowHeight = 0.0
        //        tblViewss.estimatedRowHeight = 0.0
        
        tblViewss.registerCells([
            SolutionCell.self
        ])
        getAllSolutions()
        
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData), for: .valueChanged)
        
        getAllSolutions()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction private func btnSideMenu_Pressed(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            getAllSolutions()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getAllSolutions() {
        WebServiceManager.get(params: nil, serviceName: SOLUTIONLIST , serviceType: "Solution List".localized(), modelType: WelcomeSolution.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            
            self!.listOfSol = (response as! WelcomeSolution)
            self!.numberOfPage = self!.listOfSol?.solutin?.last_page
            self!.page = 1
            self!.isPageRefreshing = false
            if self!.listOfSol?.status == true {
                for (_ , solutionType) in (((self!.listOfSol?.solutin?.listOfSolution?.enumerated()))!) {
                    if  solutionType.category_name == "Math" {
                        self!.isMath.append(solutionType.id!)
                    }
                    else  if solutionType.category_name == "Chemistry"  {
                        self!.isChmistry.append(solutionType.id!)
                        
                    }
                    else   if solutionType.category_name == "Physics" {
                        self!.isPhysics.append(solutionType.id!)
                    }
                }
                self!.tblViewss.delegate = self
                self!.tblViewss.dataSource = self
                self!.tblViewss.reloadData()
                self!.refreshControl.endRefreshing()
                self!.page = self!.page + 1
                
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfSol?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    func makeRequest(pageSize : Int)  {
        print("page Size \(pageSize)")
        let serviceURL : String?
        
        serviceURL = "\(SOLUTIONLIST)?page=\(page)"
        WebServiceManager.get(params: nil, serviceName: SOLUTIONLIST , serviceType: "Solution List".localized(), modelType: WelcomeSolution.self, success: {[weak self] (response) in
            let responeOfPagination = (response as! WelcomeSolution)
            
            self!.numberOfPage = responeOfPagination.solutin?.last_page
            if responeOfPagination.status == true {
                self!.isPageRefreshing = false
                
                for (_ , solutionType) in (((responeOfPagination.solutin?.listOfSolution?.enumerated()))!) {
                    self!.listOfSol?.solutin?.listOfSolution?.append(solutionType)
                    
                    if  solutionType.category_name == "Math" {
                        self!.isMath.append(solutionType.id!)
                    }
                    else  if solutionType.category_name == "Chemistry"  {
                        self!.isChmistry.append(solutionType.id!)
                        
                    }
                    else   if solutionType.category_name == "Physics" {
                        self!.isPhysics.append(solutionType.id!)
                    }
                }
                self!.tblViewss.tableFooterView?.isHidden = true
                self!.activity.stopAnimating()
                self!.tblViewss.reloadData()
                self!.refreshControl.endRefreshing()
                self!.tblViewss.layoutIfNeeded()
                self!.page = self!.page + 1
                
            }
            
        }) { (error) in
        }
    }
    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = "\(SOLUTIONLIST)?q=\(allSearch)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Search".localized(), modelType: WelcomeSolution.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            self!.listOfSol = (response as! WelcomeSolution)
            self!.numberOfPage = self!.listOfSol?.solutin?.last_page
            self!.page = 1
            self!.isPageRefreshing = false
            if self!.listOfSol?.status == true {
                for (_ , solutionType) in (((self!.listOfSol?.solutin?.listOfSolution?.enumerated()))!) {
                    if  solutionType.category_name == "Math" {
                        self!.isMath.append(solutionType.id!)
                    }
                    else  if solutionType.category_name == "Chemistry"  {
                        self!.isChmistry.append(solutionType.id!)
                        
                    }
                    else   if solutionType.category_name == "Physics" {
                        self!.isPhysics.append(solutionType.id!)
                    }
                }
                self!.tblViewss.delegate = self
                self!.tblViewss.dataSource = self
                self!.tblViewss.reloadData()
                self!.refreshControl.endRefreshing()
                self!.page = self!.page + 1
                
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfSol?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    deinit {
        print("<<<<<<<<< UBSolutionsViewController delloc")
    }
    
}

extension UBSolutionsViewController  : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfSol?.solutin?.listOfSolution?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SolutionCell.self, for: indexPath)
        cell.lblTitle.text =  self.listOfSol?.solutin?.listOfSolution![indexPath.row].sub_category_name
        cell.lblSubCategoriName.text =  self.listOfSol?.solutin?.listOfSolution![indexPath.row].sub_sub_category_name
        cell.lblQuestionType.text = self.listOfSol?.solutin?.listOfSolution![indexPath.row].titleOfLatex
        
        if isMath.contains((self.listOfSol?.solutin?.listOfSolution![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#058bed")
            cell.lblQuestionType.textColor = UIColor(hex: "#058bed")
        }
        else  if isPhysics.contains((self.listOfSol?.solutin?.listOfSolution![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#9a6ff7")
            cell.lblQuestionType.textColor = UIColor(hex: "#9a6ff7")
        }
        else  if isChmistry.contains((self.listOfSol?.solutin?.listOfSolution![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#d67000")
            cell.lblQuestionType.textColor = UIColor(hex: "#d67000")
        }
        guard let strungLatex = self.listOfSol?.solutin?.listOfSolution![indexPath.row].latex else {
            return cell
        }
        cell.viewOfQuestion.latex = strungLatex
        cell.viewOfQuestion.textAlignment = .center
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 161.0
    }
    
    func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
        if scrollView == tblViewss {
            if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
                if isPageRefreshing == false {
                    isPageRefreshing = true
                    if page <= numberOfPage! {
                        self.makeRequest(pageSize: self.page)
                        self.tblViewss.tableFooterView = self.activity
                        self.activity.startAnimating()
                        self.tblViewss.tableFooterView?.isHidden = false
                    } else {
                        
                    }
                    
                }  else {
                }
            } else {
            }
            
        }
        
    }
}

extension UBSolutionsViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        getAllGroupList(page: 1)
        isSearch = false
        searchBar.resignFirstResponder()
        
        //        getAllGroupList(page: 1)
        getAllSolutions()
        searchBar.showsCancelButton = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
        isSearch = true
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        //        getSearchResult(search: searchBar.text!)
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
