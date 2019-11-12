//
//  UBNotesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SJSegmentedScrollView
  
class UBNotesVC: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var previousVC : UIViewController?
    var showingIndex : Int = 0
    var pageVC : UIPageViewController?
    @IBOutlet var viewOfTop : UIView!
    fileprivate let segmentedViewController = SJSegmentedViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSegmentController()
        
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
    
    @IBAction private func btnAddNote_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddNoteVC") as? UBAddNoteVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    fileprivate func setupSegmentController(){
        let categories = self.storyboard?.instantiateViewController(withIdentifier: "UBCategoriesVC" ) as! UBCategoriesVC
        categories.title = "Categories".localized()
        let saveNotes = self.storyboard?.instantiateViewController(withIdentifier: "UBMyNotesVC" ) as! UBMyNotesVC
        saveNotes.title = "Save Notes".localized()
        segmentedViewController.segmentedScrollViewColor = UIColor.init(red: 71, green: 92, blue: 179)
        segmentedViewController.segmentBounces = false
        segmentedViewController.selectedSegmentViewHeight = 3
        segmentedViewController.segmentControllers = [categories, saveNotes]
        segmentedViewController.segmentTitleColor = .white
        segmentedViewController.segmentSelectedTitleColor = .white
        segmentedViewController.selectedSegmentViewColor = .white
        segmentedViewController.delegate = self
        // segmentedViewController.segmentTitleFont = AppFonts.segmentTitleFont
        segmentedViewController.view.backgroundColor = .clear
        self.addChild(segmentedViewController)
        self.containerView.addSubview(segmentedViewController.view)
        segmentedViewController.view.frame = containerView.bounds
        segmentedViewController.didMove(toParent: self)
        segmentedViewController.segmentBackgroundColor = .clear
    }
    
    deinit {
        print("<<<<<<<<< UBNotesVC delloc")
    }
    
}

extension UBNotesVC: SJSegmentedViewControllerDelegate{
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        /*
         if let colorCode = menus[index].colorCode {
         let color =  UIColor.init(hexString: colorCode)
         self.view.backgroundColor = color
         segmentedViewController.segmentBackgroundColor = color
         }
         */
    }
}

