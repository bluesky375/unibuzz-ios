//
//  UBBookPageVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 04/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
  
class UBBookPageVC: UIViewController {
    
    var previousVC : UIViewController?
    var showingIndex : Int = 0
    var pageVC : UIPageViewController?
    @IBOutlet var viewOfTop : UIView!
    var pageControl = UIPageControl()
    @IBOutlet weak var viewOfBookStore  : UIView!
    @IBOutlet weak var viewOfFreeBooks : UIView!
    @IBOutlet weak var viewOfMyBooks : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPager()
        
        viewOfBookStore.backgroundColor = UIColor.white
        viewOfFreeBooks.backgroundColor = UIColor.clear
        viewOfMyBooks.backgroundColor = UIColor.clear
        
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
        pageVC = storyboard?.instantiateViewController(withIdentifier: "PageViewController") as! UIPageViewController?
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
    
    @IBAction private func btnBookStore_Pressed(_ sender : UIButton) {
        viewOfBookStore.backgroundColor = UIColor.white
        viewOfFreeBooks.backgroundColor = UIColor.clear
        viewOfMyBooks.backgroundColor = UIColor.clear
        
        let startVC = viewControllerAtIndex(tempIndex: 0)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .reverse , animated: true, completion: nil)
    }
    
    @IBAction private func btnFreeBooks_Pressed(_ sender : UIButton) {
        viewOfBookStore.backgroundColor = UIColor.clear
        viewOfFreeBooks.backgroundColor = UIColor.white
        viewOfMyBooks.backgroundColor = UIColor.clear
        
        let startVC = viewControllerAtIndex(tempIndex: 1)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        
    }
    
    @IBAction private func btnMyBooks_Pressed(_ sender : UIButton) {
        viewOfBookStore.backgroundColor = UIColor.clear
        viewOfFreeBooks.backgroundColor = UIColor.clear
        viewOfMyBooks.backgroundColor = UIColor.white
        
        let startVC = viewControllerAtIndex(tempIndex: 2)
        _ = startVC.view
        pageVC?.setViewControllers([startVC], direction: .forward , animated: true, completion: nil)
        
    }
    
    
    func viewControllerAtIndex(tempIndex: Int) -> UIViewController {
        
        if tempIndex == 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBBookStoreVC" ) as! UBBookStoreVC
            showingIndex = 0
            return vc
        }
        else if tempIndex == 1 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFreeBooksVC" ) as! UBFreeBooksVC
            showingIndex = 1
            return vc
        } else {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBMyBooksVC" ) as! UBMyBooksVC
            showingIndex = 2
            return vc
            
        }
    }
    
    deinit {
        print("<<<<<<<<< UBBookPageVC delloc")
    }
}

extension UBBookPageVC : UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var currIndex: Int = 0
        if viewController is UBBookStoreVC {
            currIndex = 0
            viewOfBookStore.backgroundColor = UIColor.white
            viewOfFreeBooks.backgroundColor = UIColor.clear
            viewOfMyBooks.backgroundColor = UIColor.clear
        }
            
        else if  viewController is UBFreeBooksVC {
            currIndex = 1
            viewOfBookStore.backgroundColor = UIColor.clear
            viewOfFreeBooks.backgroundColor = UIColor.white
            viewOfMyBooks.backgroundColor = UIColor.clear
        } else if  viewController is UBMyBooksVC {
            currIndex = 2
            viewOfBookStore.backgroundColor = UIColor.clear
            viewOfFreeBooks.backgroundColor = UIColor.clear
            viewOfMyBooks.backgroundColor = UIColor.white
            
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
        if viewController is UBMyBooksVC {
            currIndex = 2
            viewOfBookStore.backgroundColor = UIColor.clear
            viewOfFreeBooks.backgroundColor = UIColor.clear
            viewOfMyBooks.backgroundColor = UIColor.white
        }
        else if viewController is UBFreeBooksVC {
            currIndex = 1
            viewOfBookStore.backgroundColor = UIColor.clear
            viewOfFreeBooks.backgroundColor = UIColor.white
            viewOfMyBooks.backgroundColor = UIColor.clear
            
        }
        else {
            currIndex = 0
            viewOfBookStore.backgroundColor = UIColor.white
            viewOfFreeBooks.backgroundColor = UIColor.clear
            viewOfMyBooks.backgroundColor = UIColor.clear
        }
        
        if currIndex == 0 || currIndex == NSNotFound {
            return nil
        }
        currIndex = currIndex - 1
        return viewControllerAtIndex(tempIndex: currIndex)
    }
}

