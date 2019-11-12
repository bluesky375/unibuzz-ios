//
//  UBGroupAdminVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 07/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
class UBGroupAdminVC: UIViewController {
    var index: Int?
    @IBOutlet weak var tblViewss: UITableView!
    var groupObj : GroupList?
    var userFriend : AllMember?

    override func viewDidLoad() {
        super.viewDidLoad()
                
        getAllMemberOfGroup()
        // Do any additional setup after loading the view.
    }
    
    func getAllMemberOfGroup() {
        let groupId = groupObj?.id
        let serviceUrl = "\(FRIENDLISTOFGROUP)\(groupId!)/index"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: AllMember.self, success: { (response) in
            self.userFriend = (response as! AllMember)
            if self.userFriend?.status == true {
                //                self.refreshControl.stopAnimating()
            } else {
                self.showAlert(title: KMessageTitle, message: (self.userFriend?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }


}
