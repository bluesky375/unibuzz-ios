//
//  UBSettingVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
class UBSettingVC: UIViewController {
    
    @IBOutlet weak var tblViewss: UITableView!
    private var settingItem: [MenuSettingStruct] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerNib = UINib.init(nibName: "PrivacySettingHeaderCell", bundle: Bundle.main)
        tblViewss.register(headerNib, forHeaderFooterViewReuseIdentifier: "PrivacySettingHeaderCell")
        
        let items: [MenuSettingStruct] = [
            MenuSettingStruct(title: "My Profile".localized() ),
            MenuSettingStruct(title: "My CV".localized() ),
            MenuSettingStruct(title: "My GPA".localized() ),
            MenuSettingStruct(title: "Contact Details".localized() ),
            MenuSettingStruct(title: "My Groups".localized() ),
            MenuSettingStruct(title: "My Notes".localized() ),
            MenuSettingStruct(title: "My Courses".localized() ) ,
            MenuSettingStruct(title: "My Classifieds".localized()) ,
            MenuSettingStruct(title: "My Events".localized() )
        ]
        settingItem = items

        tblViewss.registerCells([
            SettingCell.self
            ])

        // Do any additional setup after loading the view.
    }
    

}

extension UBSettingVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        //        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "PrivacySettingHeaderCell") as! PrivacySettingHeaderCell
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 135.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingItem.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SettingCell.self, for: indexPath)
        
        if indexPath.row % 2 == 0 {
            cell.viewOfBack.backgroundColor = UIColor(red: 246/255.0, green: 248/255.0, blue: 251/255.0, alpha: 1.0)
        } else {
            cell.viewOfBack.backgroundColor = UIColor.white
        }
            cell.lblProfile.text = settingItem[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35.0

    }
}
