//
//  UBGroupSegmentVC.swift
//  UniBuzz
//
//  Created by MobikasaNight on 04/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import SJSegmentedScrollView
import SVProgressHUD

class UBGroupSegmentVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profileImage : UIImageView!
    var userObj : Session?
    fileprivate let segmentedViewController = SJSegmentedViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        guard  let image = userObj?.profile_image  else   {
            return profileImage.image = UIImage(named: "User")
        }
        
        WAShareHelper.loadImage(urlstring:image , imageView: (self.profileImage!), placeHolder: "profile2")
        let cgFloat: CGFloat = self.profileImage.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(self.profileImage, radius: CGFloat(someFloat))
        self.setupSegmentController()
        // Do any additional setup after loading the view.
    }
    
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    
    @IBAction private func btnCreateGroup_Pressed(_ sender : UIButton) {
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: COURSES, serviceType: "User Feed".localized(), modelType: GroupTypeModel.self, success: { [weak self] (response) in
            guard let self = self else {
                return
            }
            SVProgressHUD.dismiss()
            if let response = response as? GroupTypeModel {
                if response.status == true {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupCreateVC") as? UBGroupCreateVC
                    vc?.delegate = self
                    vc?.data = response.data
                    self.navigationController?.pushViewController(vc!, animated: true)
                } else {
                    self.showAlert(title: KMessageTitle, message: response.message ?? "", controller: self)
                }
            }
        }) { (error) in
            
        }
        
    }

    
    fileprivate func setupSegmentController(){
        let categories = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupListVC" ) as! UBGroupListVC
        categories.joined = "1"
        categories.title = "My Groups".localized()
        let saveNotes = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupListVC" ) as! UBGroupListVC
        saveNotes.title = "All Groups".localized()
        saveNotes.joined = "2"
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension UBGroupSegmentVC : GroupObjectDelegate  {
    func createGroup(obj : GroupList) {
        
    }
}

extension UBGroupSegmentVC: SJSegmentedViewControllerDelegate{
    func didMoveToPage(_ controller: UIViewController, segment: SJSegmentTab?, index: Int) {
        
    }
}
