//
//  UBCreateGroupVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 25/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  


class UBCreateGroupVC: UIViewController   {
    @IBOutlet weak var tblViewss: UITableView!
    var userFriend : UserResponse?
    
    var friendList : [FriendList]?
    private var isSelectedFriend  : [Int] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    
    var listOfFilter : [FriendList]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendList = []
        getALlFriendList()
        // Do any additional setup after loading the view.
    }
    

    func getALlFriendList() {
        WebServiceManager.get(params: nil, serviceName: FRIENDLIST, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
            self.userFriend = (response as! UserResponse)
            if self.userFriend?.status == true {
//                self.numberOfPage = self.userFeeds?.feeds?.post?.last_page
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.reloadData()
//                self.refreshControl.endRefreshing()
                //                self.refreshControl.stopAnimating()
            } else {
                self.showAlert(title: KMessageTitle, message: (self.userFriend?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.friendList = []
        self.isSelectedFriend = []
        self.tblViewss.reloadData()
        
    }
    
    @IBAction private func btnNext(_ sender : UIButton) {
        if self.friendList?.isEmpty == false {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupSelectorVC") as? UBGroupSelectorVC
            vc?.friendList = self.friendList
            self.navigationController?.pushViewController(vc!, animated: true)
        } else {
            self.showAlert(title: KMessageTitle, message: "Please select the friend".localized(), controller: self)
        }
        
    }

    

}

extension UBCreateGroupVC : UITableViewDelegate , UITableViewDataSource {
   
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if searchActive {
            if  self.listOfFilter!.isEmpty == false {
                numOfSections = 1
                tblViewss.backgroundView = nil
            }
            else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Friend  in your List.".localized()
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = .center
                tblViewss.backgroundView = noDataLabel
                tblViewss.separatorStyle = .none
            }

        } else {
            if  self.userFriend?.friendObject?.friendList!.isEmpty == false {
                numOfSections = 1
                tblViewss.backgroundView = nil
            }
            else {
                let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
                noDataLabel.numberOfLines = 10
                if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                    noDataLabel.font = aSize
                }
                noDataLabel.text = "There are currently no Friend  in your List.".localized()
                noDataLabel.textColor = UIColor.lightGray
                noDataLabel.textAlignment = .center
                tblViewss.backgroundView = noDataLabel
                tblViewss.separatorStyle = .none
            }

        }

        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == true {
            return self.listOfFilter?.count ?? 0
        } else {
             return self.userFriend?.friendObject?.friendList?.count ?? 0
        }
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(with: GroupCell.self, for: indexPath)
        
        if searchActive == true {
            cell.lblName.text = self.listOfFilter![indexPath.row].friendProfile?.full_name
            if isSelectedFriend.contains((self.listOfFilter![indexPath.row].id)!) {
                cell.btnSelect.isSelected = true
            } else {
                cell.btnSelect.isSelected = false
            }
            cell.delegate = self
            cell.selectIndex = indexPath
            if self.listOfFilter![indexPath.row].friendProfile?.uni_name != nil {
                cell.lblGroupName.text = self.listOfFilter![indexPath.row].friendProfile?.uni_name
            } else {
                cell.lblGroupName.text = ""
            }
            guard  let image = self.listOfFilter![indexPath.row].friendProfile?.profile_image  else   {
                return cell
            }
            cell.imgofUser.setImage(with: image, placeholder: UIImage(named: "profile2"))
            let cgFloat: CGFloat = cell.imgofUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgofUser, radius: CGFloat(someFloat))

        } else {
            cell.lblName.text = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.full_name
            if isSelectedFriend.contains((self.userFriend?.friendObject?.friendList![indexPath.row].id)!) {
                cell.btnSelect.isSelected = true
            } else {
                cell.btnSelect.isSelected = false
            }
            cell.delegate = self
            cell.selectIndex = indexPath
            if self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.uni_name != nil {
                cell.lblGroupName.text = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.uni_name
            } else {
                cell.lblGroupName.text = ""
            }
            guard  let image = self.userFriend?.friendObject?.friendList![indexPath.row].friendProfile?.profile_image  else   {
                return cell
            }
            cell.imgofUser.setImage(with: image, placeholder: UIImage(named: "profile2"))
            let cgFloat: CGFloat = cell.imgofUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgofUser, radius: CGFloat(someFloat))

        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 87.0
    }
}

extension UBCreateGroupVC : selectFriendFromListDelegate {
    func selectFriend(cell : GroupCell , indexSelect : IndexPath) {
        let obj : FriendList?
        if searchActive == true {
            obj = self.listOfFilter![indexSelect.row]
        } else {
           obj = self.userFriend?.friendObject?.friendList![indexSelect.row]
        }
        if cell.btnSelect.isSelected == true {
            self.isSelectedFriend.append(obj!.id!)
            friendList?.append(obj!)
        } else {
            if let index  = self.friendList?.index(where: {$0.id == obj?.id}) {
                    self.friendList?.remove(at: index)
            }
            if let removeIndex = self.isSelectedFriend.index(where: {$0 == obj?.id}) {
                self.isSelectedFriend.remove(at: removeIndex)
            }
        }
    }
    
    func friendProfile(cell: GroupCell, indexSelect: IndexPath) {
        
    }

}

extension UBCreateGroupVC : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
        self.tblViewss.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchBar.showsCancelButton = true
        searchActive = true
        let filterss = self.userFriend?.friendObject?.friendList?.filter {(($0.friendProfile?.full_name?.lowercased().contains(searchText.lowercased()))!) }
        self.listOfFilter  = filterss
        self.tblViewss.reloadData()
        
    }
}
