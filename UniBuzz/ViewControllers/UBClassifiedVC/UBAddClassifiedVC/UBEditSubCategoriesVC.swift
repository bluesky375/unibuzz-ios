//
//  UBEditSubCategoriesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  

class UBEditSubCategoriesVC: UIViewController {

    var myClassified : ClassifiedPost?
    var categorisInfo : CreateClassified?
    @IBOutlet weak var tblViewss: UITableView!
    @IBOutlet weak var lblSelectCategorie: UILabel!
    var selectCategorieId : String?
    
    var indexSelect : Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSelectCategorie.text = myClassified?.postTitle
        getSubCategoriesList()
        // Do any additional setup after loading the view.
    }
    
    func getSubCategoriesList() {
        SVProgressHUD.show()
        let categorieId = myClassified?.id
        let serviceUrl = "\(EDITCLASSIFIED)\(categorieId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Sub categories".localized(), modelType: CreateClassified.self, success: {[weak self] (response) in
            guard let this = self else {return}
            SVProgressHUD.dismiss()
            this.categorisInfo = (response as! CreateClassified)
            if this.categorisInfo?.status == true {
                if (this.categorisInfo?.classifiedList![0].subCategoriesList?.count)! == 0 {
                  let vc  = self!.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedEditInfoVC") as? UBClassifiedEditInfoVC
                  vc?.myClassified = self!.myClassified
                  vc?.subSubCat = self!.categorisInfo?.classifiedList![0]
                  let selectSub = self!.myClassified?.subSubCategory
                  vc?.selectsubSubCat = "\(selectSub!)"
                  let catId = self!.myClassified?.subCategoryID
                  vc?.selectCategorieId = "\(catId!)"
                  self!.navigationController?.pushViewController(vc!, animated: true)

                } else {
                    this.tblViewss.delegate = self
                    this.tblViewss.dataSource = self
                    this.tblViewss.reloadData()

                }
                
            } else {
                self?.showAlert(title: KMessageTitle, message: this.categorisInfo!.message! , controller: self)
            }
        }) { (error) in
        }
    }
}

extension UBEditSubCategoriesVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorisInfo?.classifiedList![0].subCategoriesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SubCategoriesCell.self, for: indexPath)
        cell.lblCategorieName.text = categorisInfo?.classifiedList?[0].subCategoriesList![indexPath.row].categoryTitle
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedEditInfoVC") as? UBClassifiedEditInfoVC
            vc?.selectSubCategoriesList = categorisInfo?.classifiedList![0].subCategoriesList![indexPath.row]
            vc?.myClassified = myClassified
            vc?.subSubCat = categorisInfo?.classifiedList![0]
            let selectSub = myClassified?.subSubCategory
            vc?.selectsubSubCat = "\(selectSub!)"
            let catId = self.myClassified?.subCategoryID
            vc?.selectCategorieId = "\(catId!)"
        
            let selectedLastSubCategoru = categorisInfo?.classifiedList![0].subCategoriesList![indexPath.row].id
            vc?.lastSubCategorie = "\(selectedLastSubCategoru!)"
            self.navigationController?.pushViewController(vc!, animated: true)

    }
}
