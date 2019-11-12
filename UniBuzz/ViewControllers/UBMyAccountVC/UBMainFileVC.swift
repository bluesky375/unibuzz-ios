//
//  UBMainFileVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
  
  
class UBMainFileVC: UIViewController {
    
    var previousVC: UIViewController?
    var showingIndex: Int = 0
    var pageVC: UIPageViewController?
    @IBOutlet var viewOfTop: UIView!
    var pageControl = UIPageControl()
    
    @IBOutlet weak var viewOfAccount : UIView!
    @IBOutlet weak var viewOfMyPosts : UIView!
    @IBOutlet weak var viewOfMySavedItem : UIView!
    @IBOutlet weak var viewOfFriends : UIView!
    
    
    @IBOutlet weak var imgOfUser: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblNameOfUni: UILabel!
    @IBOutlet weak var lblCollege: UILabel!
    
    var isAccount : Bool?
    var isPost : Bool?
    var isSaved : Bool?
    var isFriend : Bool?
    var isComeFromSideMenu : Bool?
    
    
    var userObj : Session?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPager()
        //        if showingIndex == 3 {
        //        } else {
        //        }
        
        self.view.bringSubviewToFront(viewOfTop)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        lblUserName.text = userObj?.full_name
        lblNameOfUni.text = userObj?.university_name
        lblCollege.text = userObj?.college_name
        guard  let image = userObj?.profile_image  else   {
            return imgOfUser.image = UIImage(named: "User")
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (self.imgOfUser!), placeHolder: "profile2")
        let cgFloat: CGFloat = self.imgOfUser.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.imgOfUser, radius: CGFloat(someFloat))
        
    }
    
    
    func setPager() {
        if showingIndex == 3 {
            self.btnFriend_Pressed()
            pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewAccount") as! UIPageViewController?
            let startVC = viewControllerAtIndex(tempIndex: 3)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
            pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
            self.addChild(pageVC!)
            self.view.addSubview((pageVC?.view)!)
            self.pageVC?.didMove(toParent: self)
            viewOfFriends.backgroundColor = UIColor.white
            viewOfMyPosts.backgroundColor = UIColor.clear
            viewOfMySavedItem.backgroundColor = UIColor.clear
            viewOfAccount.backgroundColor = UIColor.clear
            isAccount = true
            isPost = true
            isSaved = true
            isFriend = false
        } else {
            pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewAccount") as! UIPageViewController?
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
            pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
            self.addChild(pageVC!)
            self.view.addSubview((pageVC?.view)!)
            self.pageVC?.didMove(toParent: self)
            viewOfAccount.backgroundColor = UIColor.white
            viewOfMyPosts.backgroundColor = UIColor.clear
            viewOfMySavedItem.backgroundColor = UIColor.clear
            viewOfFriends.backgroundColor = UIColor.clear
            isAccount = false
            isPost = true
            isSaved = true
            isFriend = true
            
            
            
        }
    }
    
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
        
        if tempIndex == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAccountVC" ) as! UBAccountVC
            vc.index = 0
            return vc
        }else if tempIndex == 1 {
            
            //            self.pushToViewControllerWithStoryboardID(storyboardId: T##String)
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "UBFeedsVC") as! UBFeedsVC
            //            vc.isComeFromPost = true
            vc.isComeFromPost = "MY POST".localized()
            
            vc.index = 1
            return vc
        }
        else if tempIndex == 2 {
            let storyboard = UIStoryboard.init(name: "Home", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "UBFeedsVC" ) as! UBFeedsVC
            vc.isComeFromPost = "SAVED".localized()
            vc.index = 2
            return vc
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFreindsVC" ) as! UBFreindsVC
            vc.index = 3
            return vc
        }
    }
    
    @IBAction func btnAccount_Pressed(_ sender: UIButton) {
        
        //        var isAccount : Bool?
        //        var isPost : Bool?
        //        var isSaved : Bool?
        //        var isFriend : Bool?
        
        
        isPost = true
        isSaved = true
        isFriend = true
        
        if isAccount == true {
            isAccount = false
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
        viewOfAccount.backgroundColor = UIColor.white
        viewOfMyPosts.backgroundColor = UIColor.clear
        viewOfMySavedItem.backgroundColor = UIColor.clear
        viewOfFriends.backgroundColor = UIColor.clear
        
        
    }
    
    @IBAction func btnMyPost_Pressed(_ sender: UIButton) {
        
        isAccount = true
        isSaved = true
        isFriend = true
        
        if isPost == true {
            isPost = false
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
        
        viewOfAccount.backgroundColor = UIColor.clear
        viewOfMyPosts.backgroundColor = UIColor.white
        viewOfMySavedItem.backgroundColor = UIColor.clear
        viewOfFriends.backgroundColor = UIColor.clear
        
        
    }
    
    @IBAction func btnMySavedItem_Pressed(_ sender: UIButton) {
        
        isAccount = true
        isPost = true
        isFriend = true
        
        if isSaved == true {
            isSaved = false
            let startVC = viewControllerAtIndex(tempIndex: 2)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
        viewOfAccount.backgroundColor = UIColor.clear
        viewOfMyPosts.backgroundColor = UIColor.clear
        viewOfMySavedItem.backgroundColor = UIColor.white
        viewOfFriends.backgroundColor = UIColor.clear
        
    }
    
    @IBAction func btnFriend_Pressed() {
        viewOfAccount.backgroundColor = UIColor.clear
        viewOfMyPosts.backgroundColor = UIColor.clear
        viewOfMySavedItem.backgroundColor = UIColor.clear
        viewOfFriends.backgroundColor = UIColor.white
        
        isAccount = true
        isPost = true
        isSaved = true
        
        if isFriend == true {
            isFriend = false
            let startVC = viewControllerAtIndex(tempIndex: 3)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
        
        //        let startVC = viewControllerAtIndex(tempIndex: 3)
        //        _ = startVC.view
        //        pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        
    }
    
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    
    @IBAction private func btnSetting_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSettingVC") as? UBSettingVC
        self.navigationController?.pushViewController(vc! , animated: true)
        //        self.pushToViewControllerWithStoryboardID(storyboardId: "UBSettingVC")
    }
    
    deinit {
        print("<<<<<<<<< UBMainFileVC delloc")
    }
    
}

//extension UBMainFileVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
//
////    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
////        var currIndex: Int = 0
////        if viewController is UBAccountVC {
////            currIndex = 0
//////            self.pageControl.currentPage = 0
////
////        }  else if  viewController is UBMyPostVC {
////            currIndex = 1
//////            self.pageControl.currentPage = 1
////        } else if  viewController is UBSavedItemsVC {
////            currIndex = 2
////        }else if  viewController is UBFreindsVC {
////            currIndex = 3
////        }
////
////        if currIndex == NSNotFound {
////            return nil
////        }
////        currIndex = currIndex + 1
////        if currIndex == 4 {
////            return nil
////        }
////
////        let vc = viewControllerAtIndex(tempIndex: currIndex)
////        return vc
////
////    }
////
////    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
////
////        var currIndex: Int = 0
////        if viewController is UBFreindsVC {
////            currIndex = 3
////
////        }
////        else  if viewController is UBSavedItemsVC {
////            currIndex = 2
////
////        }else if viewController is UBMyPostVC {
////            currIndex = 1
////
////        }
////        else {
////            currIndex = 0
////
////        }
////        if currIndex == 0 || currIndex == NSNotFound {
////            return nil
////        }
////        currIndex = currIndex - 1
////        return viewControllerAtIndex(tempIndex: currIndex)
////    }
//}
//
