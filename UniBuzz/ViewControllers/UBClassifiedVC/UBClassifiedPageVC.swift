//
//  UBClassifiedPageVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 17/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
  
class UBClassifiedPageVC: UIViewController {
    var previousVC : UIViewController?
    var showingIndex : Int = 0
    var pageVC : UIPageViewController?
    @IBOutlet var viewOfTop : UIView!
    var pageControl = UIPageControl()
    @IBOutlet weak var viewOfAllClassified  : UIView!
    @IBOutlet weak var viewOfMyClassified : UIView!
    @IBOutlet weak var viewOfMySavedItem : UIView!
    
    var isAllClassified : Bool?
    var isMyClassified : Bool?
    var isSavedClassified : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPager()
        
        isAllClassified = false
        isMyClassified = true
        isSavedClassified = true
        viewOfAllClassified.backgroundColor = UIColor.white
        viewOfMyClassified.backgroundColor = UIColor.clear
        viewOfMySavedItem.backgroundColor = UIColor.clear
        
        self.view.bringSubviewToFront(viewOfTop)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @IBAction private func btnSideMenu_Pressed(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    
    func setPager() {
        pageVC = storyboard?.instantiateViewController(withIdentifier: "ClassifiedPageViewController") as! UIPageViewController?
        pageVC?.dataSource = self
        pageVC?.delegate = self
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .forward, animated: true, completion: nil)
        pageVC?.view.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEGHT)
        self.addChild(pageVC!)
        self.view.addSubview((pageVC?.view)!)
        self.pageVC?.didMove(toParent: self)
    }
    
    @IBAction private func btAllClassified_Pressed(_ sender : UIButton) {
        viewOfAllClassified.backgroundColor = UIColor.white
        viewOfMyClassified.backgroundColor = UIColor.clear
        viewOfMySavedItem.backgroundColor = UIColor.clear
        
        isMyClassified = true
        isSavedClassified = true
        
        if isAllClassified == true {
            isAllClassified = false
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            
        }
    }
    @IBAction private func btnMyClassified_Pressed(_ sender : UIButton) {
        viewOfAllClassified.backgroundColor = UIColor.clear
        viewOfMyClassified.backgroundColor = UIColor.white
        viewOfMySavedItem.backgroundColor = UIColor.clear
        isAllClassified = true
        isSavedClassified = true
        if isMyClassified == true {
            isMyClassified = false
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
    }
    @IBAction private func btnSavedClassified_Pressed(_ sender : UIButton) {
        viewOfAllClassified.backgroundColor = UIColor.clear
        viewOfMyClassified.backgroundColor = UIColor.clear
        viewOfMySavedItem.backgroundColor = UIColor.white
        isAllClassified = true
        isMyClassified = true
        if isSavedClassified == true {
            isSavedClassified = false
            let startVC = viewControllerAtIndex(tempIndex: 2)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
    }
    
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
        
        if tempIndex == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBClassifiedListVC") as! UBClassifiedListVC
            showingIndex = 0
            return vc
        }
        else if tempIndex == 1  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBMyClassifiedVC") as! UBMyClassifiedVC
            showingIndex = 1
            return vc
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBSavedClassifiedVC") as! UBSavedClassifiedVC
            showingIndex = 2
            return vc
        }
    }
    deinit {
        print("<<<<<<<<< UBClassifiedPageVC delloc")
    }
    
}
  

extension UBClassifiedPageVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var currIndex: Int = 0
        if viewController is UBClassifiedListVC {
            currIndex = 0
            viewOfAllClassified.backgroundColor = UIColor.white
            viewOfMyClassified.backgroundColor = UIColor.clear
            viewOfMySavedItem.backgroundColor = UIColor.clear
            //            self.pageControl.currentPage = 0
            
        }
        else if  viewController is UBMyClassifiedVC {
            currIndex = 1
            viewOfAllClassified.backgroundColor = UIColor.clear
            viewOfMyClassified.backgroundColor = UIColor.white
            viewOfMySavedItem.backgroundColor = UIColor.clear
            
            self.pageControl.currentPage = 1
        }
        else if  viewController is UBSavedClassifiedVC {
            currIndex = 2
            self.pageControl.currentPage = 2
            viewOfAllClassified.backgroundColor = UIColor.clear
            viewOfMyClassified.backgroundColor = UIColor.clear
            viewOfMySavedItem.backgroundColor = UIColor.white
        }
        if currIndex == NSNotFound {
            return nil
        }
        currIndex = currIndex + 1
        if currIndex == 3 {
            return nil
        }
        let vc = viewControllerAtIndex(tempIndex: currIndex)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var currIndex: Int = 0
        if viewController is UBSavedClassifiedVC {
            currIndex = 2
            viewOfAllClassified.backgroundColor = UIColor.clear
            viewOfMyClassified.backgroundColor = UIColor.clear
            viewOfMySavedItem.backgroundColor = UIColor.white
        }
        else if viewController is UBMyClassifiedVC {
            currIndex = 1
            viewOfAllClassified.backgroundColor = UIColor.clear
            viewOfMyClassified.backgroundColor = UIColor.white
            viewOfMySavedItem.backgroundColor = UIColor.clear
        }
        else {
            currIndex = 0
            viewOfAllClassified.backgroundColor = UIColor.white
            viewOfMyClassified.backgroundColor = UIColor.clear
            viewOfMySavedItem.backgroundColor = UIColor.clear
        }
        if currIndex == 0 || currIndex == NSNotFound {
            return nil
        }
        currIndex = currIndex - 1
        return viewControllerAtIndex(tempIndex: currIndex)
    }
}
