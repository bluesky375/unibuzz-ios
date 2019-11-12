//
//  UBJobPageVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 14/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  
import SlideMenuControllerSwift
class UBJobPageVC: UIViewController {
    
    var previousVC : UIViewController?
    var showingIndex : Int = 0
    var pageVC : UIPageViewController?
    @IBOutlet var viewOfTop : UIView!
    var pageControl = UIPageControl()
    @IBOutlet weak var viewOfAllJobs  : UIView!
    @IBOutlet weak var viewOfApplication : UIView!
    var isAllJob : Bool?
    var isMyApplication : Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPager()
        
        isAllJob = false
        isMyApplication = true
        
        viewOfAllJobs.backgroundColor = UIColor.white
        viewOfApplication.backgroundColor = UIColor.clear
        
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
    
    
    
    @IBAction private func btnAddBook_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddBookVC") as? UBAddBookVC
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    func setPager() {
        pageVC = storyboard?.instantiateViewController(withIdentifier: "JobPageViewController") as! UIPageViewController?
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
    
    @IBAction private func btAllJob_Pressed(_ sender : UIButton) {
        viewOfAllJobs.backgroundColor = UIColor.white
        viewOfApplication.backgroundColor = UIColor.clear
        isMyApplication = true
        
        if isAllJob == true {
            isAllJob = false
            let startVC = viewControllerAtIndex(tempIndex: 0)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
            
        }
    }
    
    @IBAction private func btnApplications_Pressed(_ sender : UIButton) {
        viewOfAllJobs.backgroundColor = UIColor.clear
        viewOfApplication.backgroundColor = UIColor.white
        isAllJob = true
        
        if isMyApplication == true {
            isMyApplication = false
            let startVC = viewControllerAtIndex(tempIndex: 1)
            _ = startVC.view
            pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        }
    }
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
        
        if tempIndex == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAllJobsVC") as! UBAllJobsVC
            showingIndex = 0
            return vc
        }
        else  {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBJobApplication") as! UBJobApplication
            showingIndex = 1
            return vc
        }
    }
}

extension UBJobPageVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var currIndex: Int = 0
        if viewController is UBAllJobsVC {
            currIndex = 0
            viewOfAllJobs.backgroundColor = UIColor.white
            viewOfApplication.backgroundColor = UIColor.clear
        }
        else if  viewController is UBJobApplication {
            currIndex = 1
            viewOfAllJobs.backgroundColor = UIColor.clear
            viewOfApplication.backgroundColor = UIColor.white
        }
        
        if currIndex == NSNotFound {
            return nil
        }
        currIndex = currIndex + 1
        if currIndex == 2 {
            return nil
        }
        let vc = viewControllerAtIndex(tempIndex: currIndex)
        return vc
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var currIndex: Int = 0
        if viewController is UBJobApplication {
            currIndex = 1
            
            viewOfAllJobs.backgroundColor = UIColor.clear
            viewOfApplication.backgroundColor = UIColor.clear
        }
            
        else {
            currIndex = 0
            viewOfAllJobs.backgroundColor = UIColor.white
            viewOfApplication.backgroundColor = UIColor.clear
        }
        
        if currIndex == 0 || currIndex == NSNotFound {
            return nil
        }
        currIndex = currIndex - 1
        return viewControllerAtIndex(tempIndex: currIndex)
    }
}

