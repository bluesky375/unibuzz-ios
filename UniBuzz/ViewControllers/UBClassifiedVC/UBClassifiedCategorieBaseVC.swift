//
//  UBClassifiedCategorieBaseVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 17/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
  
  

class UBClassifiedCategorieBaseVC: UIViewController {
    var selectCategories : Category?
    @IBOutlet weak var postCollectionView: UICollectionView!
    var listOfClassified : WelcomeClassified?

    @IBOutlet weak var lblCategoriesSelect: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblCategoriesSelect.text = selectCategories?.categoryTitle
        postCollectionView.register(UINib(nibName: "RecentClassifiedsCell", bundle: nil), forCellWithReuseIdentifier: "RecentClassifiedsCell")
        getClassifiedSelectedCategories()
    }
    
    
    func getClassifiedSelectedCategories() {
        let categorieId = selectCategories?.id
        let serviceUrl = "\(CLASSIFIEDCATEGORIES)\(categorieId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Classified categories".localized(), modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {return}
            this.listOfClassified = (response as! WelcomeClassified)
            if this.listOfClassified?.status == true {
                this.postCollectionView.delegate = self
                this.postCollectionView.dataSource = self
                this.postCollectionView.reloadData()
            } else {
                self?.showAlert(title: KMessageTitle, message: this.listOfClassified!.message! , controller: self)
            }
        }) { (error) in
        }
    }
}

  

extension UBClassifiedCategorieBaseVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var numOfSections: Int = 0
        if  listOfClassified?.clasifiedObj?.posts?.classifiedObj!.isEmpty == false {
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
        return listOfClassified?.clasifiedObj?.posts?.classifiedObj?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentClassifiedsCell", for: indexPath) as! RecentClassifiedsCell
            cell.lblItemName.text = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].postTitle
            cell.lblItemDescription.text = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].datumDescription
            cell.lblLocation.text = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].location
            cell.lblDate.text = WAShareHelper.getFormattedDate(string: (listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].dateCreated!)!)
            let price = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].price
        cell.lblPRice.text = "AED".localized() + " \(price!)"
            
            let imageName = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].postImage
            let imgPAth = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].image_path
            let imgFullUrl = "\(imgPAth!)/\(imageName!)"
            WAShareHelper.loadImage(urlstring: imgFullUrl , imageView: (cell.imgOfUserPost!), placeHolder: "classifieds-placeholder")
            return cell
            
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
            if listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row].subCategoryName == "Motors" {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedCarDetailVC") as? UBClassifiedCarDetailVC
                vc?.classified = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
                
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedDetailVC") as? UBClassifiedDetailVC
                vc?.classified = listOfClassified?.clasifiedObj?.posts!.classifiedObj![indexPath.row]
                self.navigationController?.pushViewController(vc!, animated: true)
            }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let sizeOfCell = self.postCollectionView.frame.size.width
            return CGSize(width: sizeOfCell , height: 126.0)
    }
    
}
