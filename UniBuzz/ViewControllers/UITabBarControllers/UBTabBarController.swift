//
//  UBTabBarController.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import AlamofireObjectMapper
import ObjectMapper

class UBTabBarController: UITabBarController {
//    let layerGradient = CAGradientLayer()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var userObj : Session?
    var listOfUnread : WelcomeUnreadMessage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tabBar.items![0].selectedImage = UIImage(named:"wall_checked")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![0] ).image = UIImage(named:"waal_unchecked")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(named:"inboxS")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![1] ).image = UIImage(named:"inbox-n-selected")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![3].selectedImage = UIImage(named:"groups-selectedNew")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![3] ).image = UIImage(named:"groups-n-selected")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![4].selectedImage = UIImage(named:"jobBottomTab")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![4] ).image = UIImage(named:"jobBottomUn")!.withRenderingMode(.alwaysOriginal)
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        getUnReadMessageCount()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didMessageDisplay(_:)), name: NSNotification.Name(rawValue: "messageReciverBadgeCount"), object: nil)
        for tabBarItem in tabBar.items! {
            tabBarItem.title = ""
            tabBarItem.imageInsets = UIEdgeInsets(top : 3 , left: 0, bottom: -3, right: 0)
        }
    }

    func getUnReadMessageCount() {
        WebServiceManager.get(params: nil, serviceName: UNREADMESSAGECOUNT , serviceType: "UnreadMessage", modelType: WelcomeUnreadMessage.self, success: { [weak self] (response) in
            guard let self = self else {return}
            self.listOfUnread = (response as! WelcomeUnreadMessage)
            if self.listOfUnread?.status == true {
                self.appDelegate.badgeCount = (self.listOfUnread?.objOfUnreadMsg!.unread)!
                if self.appDelegate.badgeCount == 0 {
                    self.tabBar.items![1].badgeValue = nil
                } else {
                    self.tabBar.items![1].badgeValue = "\(self.appDelegate.badgeCount)"
                }
            } else {
            }
        }) { (error) in
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
        @objc func didMessageDisplay(_ notification: NSNotification) {
            
            let messagess = notification.object as? NSDictionary
            
            guard let message = messagess!["data"]  else {
                return
            }
            let stringObj = messagess!["data"] as? NSDictionary
            let jsonData = try? JSONSerialization.data(withJSONObject: stringObj!, options: [])
            let jsonString = String(data: jsonData!, encoding: .utf8)
            let messageObj = Mapper<AllMessages>().map(JSONString: jsonString!)
              if self.userObj?.id == messageObj?.receiver_id {
                appDelegate.badgeCount += 1
                self.tabBar.items![1].badgeValue = "\(appDelegate.badgeCount)"
            }
        }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}
