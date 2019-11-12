
//
//  UBCategoriesListVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
  
  

class UBCategoriesListVC: UIViewController {
    @IBOutlet weak var postCollectionView: UICollectionView!
    var  category: [Category]?
    var isComingFromAdd : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postCollectionView.register(UINib(nibName: "ClassifiedHeaderCell", bundle: nil), forCellWithReuseIdentifier: "ClassifiedHeaderCell")
        postCollectionView.delegate = self
        postCollectionView.dataSource = self
        postCollectionView.reloadData()
    }
}
  

extension UBCategoriesListVC: UICollectionViewDataSource , UICollectionViewDelegate , UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return category?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClassifiedHeaderCell", for: indexPath) as! ClassifiedHeaderCell
            cell.lblCategoryName.text = category![indexPath.row].categoryTitle
            let imageName = category![indexPath.row].categoryIcon
            let imagePAth = "\(CLASSIFIEDBASEURL)\(imageName!)"
            WAShareHelper.loadImage(urlstring: imagePAth , imageView: (cell.imgOfCategories!), placeHolder: "profile2")
            return cell
        }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sizeOfCell = self.postCollectionView.frame.size.width/5
        return CGSize(width: sizeOfCell, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isComingFromAdd == true {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SubClassifiedCategoriesVC") as? SubClassifiedCategoriesVC
            vc!.selectCategories = self.category![indexPath.row]
            let categorieId = self.category![indexPath.row].id
            vc!.selectCategorieId = "\(categorieId!)"
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSubCategorisListVC") as? UBSubCategorisListVC
            vc!.selectCategories = self.category![indexPath.row]
            self.navigationController?.pushViewController(vc!, animated: true)

        }
    }
    
}


