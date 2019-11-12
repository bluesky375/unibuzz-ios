//
//  UBSideMenuVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
////  Copyright © 2019 unibuss. All rights reserved.


import UIKit
import SCLAlertView
import SlideMenuControllerSwift
  
import HSPopupMenu
import LanguageManager_iOS
  

class UBSideMenuVC: UIViewController , ExpandableHeaderViewDelegate {
    @IBOutlet weak var tblViewss: UITableView!
    var userObj : Session?
    @IBOutlet weak var profileImage : UIImageView!
    weak var userFeeds : UserResponse?
    @IBOutlet weak var lblName: UILabel!
    //    @IBOutlet weak var lblVersion: UILabel!
    
    var sections = [
        Section(genre: "Wall".localized(), icon: "side-ub" ,  subMenu: [], expanded: true) ,
        Section(genre: "Chat".localized() , icon: "inboxS"  , subMenu: [], expanded: true) ,
        Section(genre: "Groups".localized() , icon: "groups-selectedNew"  , subMenu: [], expanded: true) ,
        Section(genre: "My Account".localized(), icon: "ic_my_account" ,  subMenu: ["My GPA".localized(), "My CV".localized() , "My Friends".localized()], expanded: true) ,
        Section(genre: "Solutions".localized() , icon: "solution"  , subMenu: [], expanded: true) ,
        Section(genre: "Notes".localized() , icon: "ic_notes"  , subMenu: [], expanded: true) ,
        Section(genre: "Books".localized(), icon: "ic_books" ,  subMenu: [], expanded: true) ,
        Section(genre: "Classifieds".localized(), icon: "ic_classifides" , subMenu: [], expanded: true) ,
        Section(genre: "Jobs".localized(), icon: "jobBottomTab" , subMenu: [], expanded: true) ,
        Section(genre: "Log out".localized(), icon: "ic_logout" , subMenu: [], expanded: true) ,
        Section(genre: "V".localized(), icon: "" , subMenu: [], expanded: true)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        //       let appVersion =
        //        print(appVersion!)
        let headerNib = UINib.init(nibName: "DemoHeaderView", bundle: Bundle.main)
        tblViewss.register(headerNib, forHeaderFooterViewReuseIdentifier: "ExpandableHeaderView")
        tblViewss.registerCells([
            SideMenuCell.self
        ])
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func languageChangeButtonAction(_ sender: UIButton) {
        let menu1 = HSMenu(icon: nil, title: "English")
        let menu2 = HSMenu(icon: nil, title: "عربى")
        let x: CGFloat = AppDelegate.isArabic() ? UIScreen.main.bounds.width - 270 : 0
        let popupMenu = HSPopupMenu(menuArray: [menu1, menu2], arrowPoint: CGPoint(x: sender.center.x + x, y: sender.center.y + 30), arrowPosition: (LanguageManager.shared.currentLanguage == .ar ? HSPopupMenuArrowPosition.left : HSPopupMenuArrowPosition.right))
        popupMenu.delegate = self
        popupMenu.popUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        lblName.text = userObj?.full_name
        
        guard  let image = userObj?.profile_image  else   {
            return profileImage.image = UIImage(named: "User")
        }
        
        WAShareHelper.loadImage(urlstring:image , imageView: (self.profileImage!), placeHolder: "profile2")
        let cgFloat: CGFloat = self.profileImage.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.profileImage, radius: CGFloat(someFloat))
    }
    
    @objc func firstButton() {
        WebServiceManager.get(params: nil, serviceName: LOGOUT , serviceType: "Log Out".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let self = self else {return}
            let userResponse = (response as? UserResponse)
            if userResponse?.status == true {
                self.slideMenuController()?.leftViewController = nil
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                Persistence(with: .user).delete()
                UIApplication.shared.keyWindow?.rootViewController = vc
            } else {
                self.showAlert(title: KMessageTitle, message: self.userFeeds?.message ?? "Authehnticate", controller: self)
            }
        }) { (error) in
            
        }
    }
    
    @objc func secondButton() {
        
    }
    deinit {
        print("<<<<<<<<<<  UBSideMenuVC dealloc")
    }
    
}
  

extension UBSideMenuVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].subMenu.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (sections[indexPath.section].expanded) {
            return 45.0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ExpandableHeaderView") as! ExpandableHeaderView
        if section == 10 {
            let versionControl =  "V : \(APPVERSION)"
            header.customInit(title: versionControl  , section: section, image: "", handler: { [weak self] (header, section) in
                guard let self = self else {return}
                self.toggleSection(header: header, section: section)
            })
        } else {
            header.customInit(title: sections[section].genre, section: section, image: sections[section].icon, handler: { [weak self] (header, section) in
                guard let self = self else {return}
                self.toggleSection(header: header, section: section)
            })
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: SideMenuCell.self, for: indexPath)
        cell.lblName.text = sections[indexPath.section].subMenu[indexPath.row]
        return cell
    }
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if section == 0 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                    tabBar.selectedIndex = 0
                } else {
                    mainViewController.popToRootViewController(animated: false)
                    if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                        tabBar.selectedIndex = 0
                    }
                }
            }
        }
        if section == 1 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                    tabBar.selectedIndex = 1
                } else {
                    mainViewController.popToRootViewController(animated: false)
                    if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                        tabBar.selectedIndex = 1
                    }
                }
            }
        }
        
        if section == 2 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                    tabBar.selectedIndex = 3
                } else {
                    mainViewController.popToRootViewController(animated: false)
                    if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                        tabBar.selectedIndex = 3
                    }
                }
            }
        }
        if section == 3 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBMainFileVC) {
                    let controller = WAShareHelper.getViewController(from: "Account", with: "UBMainFileVC")
                    mainViewController.pushViewController(controller, animated: true)
                }
            }
        }
        
        if section == 4 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBSolutionsViewController) {
                    let controller = WAShareHelper.getViewController(from: "Solution", with: "UBSolutionsViewController")
                    mainViewController.pushViewController(controller, animated: true)
                }
            }
        }
        
        if section == 5 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBNotesVC) {
                    let controller = WAShareHelper.getViewController(from: "Home", with: "UBNotesVC")
                    mainViewController.pushViewController(controller, animated: true)
                }
            }
        }
        
        if section == 6 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBBookPageVC) {
                    let controller = WAShareHelper.getViewController(from: "Book", with: "UBBookPageVC")
                    mainViewController.pushViewController(controller, animated: true)
                }
            }
        }
        if section == 8 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                    tabBar.selectedIndex = 4
                } else {
                    mainViewController.popToRootViewController(animated: false)
                    if let tabBar = mainViewController.viewControllers.last as? UITabBarController  {
                        tabBar.selectedIndex = 4
                    }
                }
            }
        }
        if section == 7 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBClassifiedPageVC) {
                    let controller = WAShareHelper.getViewController(from: "Classified", with: "UBClassifiedPageVC")
                    mainViewController.pushViewController(controller, animated: true)
                }
            }
        }
        
        if section == 9 {
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
                showCloseButton: false,
                dynamicAnimatorActive: true,
                buttonsLayout: .horizontal
            )
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("YES".localized(), target: self, selector:#selector(UBSideMenuVC.firstButton))
            _ = alert.addButton("NO".localized(), target : self, selector:#selector(UBSideMenuVC.secondButton))
            //            let icon = UIImage(named:"userSelect")
            let color = UIColor(red: 55/255.0, green: 69/255.0, blue: 163/255.0, alpha: 1.0)
            
            let icon = UIImage(named:"wall_checked")
            _ = alert.showCustom("UniBuzz", subTitle: ("Are you sure to Logout" as? String)!.localized(), color: color, icon: icon!, circleIconImage: icon!)
        }
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()
        return
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if indexPath.section == 3  && indexPath.row == 0 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBMyGPAVC) {
                    let controller = WAShareHelper.getViewController(from: "Account", with: "UBMyGPAVC") as! UBMyGPAVC
                    controller.fromMenu = true
                    mainViewController.pushViewController(controller, animated: true)
                }
                
            }
        }
        else if indexPath.section == 3 && indexPath.row  == 1 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBMyCVVC) {
                    let controller = WAShareHelper.getViewController(from: "Account", with: "UBMyCVVC") as! UBMyCVVC
                    mainViewController.pushViewController(controller, animated: true)
                }
                
            }
        }
            
        else if indexPath.section == 3 && indexPath.row  == 2 {
            if let tab = appDelegate.window?.rootViewController as? SlideMenuController, let mainViewController = tab.mainViewController as? UINavigationController {
                if !(mainViewController.topViewController is UBMainFileVC) {
                    let controller = WAShareHelper.getViewController(from: "Account", with: "UBMainFileVC") as! UBMainFileVC
                    controller.showingIndex = 3
                    mainViewController.pushViewController(controller, animated: true)
                }
            }
        }
        self.slideMenuController()?.closeLeft()
        self.slideMenuController()?.closeRight()
    }
    
    
}

  
extension UBSideMenuVC: HSPopupMenuDelegate {
    func popupMenu(_ popupMenu: HSPopupMenu, didSelectAt index: Int) {
        //MMLocalization.start()
       // let _ =  MMLocalization.loadSetting()
        if index == 0 {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            //UserDefaults.standard.set("en", forKey: "AppleLanguages")
        } else {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            //UserDefaults.standard.set("ar", forKey: "AppleLanguages")
        }
        
        UserDefaults.standard.synchronize()
        let selectedLanguage: Languages = index == 0 ? .en : .ar
        let mainStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let homeVC = WAShareHelper.getViewController(from: "Home", with: VCIdentifier.KTABBARCONTROLLER)
        let menuVC = mainStoryboard.instantiateViewController(withIdentifier: "UBSideMenuVC")
        let homeNavigation = UINavigationController(rootViewController: homeVC)
        var slideMenuController: SlideMenuController!
        if selectedLanguage == .ar {
            slideMenuController = SlideMenuController(mainViewController: homeNavigation, rightMenuViewController: menuVC)
        } else {
            slideMenuController = SlideMenuController(mainViewController: homeNavigation, leftMenuViewController: menuVC)
        }
        
        LanguageManager.shared.setLanguage(language: selectedLanguage, rootViewController: slideMenuController, animation: { view in
            // do custom animation
            view.transform = CGAffineTransform(scaleX: 2, y: 2)
            view.alpha = 0
        })
        
    }
//
//    func localizeddString(forKey key: String, value: String?, table tableName: String?) -> String {
//        let bundle: Bundle = .main
//        if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"), let bundle = Bundle(path: path) {
//            return bundle?.localizedString(forKey: key, value: value, table: tableName) ?? ""
//        } else {
//            return super.localizedString(forKey: key, value: value, table: tableName)
//        }
//    }
//
    
}
