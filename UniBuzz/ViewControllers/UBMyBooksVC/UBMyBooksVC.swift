//
//  UBMyBooksVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SCLAlertView
  


class UBMyBooksVC: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    var listOfBook : Book?
    @IBOutlet weak var searchBar: UISearchBar!
    var isSearch  : Bool?
    var indexCheck : Int?
    private let refreshControl = UIRefreshControl()

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

//        tblViewss.delegate = self
//        tblViewss.dataSource = self
//        tblViewss.reloadData()
        getMyBooks()
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            getMyBooks()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
    }

    
    func getMyBooks() {
        WebServiceManager.get(params: nil, serviceName: MYBOOK , serviceType: "Book List".localized(), modelType: Book.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfBook = (response as! Book)
            if this.listOfBook?.status == true {
                
                self?.listOfBook?.bookObj?.bookList = self?.listOfBook?.bookObj?.bookList?.unique(map : {$0.id})

                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
                this.refreshControl.endRefreshing()
            }
            else {
                this.showAlert(title: KMessageTitle, message: (this.listOfBook?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = "\(MYBOOK)?q=\(allSearch)"
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
    
    func deleteBooks(serviceUrl : String) {
        
        let param =    [ : ] as [String : Any]
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceUrl, isLoaderShow: true , serviceType: "Delete course".localized(), modelType: UserResponse.self, success: { (responseData) in
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

    
    @objc func deleteReason() {
        let selectBookId = self.listOfBook?.bookObj?.bookList![indexCheck!].id
        let serviceUrl = "\(DESTROYBOOK)\(selectBookId!)/1"
        DispatchQueue.global().async { [weak self] in
            self!.deleteBooks(serviceUrl: serviceUrl)
            DispatchQueue.main.sync { [weak self] in
                if let index  = self!.listOfBook?.bookObj?.bookList!.index(where: {$0.id == selectBookId}) {
                    self!.listOfBook?.bookObj?.bookList!.remove(at: index)
                }
                self!.tblViewss.reloadData()
            }
        }
    }
    
    @objc func deleteSecondReason() {
        let selectBookId = self.listOfBook?.bookObj?.bookList![indexCheck!].id
        let serviceUrl = "\(DESTROYBOOK)\(selectBookId!)/0"
        DispatchQueue.global().async { [weak self] in
            self!.deleteBooks(serviceUrl: serviceUrl)
            DispatchQueue.main.sync { [weak self] in
                if let index  = self!.listOfBook?.bookObj?.bookList!.index(where: {$0.id == selectBookId}) {
                    self!.listOfBook?.bookObj?.bookList!.remove(at: index)
                }
                self!.tblViewss.reloadData()
            }
        }
    }
    @objc func firstButton() {
    
    }
    
    @objc func secondButton() {
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        let icon = UIImage(named:"wall_checked")
        //        _ = alert.showCustom("UniBuzz", subTitle: ("Book Sold" as? String)!, color: color, icon: icon!, circleIconImage: icon!)
        let color = UIColor(red: 55/255.0, green: 69/255.0, blue: 163/255.0, alpha: 1.0)
        let alert = SCLAlertView(appearance: appearance)
        
        //        let alert = SCLAlertView()
        _ = alert.addButton("Yes".localized(), target:self, selector:#selector(UBMyBooksVC.deleteReason))
        _ = alert.addButton("No".localized(), target:self, selector:#selector(UBMyBooksVC.deleteSecondReason))
        //        _ = alert.showSuccess("UniBuzz", subTitle: "")
        _ = alert.showCustom("UniBuzz".localized(), subTitle: ("Book Sold" as? String)!.localized(), color: color, icon: icon!, circleIconImage: icon!)

    }
    
    func deleteItem() {
        
        let alertController = UIAlertController(title: "Uni Buzz".localized(), message: "Book Sold".localized(), preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Yes".localized(), style: .default, handler: { [weak self] action -> Void in
            //Do some other stuff
            let selectBookId = self!.listOfBook?.bookObj?.bookList![self!.indexCheck!].id
            let serviceUrl = "\(DESTROYBOOK)\(selectBookId!)/1"
            self!.confirmMation(serviceUrl: serviceUrl)
        }))
        
        alertController.addAction(UIAlertAction(title: "No".localized(), style: .default, handler: { [weak self] action -> Void in
            //Do some other stuff
            let selectBookId = self!.listOfBook?.bookObj?.bookList![self!.indexCheck!].id
            let serviceUrl = "\(DESTROYBOOK)\(selectBookId!)/0"
            self!.confirmMation(serviceUrl: serviceUrl)
            //            dismissCompletion()
        }))
        
        present(alertController, animated: true, completion:nil)


    }
    
    func confirmMation(serviceUrl : String) {
        self.showAlertViewWithTitle(title: KMessageTitle, message: "Are you sure to want to delete this ?".localized()) {
            let selectBookId = self.listOfBook?.bookObj?.bookList![self.indexCheck!].id

            DispatchQueue.global().async { [weak self] in
                self!.deleteBooks(serviceUrl: serviceUrl)
                DispatchQueue.main.sync { [weak self] in
                    if let index  = self!.listOfBook?.bookObj?.bookList!.index(where: {$0.id == selectBookId}) {
                        self!.listOfBook?.bookObj?.bookList!.remove(at: index)
                    }
                    self!.tblViewss.reloadData()
                }
        }

    }
    }
}

extension UBMyBooksVC : UITableViewDelegate , UITableViewDataSource {
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
        let price = self.listOfBook?.bookObj?.bookList![indexPath.row].price
        
        
        if self.listOfBook?.bookObj?.bookList![indexPath.row].type == 1  {
             cell.lblPrice.text = " "
        } else {
            if price != nil {
                cell.lblPrice.text = "AED".localized() + " \(price!)"
            } else {
                cell.lblPrice.text = " "
            }

        }
        
        cell.delegate = self
        cell.indexCheck = indexPath
        cell.btnMore.isHidden = false
        guard  let image = self.listOfBook?.bookObj?.bookList![indexPath.row].book_cover  else   {
            return cell
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfBook!), placeHolder: "profile2")
        
        //        cell.imgOfBook.setImage(with: image , placeholder: UIImage(named: "profile2"))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 133.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBBookDetailVC") as? UBBookDetailVC
        vc!.bookList = self.listOfBook?.bookObj?.bookList![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}

extension UBMyBooksVC : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearch = false
        getMyBooks()
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

extension UBMyBooksVC : EditOrDeleteDelegate {
    func editOrDelete(cell: BookStoreCell, selectIndex: IndexPath) {
        
        indexCheck = selectIndex.row
//        let appearance = SCLAlertView.SCLAppearance(
//                    kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
//                    kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
//                    kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//                    showCloseButton: false,
//                    dynamicAnimatorActive: true,
//                    buttonsLayout: .horizontal
//        )
//        let icon = UIImage(named:"wall_checked")
//        let color = UIColor(red: 55/255.0, green: 69/255.0, blue: 163/255.0, alpha: 1.0)
//        let alert = SCLAlertView(appearance: appearance)
//        _ = alert.addButton("Edit", target:self, selector:#selector(UBMyBooksVC.firstButton))
//        _ = alert.addButton("Delet", target:self, selector:#selector(UBMyBooksVC.secondButton))
//        _ = alert.showCustom("UniBuzz", subTitle: ("" as? String)!, color: color, icon: icon!, circleIconImage: icon!)
        
        ActionSheetStringPicker.show(withTitle: "", rows: ["Delete".localized() , "Edit".localized()] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
            if index == 0 {
                self!.deleteItem()
            } else if index == 1 {
                let vc = self?.storyboard?.instantiateViewController(withIdentifier: "UBEditISBNBookVC") as? UBEditISBNBookVC
                vc?.bookinfo = self!.listOfBook?.bookObj?.bookList![selectIndex.row]
                self?.navigationController?.pushViewController(vc!, animated: true)
            }
            return
            }, cancel: { (actionStrin ) in
                
        }, origin: cell.btnMore)

    }
}


