//
//  UBSubCategorisListVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 16/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
  
  

class UBSubCategorisListVC: UIViewController {
    @IBOutlet weak var tblViewss: UITableView!
    
    var selectCategories : Category?
    var categorisInfo : WelcomeClassified?

    @IBOutlet weak var lblSelectCategorie: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        lblSelectCategorie.text = selectCategories?.categoryTitle
        getSubCategoriesList()
    }
    
    func getSubCategoriesList() {
        let categorieId = selectCategories?.id
        let serviceUrl = "\(SUBCATORIESVIEW)\(categorieId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Sub categories", modelType: WelcomeClassified.self, success: {[weak self] (response) in
            guard let this = self else {return}
            this.categorisInfo = (response as! WelcomeClassified)
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
  

extension UBSubCategorisListVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.categorisInfo?.subCategorieObj?.subCategories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SubCategoriesCell.self, for: indexPath)
        cell.lblCategorieName.text = self.categorisInfo?.subCategorieObj?.subCategories![indexPath.row].categoryTitle
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  45.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedCategorieBaseVC") as? UBClassifiedCategorieBaseVC
        vc?.selectCategories = self.categorisInfo?.subCategorieObj?.subCategories![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
