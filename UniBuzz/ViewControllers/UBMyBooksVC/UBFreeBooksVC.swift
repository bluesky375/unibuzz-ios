//
//  UBFreeBooksVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
class UBFreeBooksVC: UIViewController {

    @IBOutlet weak var tblViewss    : UITableView!
    var listOfBook : Book?
    var isSearch  : Bool?
    @IBOutlet weak var searchBar: UISearchBar!
    private let refreshControl = UIRefreshControl()
    
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewss.registerCells([
            BookStoreCell.self
            ])
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        
        getAllFreeBook()
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
             getAllFreeBook()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getAllFreeBook() {
        WebServiceManager.get(params: nil, serviceName: FREEBOOK , serviceType: "Free Book List".localized(), modelType: Book.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfBook = (response as! Book)
            self!.numberOfPage = self!.listOfBook?.bookObj?.last_page
            self!.page = 1
            self!.isPageRefreshing = false

            if this.listOfBook?.status == true {
                
                self?.listOfBook?.bookObj?.bookList = self?.listOfBook?.bookObj?.bookList?.unique(map : {$0.id})

                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                this.refreshControl.endRefreshing()
                this.page = this.page + 1

            }
            else {
                this.showAlert(title: KMessageTitle, message: (this.listOfBook?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    func makeRequest(pageSize : Int)  {
            print("page Size \(pageSize)")
            let serviceURL : String?
            serviceURL = "\(FREEBOOK)?page=\(page)"
            WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: Book.self , success: { [weak self] (response) in
                let responeOfPagination = (response as! Book)
                self!.numberOfPage = responeOfPagination.bookObj?.last_page
                if responeOfPagination.status == true {
                    self!.isPageRefreshing = false
                    for (_ , noteType) in (((responeOfPagination.bookObj?.bookList?.enumerated()))!) {
                            self!.listOfBook?.bookObj?.bookList?.append(noteType)
                     }
                   
                    
                       self?.listOfBook?.bookObj?.bookList = self?.listOfBook?.bookObj?.bookList?.unique(map : {$0.id})
                        self!.tblViewss.tableFooterView?.isHidden = true
                        self!.activity.stopAnimating()
                        self!.tblViewss.reloadData()
                        self!.tblViewss.layoutIfNeeded()
                        self!.page = self!.page + 1

                    }
                
                
            }) { (error) in
            }
        }
    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = "\(FREEBOOK)?q=\(allSearch)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Book List".localized(), modelType: Book.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfBook = (response as! Book)
            if this.listOfBook?.status == true {
                this.tblViewss.reloadData()
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (this.listOfBook?.message!)!, controller: self)
            }
        }) { (error) in
        }
        
    }

}

extension UBFreeBooksVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfBook?.bookObj?.bookList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: BookStoreCell.self, for: indexPath)

        cell.lbTitle.text =  self.listOfBook?.bookObj?.bookList![indexPath.row].titleOfBook
        cell.lblUniName.text =  self.listOfBook?.bookObj?.bookList![indexPath.row].university_name
        cell.lblLocation.text =  self.listOfBook?.bookObj?.bookList![indexPath.row].location
        if self.listOfBook?.bookObj?.bookList![indexPath.row].location == nil {
                   cell.imgOfLocation.isHidden = true
               } else {
                    cell.imgOfLocation.isHidden = false
               }
        
    
//        let price = self.listOfBook?.bookObj?.bookList![indexPath.row].price
//        cell.lblPrice.text = "price \(price!)"

        cell.btnMore.isHidden = true
        cell.lblPrice.isHidden = true
        
        guard  let image = self.listOfBook?.bookObj?.bookList![indexPath.row].book_cover  else   {
            return cell
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfBook!), placeHolder: "profile2")

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBBookDetailVC") as? UBBookDetailVC
        vc?.bookList = self.listOfBook?.bookObj?.bookList![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
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

extension UBFreeBooksVC : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        getAllFreeBook()
        searchBar.showsCancelButton = true
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




