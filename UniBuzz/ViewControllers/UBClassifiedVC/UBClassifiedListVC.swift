//
//  UBClassifiedListVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
  
  

class UBClassifiedListVC :  UIViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    var listOfClassified : WelcomeClassified?
    private var isClassifiedFav  : [Int] = []
    var isSearch  : Bool?
    @IBOutlet weak var searchBar: UISearchBar!
    private let refreshControl = UIRefreshControl()
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSearch = false
        searchBar.showsCancelButton = false

        postCollectionView.register(UINib(nibName: "ClassifiedHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ClassifiedHeaderCell")
        postCollectionView.register(UINib(nibName: "ClassifiedMoreCategoriesCell", bundle: nil), forCellWithReuseIdentifier: "ClassifiedMoreCategoriesCell")
        postCollectionView.register(UINib(nibName: "RecentClassifiedsCell", bundle: nil), forCellWithReuseIdentifier: "RecentClassifiedsCell")
        getAllClassified()
        
        if #available(iOS 10.0, *) {
            postCollectionView.refreshControl = refreshControl
        } else {
            postCollectionView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        
        if Connectivity.isConnectedToInternet() {
            getAllClassified()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
               self.refreshControl.endRefreshing()
           }
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    

    func getAllClassified() {
        WebServiceManager.get(params: nil, serviceName: CLASSIFIED , serviceType: "Classified List".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfClassified = (response as! WelcomeClassified)
            self!.numberOfPage = self!.listOfClassified?.clasifiedObj?.posts?.last_page
            self!.page = 1
            self!.isPageRefreshing = false

            if this.listOfClassified?.status == true {
                
                for (_ , classfiedFav) in (((this.listOfClassified?.clasifiedObj?.posts?.classifiedObj?.enumerated()))!) {
                    if classfiedFav.is_favorite == true {
                        self!.isClassifiedFav.append(classfiedFav.id!)
                    }
                }
                this.postCollectionView.delegate = self
                this.postCollectionView.dataSource = self
                this.postCollectionView.reloadData()
                this.refreshControl.endRefreshing()
                this.page = this.page + 1

            }
            else {
                self!.showAlert(title: KMessageTitle, message: (this.listOfClassified?.message!)!, controller: self)
            }
        }) { (error) in
        }

    }
    
    func makeRequest(pageSize : Int)  {
        
        print("page Size \(pageSize)")
        let serviceURL : String?
        
        serviceURL = "\(CLASSIFIED)?page=\(page)"
        WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: WelcomeClassified.self , success: { [weak self] (response) in
            
            guard let self = self else {return}
            let responeOfPagination = (response as? WelcomeClassified)!
            self.numberOfPage =  responeOfPagination.clasifiedObj?.posts?.last_page
            if responeOfPagination.status == true {
                self.isPageRefreshing = false
                DispatchQueue.main.async {
                    for (_ , obj) in (((responeOfPagination.clasifiedObj?.posts?.classifiedObj?.enumerated()))!) {
                        self.listOfClassified?.clasifiedObj?.posts?.classifiedObj?.append(obj)
                    }
                    
                    self.activity.stopAnimating()
                    
//                    self.postCollectionView?.performBatchUpdates({
//                        let indexSet = IndexSet(integer: 1)
//                        self.postCollectionView.reloadSections(indexSet)
//
//                    }, completion: nil)

                    self.postCollectionView.reloadData()
                    self.refreshControl.endRefreshing()
                    self.page = self.page + 1
                    
                }
            }
            else
            {
                
            }
        }) { (error) in
        }
    }

    @IBAction private func btnAddClassified(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCategoriesListVC") as? UBCategoriesListVC
        vc?.isComingFromAdd = true
        vc?.category = listOfClassified?.clasifiedObj?.category
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = "\(CLASSIFIED)?q=\(allSearch)"
        self.searchBar.resignFirstResponder()

        WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Classified List".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfClassified = (response as! WelcomeClassified)
            if this.listOfClassified?.status == true {
                for (_ , classfiedFav) in (((this.listOfClassified?.clasifiedObj?.posts?.classifiedObj?.enumerated()))!) {
                    if classfiedFav.is_favorite == true {
                        self!.isClassifiedFav.append(classfiedFav.id!)
                    }
                }
                this.postCollectionView?.performBatchUpdates({
//                    this.responseObj?.getUserDetail?.exerciseObjectss = responseObj?.execiseObj
                    let indexSet = IndexSet(integer: 2)
                    self!.postCollectionView.reloadSections(indexSet)
                    
                }, completion: nil)
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (this.listOfClassified?.message!)!, controller: self)
            }
            
        }) { (error) in
        }
        
    }

    func classfiedFav(note : ClassifiedPost , index : IndexPath) {
        
        let noteId = note.id
        let endPoint = "\(CLASSIFIEDFAV)\(noteId!)"
        let endPointss = AuthEndpoint.classfiedFav(noteId: "\(noteId!)")
        NetworkLayer.fetchPost(endPointss , url: endPoint , with: LoginResponse.self) {[weak self] (result) in
            switch result {
            case .success(let response):
                if response.status == true {
                }
            case .failure(let error):
                break
            }
        }
    }
}
  

extension UBClassifiedListVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 8
        }
        else if section == 1 {
            return 1
        } else {
            return listOfClassified?.clasifiedObj?.posts?.classifiedObj?.count ?? 0
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassifiedHeaderCell", for: indexPath) as! ClassifiedHeaderCell
            cell.lblCategoryName.text = listOfClassified?.clasifiedObj?.category![indexPath.row].categoryTitle
            let imageName = listOfClassified?.clasifiedObj?.category![indexPath.row].categoryIcon
            let imagePAth = "\(CLASSIFIEDBASEURL)\(imageName!)"
            WAShareHelper.loadImage(urlstring: imagePAth , imageView: (cell.imgOfCategories!), placeHolder: "profile2")
            return cell
        }
        else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassifiedMoreCategoriesCell", for: indexPath) as! ClassifiedMoreCategoriesCell
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentClassifiedsCell", for: indexPath) as! RecentClassifiedsCell
            cell.lblItemName.text = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].postTitle
            cell.lblItemDescription.text = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].datumDescription
            cell.lblLocation.text = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].location
            cell.lblDate.text = WAShareHelper.getFormattedDate(string: (listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].dateCreated!)!)
            let price = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].price
            cell.lblPRice.text = "AED".localized() + " \(price!)"
            cell.delegate = self
            cell.indexSelect = indexPath
            
            if isClassifiedFav.contains((listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].id)!) {
                cell.btnFav.isSelected = true
            } else {
                cell.btnFav.isSelected = false
            }

            let imageName = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].postImage
            let imgPAth = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].image_path
            let imgFullUrl = "\(imgPAth!)/\(imageName!)"
             WAShareHelper.loadImage(urlstring: imgFullUrl , imageView: (cell.imgOfUserPost!), placeHolder: "classifieds-placeholder")
            return cell

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 2 {
            if listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].subCategoryName == "Motors" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedCarDetailVC") as? UBClassifiedCarDetailVC
                vc?.classified = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedDetailVC") as? UBClassifiedDetailVC
                vc?.classified = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
                
            }

        } else if indexPath.section == 0 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSubCategorisListVC") as? UBSubCategorisListVC
            vc!.selectCategories = listOfClassified?.clasifiedObj?.category![indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCategoriesListVC") as? UBCategoriesListVC
//            vc?.category = listOfClassified?.clasifiedObj?.category
//            self.navigationController?.pushViewController(vc!, animated: true)

        }
        

    }
    
        func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
            if scrollView == postCollectionView {
                if ((postCollectionView.contentOffset.y + postCollectionView.frame.size.height) >= postCollectionView.contentSize.height) {
                    if isPageRefreshing == false {
                        isPageRefreshing = true
                        if page <= numberOfPage! {
                            self.makeRequest(pageSize: self.page)
                            self.activity.startAnimating()
//                            self.tblViewss.tableFooterView?.isHidden = false
                        } else {
    
                        }
    
                     }  else {
                    }
                } else {
                }
    
            }
    
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            let sizeOfCell = self.postCollectionView.frame.size.width/5
            return CGSize(width: sizeOfCell, height: 80.0)

        } else if indexPath.section == 1 {
            let sizeOfCell = self.postCollectionView.frame.size.width
            return CGSize(width: sizeOfCell , height: 62.0)
        } else {
            let sizeOfCell = self.postCollectionView.frame.size.width
            return CGSize(width: sizeOfCell , height: 126.0)
        }
    }

}
  

extension UBClassifiedListVC : CategoriesListDelegate {
    func categoriesList(cell: ClassifiedMoreCategoriesCell) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBCategoriesListVC") as? UBCategoriesListVC
        vc?.isComingFromAdd = false
        vc?.category = listOfClassified?.clasifiedObj?.category
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
  

extension UBClassifiedListVC : ClassifiedFavoriteDelegate {
    func classfiedFav(cell : RecentClassifiedsCell , selectIndex : IndexPath) {
        // Book Marked button selection
        let  noteObj = listOfClassified?.clasifiedObj?.posts!.classifiedObj![selectIndex.row]
        if cell.btnFav.isSelected == true {
            DispatchQueue.global().async { [weak self] in
                self!.classfiedFav(note: noteObj! , index: selectIndex)
                DispatchQueue.main.sync { [weak self] in
                    self!.isClassifiedFav.append((noteObj?.id!)!)
                    self!.listOfClassified?.clasifiedObj?.posts!.classifiedObj![selectIndex.row].is_favorite = true
                }
            }
        } else {
            DispatchQueue.global().async { [weak self] in
                 self!.classfiedFav(note: noteObj! , index: selectIndex)
                
                DispatchQueue.main.sync { [weak self] in
                    if let index  = self!.isClassifiedFav.index(where: {$0 == noteObj?.id}) {
                        self!.isClassifiedFav.remove(at: index)
                    }
                    self!.listOfClassified?.clasifiedObj?.posts!.classifiedObj![selectIndex.row].is_favorite = false

                }
            }
        }
   }
}
  

extension UBClassifiedListVC : UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        getAllClassified()
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
