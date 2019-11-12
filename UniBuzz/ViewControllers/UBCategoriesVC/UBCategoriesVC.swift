//
//  UBCategoriesVCViewController.swift
//  UniBuzz
//
//  Created by MobikasaNight on 29/10/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
class UBCategoriesVC: UIViewController {
    @IBOutlet weak var colletionView: UICollectionView!
    var index = 1
    var data: CategoriesData?
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        colletionView.register(UINib(nibName: CategoryCollectionViewCell.cellIdentifier, bundle: nil), forCellWithReuseIdentifier: CategoryCollectionViewCell.cellIdentifier)
        refreshControl.addTarget(self, action: #selector(refreshWithData), for: .valueChanged)
        if #available(iOS 10.0, *) {
            colletionView.refreshControl = refreshControl
        } else {
            colletionView.addSubview(refreshControl)
        }
        SVProgressHUD.show()
        self.getCategories()
        // Do any additional setup after loading the view.
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            getCategories()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func getCategories() {
        let serviceURL = CATEGORIES
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "", modelType: CategoriesModel.self, success: { [weak self](response) in
            SVProgressHUD.dismiss()
            guard let self = self else {return}
            self.refreshControl.endRefreshing()
            if let data = response as? CategoriesModel {
                self.data = data.data
                self.colletionView.reloadData()
            }
            }, fail: { [weak self] error in
                guard let self = self else {return}
                SVProgressHUD.dismiss()
                self.showAlert(title:StringConstants.appName , message: error.localizedDescription, controller: self)
        })
    }
    
    
    func getFilterData(searchStr: String? = nil, categoryId: String? = nil) {
        SVProgressHUD.show()
        let serviceURL = FILTERCATEGORIES
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "", modelType: FilterModel.self, success: { [weak self](response) in
            SVProgressHUD.dismiss()
            guard let self = self else {return}
            self.refreshControl.endRefreshing()
            if let data = response as? FilterModel {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAllNotesVC") as! UBAllNotesVC
                vc.searchStr = searchStr
                vc.categoryId = categoryId
                vc.data = data.data
                self.navigationController?.pushViewController(vc, animated: true)
            }
            }, fail: { [weak self] error in
                guard let self = self else {return}
                SVProgressHUD.dismiss()
                self.showAlert(title:StringConstants.appName , message: error.localizedDescription, controller: self)
        })
    }
    
    
    @IBAction func filterButtonAction(_ sender: Any) {
        self.getFilterData()
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UBCategoriesVC: UICollectionViewDataSource , UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = self.data?.categories {
            return data.count
        }
        return 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.cellIdentifier, for: indexPath) as! CategoryCollectionViewCell
        cell.cardView.layer.cornerRadius = 5
        if let data = self.data, let categories = data.categories, let baseURL = data.base_url {
            cell.setUpCell(model: categories[indexPath.row], baseURL: baseURL)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let data = self.data, let categories = data.categories, let id = categories[indexPath.row].id {
             self.getFilterData(categoryId: "\(id)")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let wid = (UIScreen.main.bounds.width - 30) / 3
        return CGSize(width: wid, height: wid)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
}

extension UBCategoriesVC : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        self.getFilterData(searchStr: searchBar.text)
    }
}
