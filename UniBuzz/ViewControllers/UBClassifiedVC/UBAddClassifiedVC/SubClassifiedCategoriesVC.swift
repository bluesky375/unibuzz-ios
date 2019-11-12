//
//  SubClassifiedCategoriesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 19/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
  
    
class SubClassifiedCategoriesVC: UIViewController {
    var selectCategories : Category?
    var categorisInfo : CreateClassified?
    @IBOutlet weak var tblViewss: UITableView!
    @IBOutlet weak var lblSelectCategorie: UILabel!
    var selectCategorieId : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        lblSelectCategorie.text = selectCategories?.categoryTitle
        getSubCategoriesList()
    }

    func getSubCategoriesList() {
        SVProgressHUD.show()
        let categorieId = selectCategories?.id
        let serviceUrl = "\(CLASSIFIEDFORM)\(categorieId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Sub categories".localized(), modelType: CreateClassified.self, success: {[weak self] (response) in
            guard let this = self else {return}
            SVProgressHUD.dismiss()
            
            this.categorisInfo = (response as! CreateClassified)
            if this.categorisInfo?.status == true {
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
            } else {
                self?.showAlert(title: KMessageTitle, message: this.categorisInfo!.message! , controller: self)
            }
        }) { (error) in
        }
    }
}

extension SubClassifiedCategoriesVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categorisInfo?.classifiedList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SubCategoriesCell.self, for: indexPath)
        cell.lblCategorieName.text = categorisInfo?.classifiedList?[indexPath.row].categoryTitle
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (categorisInfo?.classifiedList?[indexPath.row].subCategoriesList!.count)! > 0 {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "UBSubsubCategoriesVC") as? UBSubsubCategoriesVC
            vc?.subSubCat = categorisInfo?.classifiedList?[indexPath.row]
            vc!.selectCategories = selectCategories
            let selectSub = categorisInfo?.classifiedList?[indexPath.row].id
            vc?.selectsubSubCat = "\(selectSub!)"
            vc?.selectCategorieId = selectCategorieId
            self.navigationController?.pushViewController(vc!, animated: true)

        } else {
            let vc  = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedInfoAddVC") as? UBClassifiedInfoAddVC
            vc?.subSubCat = categorisInfo?.classifiedList?[indexPath.row]
            let selectSub = categorisInfo?.classifiedList?[indexPath.row].id
            vc!.selectCategories = selectCategories
            vc?.selectsubSubCat = "\(selectSub!)"
            vc?.selectCategorieId = selectCategorieId
            self.navigationController?.pushViewController(vc!, animated: true)

        }
    }
}
