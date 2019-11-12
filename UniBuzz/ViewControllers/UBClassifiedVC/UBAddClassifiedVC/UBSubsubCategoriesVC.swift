//
//  UBSubsubCategoriesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 19/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class UBSubsubCategoriesVC: UIViewController {
    
    @IBOutlet weak var tblViewss: UITableView!
    @IBOutlet weak var lblSelectCategorie: UILabel!
    var subSubCat : CategoriesList?
    var selectCategories : Category?

    var selectCategorieId : String?
    var selectsubSubCat : String?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblSelectCategorie.text = subSubCat?.categoryTitle
       tblViewss.delegate = self
       tblViewss.dataSource = self
       tblViewss.reloadData()

        // Do any additional setup after loading the view.
    }
}

extension UBSubsubCategoriesVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return  1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subSubCat?.subCategoriesList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SubCategoriesCell.self, for: indexPath)
        cell.lblCategorieName.text = subSubCat?.subCategoriesList?[indexPath.row].categoryTitle
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  60.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc  = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedInfoAddVC") as? UBClassifiedInfoAddVC
        vc?.subSubCat = subSubCat
        vc?.selectSubCategoriesList = subSubCat?.subCategoriesList![indexPath.row]
        let lastSubCat = subSubCat?.subCategoriesList![indexPath.row].id
        vc?.lastSubCategorie = "\(lastSubCat!)"
        vc!.selectCategories = selectCategories

        vc!.selectCategorieId  = selectCategorieId
        vc!.selectsubSubCat  = selectsubSubCat
        self.navigationController?.pushViewController(vc!, animated: true)
    }
}
