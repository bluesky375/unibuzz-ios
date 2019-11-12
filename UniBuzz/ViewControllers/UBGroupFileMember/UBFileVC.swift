//
//  UBFileVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol DisableActionDelegate : class {
    func disAble()
}
class UBFileVC: UIViewController {
    
    @IBOutlet weak var tblViewss: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    var index: Int?
    var groupObj : GroupList?
    var userFeeds : UserResponse?
    weak var delegate : DisableActionDelegate?
    
    @IBOutlet weak var searchVw: UIView!
    var selectText : String?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.isSelectFile = false
        
        selectText = "There are currently no file in your list.".localized()
        tblViewss.registerCells([
            FileCell.self
        ])
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        SVProgressHUD.show()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllFileOfGroup()
    }
    
     @objc private func refreshWithData(_ sender: Any) {
        getAllFileOfGroup()
    }
    
    func getAllFileOfGroup() {
        
        if groupObj?.is_member == false && groupObj?.is_private_group == false {
            self.delegate?.disAble()
            SVProgressHUD.dismiss()
            self.searchVw.isHidden = true
            selectText = "No access.".localized()
            tblViewss.delegate = self
            tblViewss.dataSource = self
            refreshControl.endRefreshing()
            tblViewss.reloadData()
            return
            
        } else if groupObj?.is_private_group == true && groupObj?.is_member == false && groupObj?.is_my_group == false {
            SVProgressHUD.dismiss()
            self.delegate?.disAble()
            self.searchVw.isHidden = true
            tblViewss.delegate = self
            tblViewss.dataSource = self
            refreshControl.endRefreshing()
            selectText = "No access.".localized()
            tblViewss.reloadData()
            return
        }
        else {
            
            let groupId = groupObj?.id
            let serviceUrl = "\(FILEVIEW)\(groupId!)/index"
            WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
                //            guard let this = self else {return}
                guard let self = self else {
                    return
                }
                
                self.userFeeds = (response as! UserResponse)
                self.refreshControl.endRefreshing()
                SVProgressHUD.dismiss()
                
                if self.userFeeds?.status == true {
                    self.tblViewss.delegate = self
                    self.tblViewss.dataSource = self
                    self.tblViewss.reloadData()
                    self.delegate?.disAble()
                    self.appDelegate.isSelectFile = true
                } else {
                    self.showAlert(title: KMessageTitle, message: (self.userFeeds?.message!)!, controller: self)
                    self.delegate?.disAble()
                    
                }
            }) { (error) in
                
            }
            
        }
    }
    
    @IBAction func btnAddFileAction(){
        SVProgressHUD.show()
        let serviceUrl = "\(FILECREATE)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: FileModel.self, success: {[weak self] (response) in
            guard let self = self else { return }
            SVProgressHUD.dismiss()
            if let response = response as? FileModel {
                if response.status == true {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddFileViewController") as! UBAddFileViewController
                    vc.groupObj = self.groupObj
                    vc.data = response.data
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    self.showAlert(title: KMessageTitle, message: response.message ?? "", controller: self)
                }
            }
        }) { (error) in
            
        }
        
    }
    
    
}

extension UBFileVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  self.userFeeds?.groupFile?.fileList?.isEmpty == false {
            numOfSections = 1
            tblViewss.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            
            noDataLabel.text = selectText
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tblViewss.backgroundView = noDataLabel
            tblViewss.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFeeds?.groupFile?.fileList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: FileCell.self, for: indexPath)
        cell.lblTitle.text = self.userFeeds?.groupFile?.fileList![indexPath.row].titleOfFile
        let type = self.userFeeds?.groupFile?.fileList?[indexPath.row].note_type_name
        let language = self.userFeeds?.groupFile?.fileList?[indexPath.row].language
        cell.lblType.text = "Type :".localized() + " \(type ?? "")"
        cell.lblLanguage.text = "Language :".localized() + " \(language ?? "")"
        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBViewFileVC") as! UBViewFileVC
        vc.data = self.userFeeds?.groupFile?.fileList![indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
