//
//  UBNotificationsVC.swift
//  UniBuzz
//
//  Created by unibuss on 29/10/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SVProgressHUD
  
class UBNotificationsVC: UIViewController {
    @IBOutlet weak var notificationsLabel: UILabel!
    var userObj : Session?
    @IBOutlet weak var tableView: UITableView!
    var index = 1
    var eData: EData?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        tableView.registerCells([NotificationTableViewCell.self])
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getNotifications()
    }
    func getNotifications() {
        let serviceURL = "\(NOTIFICATIONS)\(index)"
        WebServiceManager.get(params: nil, serviceName: serviceURL, serviceType: "", modelType: Notication.self, success: { [weak self](response) in
            SVProgressHUD.dismiss()
            guard let self = self else {return}
            if let data = response as? Notication {
                self.eData = data.data
                self.notificationsLabel.text = "\(StringConstants.notifications)(\(self.eData?.unread ?? 0))"
                self.tableView.reloadData()
            }
            }, fail: { [weak self] error in
                guard let self = self else {return}
                SVProgressHUD.dismiss()
                self.showAlert(title:StringConstants.appName , message: error.localizedDescription, controller: self)
        })
        
    }
    @IBAction func markAllasReadButtonAction(_ sender: Any) {
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: MARKASREADNOTIFICATIONS, serviceType: "", modelType: ReadNotication.self, success: { [weak self](response) in
            guard let self = self else {return}
            if let data = response as? ReadNotication, let status = data.status, status {
                self.getNotifications()
            } else {
                SVProgressHUD.dismiss()
            }
            }, fail: { [weak self] error in
                guard let self = self else {return}
                SVProgressHUD.dismiss()
                self.showAlert(title:StringConstants.appName , message: error.localizedDescription, controller: self)
        })
    }
    
    @IBAction func btnSideMenu(_ sender: Any) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    
}

extension UBNotificationsVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let data = self.eData, let notifications = data.notifications?.data {
            return notifications.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: NotificationTableViewCell.self, for: indexPath)
        if let data = self.eData, let notifications = data.notifications?.data {
            cell.setUpCell(model: notifications[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return  UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = self.eData, let notifications = data.notifications?.data, let postId = notifications[indexPath.row].post_id {
            self.getFeedDetail(postId: postId)
        }
       
    }
    
    func getFeedDetail(postId: Int) {
        if Connectivity.isConnectedToInternet() {
            let serviceUrl = "\(POSTVIEW)/\(postId)"
            SVProgressHUD.show()
            WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized() , modelType: FeedsDetail.self, success: {[weak self] (response) in
                guard let self = self else {return}
                SVProgressHUD.dismiss()
                if let userFeeds = response as? FeedsDetail, let feedObject = userFeeds.feedDetail?.post {
                    DispatchQueue.main.async {
                        self.pushController(object: feedObject)
                    }
                }
            }) { (error) in
                SVProgressHUD.dismiss()
            }
        } else {
            SVProgressHUD.dismiss()
            self.showAlert(title: KMessageTitle, message: KValidationOFInternetConnection  , controller: self)
            
        }
    }
    
    func pushController(object: FeedsObject) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC {
            if let postOption = object.postOption, postOption.count != 0 {
                vc.isUserPooling = true
            } else {
                vc.isUserPooling = false
            }
            vc.feedObj = object
            vc.userObj = self.userObj
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
