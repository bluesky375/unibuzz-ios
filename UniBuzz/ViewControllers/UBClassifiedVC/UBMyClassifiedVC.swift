//
//  UBMyClassifiedVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 17/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
  

  
  

class UBMyClassifiedVC: UIViewController {
    
    @IBOutlet weak var postCollectionView: UICollectionView!
    var listOfClassified : WelcomeClassified?
    private var isClassifiedFav  : [Int] = []
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearch  : Bool?
    
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.showsCancelButton = false

        postCollectionView.register(UINib(nibName: "RecentClassifiedsCell", bundle: nil), forCellWithReuseIdentifier: "RecentClassifiedsCell")
        getAllUserClassified()
        
        if #available(iOS 10.0, *) {
           postCollectionView.refreshControl = refreshControl
        } else {
            postCollectionView.addSubview(refreshControl)
        }
         refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            getAllUserClassified()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
               self.refreshControl.endRefreshing()
           }
        }
    }
    
    func getAllUserClassified() {
        WebServiceManager.get(params: nil, serviceName: USERCLASSIFIED , serviceType: "Classified Save  List".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfClassified = (response as! WelcomeClassified)
            
            self!.numberOfPage = self!.listOfClassified?.favItem?.last_page
            self!.page = 1
            self!.isPageRefreshing = false

            if this.listOfClassified?.status == true {
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
            
            serviceURL = "\(USERCLASSIFIED)?page=\(page)"
            WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: WelcomeClassified.self , success: { [weak self] (response) in
                guard let self = self else {return}
                let responeOfPagination = (response as? WelcomeClassified)!
                self.numberOfPage =  responeOfPagination.favItem!.last_page
                
                if responeOfPagination.status == true {
                    self.isPageRefreshing = false
                    DispatchQueue.main.async {
                        for (_ , obj) in (((responeOfPagination.favItem?.classifiedObj?.enumerated()))!) {
                            self.listOfClassified?.favItem?.classifiedObj?.append(obj)
                        }
                        self.activity.stopAnimating()
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

    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = "\(USERCLASSIFIED)?q=\(allSearch)"
        self.searchBar.resignFirstResponder()
        WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Classified Save  List".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfClassified = (response as! WelcomeClassified)
            if this.listOfClassified?.status == true {
//                this.postCollectionView.delegate = self
//                this.postCollectionView.dataSource = self
                this.postCollectionView.reloadData()
//                this.refreshControl.endRefreshing()

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

    func deleteBooks(classfiedObj : ClassifiedPost) {
        
        let param =    [ : ] as [String : Any]
        let classifiedId = classfiedObj.id
        let serviceUrl = "\(DELETECLASSIFIED)\(classifiedId!)"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceUrl , isLoaderShow: true , serviceType: "Delete ".localized(), modelType: WelcomeClassified.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    //                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                    
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
        
    }

    func deleteItem(note : ClassifiedPost  , index : IndexPath) {
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this ?".localized()) {
         let selectClassifiedId = note.id
        
        DispatchQueue.global().async { [weak self] in
                self!.deleteBooks(classfiedObj: note)
            DispatchQueue.main.sync { [weak self] in
                if let index  = self!.listOfClassified?.favItem?.classifiedObj!.index(where: {$0.id == selectClassifiedId}) {
                    self!.listOfClassified?.favItem?.classifiedObj!.remove(at: index)
                }
             self!.postCollectionView.reloadData()
            }
          }
        }

    }

}
  

extension UBMyClassifiedVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        
        if  listOfClassified?.favItem?.classifiedObj?.isEmpty == false {
            numOfSections = 1
            postCollectionView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: postCollectionView.bounds.size.width, height: postCollectionView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Classfied .".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            postCollectionView.backgroundView = noDataLabel
            //            postCollectionView.separatorStyle = .none
        }
        return numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfClassified?.favItem?.classifiedObj?.count ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentClassifiedsCell", for: indexPath) as! RecentClassifiedsCell
        cell.lblItemName.text = listOfClassified?.favItem?.classifiedObj![indexPath.row].postTitle
        cell.lblItemDescription.text = listOfClassified?.favItem?.classifiedObj![indexPath.row].datumDescription
        cell.lblLocation.text = listOfClassified?.favItem?.classifiedObj![indexPath.row].location
        cell.lblDate.text = WAShareHelper.getFormattedDate(string: (listOfClassified?.favItem?.classifiedObj![indexPath.row].dateCreated!)!)
        let price = listOfClassified?.favItem?.classifiedObj![indexPath.row].price
        cell.lblPRice.text = "AED".localized() + " \(price!)"
        cell.delegate = self
        cell.indexSelect = indexPath
        cell.btnFav.setImage(UIImage(named: "more"), for: .normal)

//        if isClassifiedFav.contains((listOfClassified?.favItem?.classifiedObj![indexPath.row].id)!) {
//            cell.btnFav.isSelected = true
//        } else {
//            cell.btnFav.isSelected = false
//        }
        let imageName = listOfClassified?.favItem?.classifiedObj![indexPath.row].postImage
        let imgPAth = listOfClassified?.favItem?.classifiedObj![indexPath.row].image_path
        let imgFullUrl = "\(imgPAth!)/\(imageName!)"
        WAShareHelper.loadImage(urlstring: imgFullUrl , imageView: (cell.imgOfUserPost!), placeHolder: "classifieds-placeholder")
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if listOfClassified?.favItem?.classifiedObj![indexPath.row].subCategoryName == "Motors" {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedCarDetailVC") as? UBClassifiedCarDetailVC
            vc?.classified = listOfClassified?.favItem?.classifiedObj![indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
            
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedDetailVC") as? UBClassifiedDetailVC
            vc?.classified = listOfClassified?.favItem?.classifiedObj![indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.postCollectionView.frame.size.width
        return CGSize(width: sizeOfCell , height: 126.0)
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
    
}
  

extension UBMyClassifiedVC : ClassifiedFavoriteDelegate {
    func classfiedFav(cell : RecentClassifiedsCell , selectIndex : IndexPath) {
        // Book Marked button selection
        cell.btnFav.isSelected = false
        let  noteObj = listOfClassified?.favItem?.classifiedObj![selectIndex.row]
        
        ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Edit".localized() ] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
            if index == 0 {
                self!.deleteItem(note: noteObj!, index: selectIndex)
            }
            else if index == 1 {
                let vc = self!.storyboard?.instantiateViewController(withIdentifier: "UBEditSubCategoriesVC") as? UBEditSubCategoriesVC
                vc?.myClassified = self!.listOfClassified?.favItem?.classifiedObj![selectIndex.row]
                self!.navigationController?.pushViewController(vc!, animated: true)

            }
            return
            }, cancel: { (actionStrin ) in
                
        }, origin: cell.btnFav)
        
    //        if cell.btnFav.isSelected == true {
//            DispatchQueue.global().async { [weak self] in
//                self!.classfiedFav(note: noteObj! , index: selectIndex)
//                DispatchQueue.main.sync { [weak self] in
//                    self!.isClassifiedFav.append((noteObj?.id!)!)
//                    self!.listOfClassified?.favItem?.classifiedObj![selectIndex.row].is_favorite = true
//                }
//            }
//        } else {
//            DispatchQueue.global().async { [weak self] in
//                self!.classfiedFav(note: noteObj! , index: selectIndex)
//
//                DispatchQueue.main.sync { [weak self] in
//                    if let index  = self!.isClassifiedFav.index(where: {$0 == noteObj?.id}) {
//                        self!.isClassifiedFav.remove(at: index)
//                    }
//                    self!.listOfClassified?.favItem?.classifiedObj![selectIndex.row].is_favorite = false
//
//                }
//            }
//        }
    }
}
  

extension UBMyClassifiedVC : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        getAllUserClassified()
        searchBar.showsCancelButton = true
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
