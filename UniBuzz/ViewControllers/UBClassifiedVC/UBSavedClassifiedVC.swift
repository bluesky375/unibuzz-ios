//
//  UBSavedClassifiedVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 17/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
  
  

class UBSavedClassifiedVC: UIViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    var listOfClassified : WelcomeClassified?
    private var isClassifiedFav  : [Int] = []
    private let refreshControl = UIRefreshControl()
//    @IBOutlet weak var searchBar: UISearchBar!
    var isSearch  : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postCollectionView.register(UINib(nibName: "RecentClassifiedsCell", bundle: nil), forCellWithReuseIdentifier: "RecentClassifiedsCell")
        getAllSavedClassified()
        if #available(iOS 10.0, *) {
           postCollectionView.refreshControl = refreshControl
        } else {
            postCollectionView.addSubview(refreshControl)
        }
         refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)

    }

    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
           getAllSavedClassified()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
               self.refreshControl.endRefreshing()
           }
        }
      }
    
    func getAllSavedClassified() {
//        self.searchBar.resignFirstResponder()

        WebServiceManager.get(params: nil, serviceName: CLASSIFIEDSAVE , serviceType: "Classified Save  List".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfClassified = (response as! WelcomeClassified)
            if this.listOfClassified?.status == true {
                for (_ , classfiedFav) in (((self!.listOfClassified?.favItem?.classifiedObj?.enumerated()))!) {
                    if classfiedFav.is_favorite == true {
                        self!.isClassifiedFav.append(classfiedFav.id!)
                    }
                }

                this.postCollectionView.delegate = self
                this.postCollectionView.dataSource = self
                this.postCollectionView.reloadData()
                this.refreshControl.endRefreshing()

            }
            else {
                self!.showAlert(title: KMessageTitle, message: (this.listOfClassified?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
//        func getSearchResult(search : String) {
//            let allSearch = search.replacingOccurrences(of: " ", with: "%20")
//            let serviceUrl = "\(CLASSIFIEDSAVE)?q=\(allSearch)"
//            self.searchBar.resignFirstResponder()
//            WebServiceManager.get(params: nil, serviceName: serviceUrl , serviceType: "Classified Save  List", modelType: WelcomeClassified.self, success: {[weak self] (response) in
//                guard let this = self else {
//                    return
//                }
//                this.listOfClassified = (response as! WelcomeClassified)
//                if this.listOfClassified?.status == true {
//    //                this.postCollectionView.delegate = self
//    //                this.postCollectionView.dataSource = self
//                    this.postCollectionView.reloadData()
//    //                this.refreshControl.endRefreshing()
//
//                }
//                else {
//                    self!.showAlert(title: KMessageTitle, message: (this.listOfClassified?.message!)!, controller: self)
//                }
//            }) { (error) in
//            }
//
//
//
//        }

    
    func classfiedUnFav(note : ClassifiedPost , index : IndexPath) {
        
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

  

extension UBSavedClassifiedVC : UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
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
        cell.btnFav.isSelected = true
        cell.delegate = self
        cell.indexSelect = indexPath
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
    
}
  

extension UBSavedClassifiedVC  : ClassifiedFavoriteDelegate {
    func classfiedFav(cell : RecentClassifiedsCell , selectIndex : IndexPath) {
        let  noteObj = listOfClassified?.favItem?.classifiedObj![selectIndex.row]
        
        DispatchQueue.global().async {[weak self] in
            self!.classfiedUnFav(note: noteObj! , index: selectIndex)
            DispatchQueue.main.sync { [weak self] in
                if let index  = self!.isClassifiedFav.index(where: {$0 == noteObj?.id}) {
                    self!.listOfClassified?.favItem?.classifiedObj?.remove(at: index)
                    self!.isClassifiedFav.remove(at: index)
                }
                self?.postCollectionView.reloadData()
            }
        }
        
        
//        if cell.btnFav.isSelected == true {
//            DispatchQueue.global().async { [weak self] in
//                self!.classfiedFav(note: noteObj! , index: selectIndex)
//                DispatchQueue.main.sync { [weak self] in
//                    self!.isClassifiedFav.append((noteObj?.id!)!)
//                    self!.listOfClassified?.clasifiedObj?.posts!.classifiedObj![selectIndex.row].is_favorite = true
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
//                    self!.listOfClassified?.clasifiedObj?.posts!.classifiedObj![selectIndex.row].is_favorite = false
//
//                }
//            }
//        }
    }
}
//  
//
//extension UBSavedClassifiedVC : UISearchBarDelegate {
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        isSearch = false
//        getAllSavedClassified()
//        searchBar.resignFirstResponder()
//
//        searchBar.showsCancelButton = true
//        
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
