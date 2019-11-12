//
//  UBMyCourseVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 31/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SlideMenuControllerSwift
  
class UBMyCourseVC: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    @IBOutlet weak var viewOFCurrent : UILabel!
    @IBOutlet weak var viewOFPrevious : UILabel!
    
    var listOfMyCourse : CourseObject?
    var isCurrentOrPreviousCourse : Bool?
    var isComeFromScreen : Bool?
    
    @IBOutlet weak var btnBAck: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCurrentOrPreviousCourse = false
        viewOFPrevious.isHidden = true
        viewOFCurrent.isHidden = false
        tblViewss.registerCells([
            CurrentCourseCell.self  ,  PreviousCourseCell.self
        ])
        getAllCourseList()
        
        if isComeFromScreen == true {
            btnBAck.setImage(UIImage(named: "menu"), for: .normal)
        } else {
            btnBAck.setImage(UIImage(named: "arrow"), for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    func getAllCourseList() {
        WebServiceManager.get(params: nil, serviceName: MYCOURSE, serviceType: "Group List".localized(), modelType: CourseObject.self, success: {[weak self] (response) in
            guard let this = self else {
                return
            }
            self!.listOfMyCourse = (response as! CourseObject)
            if self!.listOfMyCourse?.status == true {
                self!.tblViewss.delegate = self
                self!.tblViewss.dataSource = self
                self!.tblViewss.reloadData()
                //                self!.refreshControl.endRefreshing()
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfMyCourse?.message!)!, controller: self)
            }
        }) { (error) in
        }
        
    }
    
    @IBAction private func btnCurrentCourse_Pressed(_ sender : UIButton) {
        isCurrentOrPreviousCourse = false
        viewOFPrevious.isHidden = true
        viewOFCurrent.isHidden = false
        tblViewss.reloadData()
        
    }
    
    @IBAction private func btnPreviousCourse_Pressed(_ sender : UIButton) {
        isCurrentOrPreviousCourse = true
        viewOFPrevious.isHidden = false
        viewOFCurrent.isHidden = true
        tblViewss.reloadData()
        
    }
    
    func deleteCourse(courseId : Int)  {
        
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(MYCOURSEDESTROY)\(courseId)"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "Delete course".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
        
    }
    
    @IBAction private func btnSideMenu_Pressed(_ sender : UIButton) {
        if isComeFromScreen == true {
            if AppDelegate.isArabic() {
                self.slideMenuController()?.openRight()
            } else {
                self.slideMenuController()?.openLeft()
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction private func btnAddCurrentCourse_Pressed(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddCurrentCourseVC") as? UBAddCurrentCourseVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
}

extension UBMyCourseVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        
        if  self.listOfMyCourse?.courseList?.currentCourse?.previousCourse!.isEmpty == false || self.listOfMyCourse?.courseList?.currentCourse?.currentCourse!.isEmpty == false  {
            numOfSections = 1
            tblViewss.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Course   in your List.".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tblViewss.backgroundView = noDataLabel
            tblViewss.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isCurrentOrPreviousCourse == true {
            return  self.listOfMyCourse?.courseList?.previousCourse?.previousCourse?.count ?? 0
        } else {
            return   self.listOfMyCourse?.courseList?.currentCourse?.currentCourse?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isCurrentOrPreviousCourse == true {
            let cell = tableView.dequeueReusableCell(with: PreviousCourseCell.self, for: indexPath)
            cell.lblCourseName.text = self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].my_course_name
            cell.lblCourseCode.text = self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].course_code
            cell.lblProfessorName.text = self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].professor_name
            cell.lblLocation.text = self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].location
            let year =  self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].year
            let semister =  self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].semester
            cell.lblSemister.text = "\(year!)/\(semister!)"
            cell.delegate = self
            cell.selectIndex = indexPath
            cell.lblGrade.text = self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![indexPath.row].grade_name
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: CurrentCourseCell.self, for: indexPath)
            cell.lblCourseName.text = self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![indexPath.row].my_course_name
            cell.lblCourseCode.text = self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![indexPath.row].course_code
            cell.lblProfessorName.text = self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![indexPath.row].professor_name
            cell.delegate = self
            cell.selectIndex = indexPath
            
            cell.lblLocation.text = self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![indexPath.row].location
            let year =  self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![indexPath.row].year
            let semister =  self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![indexPath.row].semester
            cell.lblSemister.text = "\(year!)/\(semister!)"
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isCurrentOrPreviousCourse == true {
            return 180.0
        } else {
            return 144.0
        }
    }
}

extension UBMyCourseVC : DeleteOrEditPreviousCoruse {
    func deleteOrEditPreviousCourse(cell : PreviousCourseCell , isIndex : IndexPath) {
        let courseId = self.listOfMyCourse?.courseList?.previousCourse?.previousCourse![isIndex.row].id
        //        ActionSheetStringPicker.show(withTitle: "", rows: ["Edit" , "Delete" ] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
        //            if index == 0 {
        //            } else if index == 1 {
        //                self!.deleteCourse(courseId: courseId!)
        //                if let index  =   self!.listOfMyCourse?.courseList?.currentCourse?.previousCourse?.index(where: {$0.id == courseId}) {
        //                    self!.listOfMyCourse?.courseList?.currentCourse?.previousCourse?.remove(at: index)
        //                    self!.tblViewss.reloadData()
        //                    }
        //            }
        //            return
        //            }, cancel: { (actionStrin ) in
        //
        //        }, origin: cell.btnMoreBtnClick)
        
        //        deleteCourse(courseId: courseId!)
        //        if let index  =   self.listOfMyCourse?.courseList?.currentCourse?.previousCourse?.index(where: {$0.id == courseId}) {
        //            self.listOfMyCourse?.courseList?.currentCourse?.previousCourse?.remove(at: index)
        //            self.tblViewss.reloadData()
        //        }
        
        
    }
    
}

extension UBMyCourseVC : DeleteOrEditCurrentCoruse {
    
    func deleteOrEditCurrentCourse(cell : CurrentCourseCell , isIndex : IndexPath) {
        let courseId = self.listOfMyCourse?.courseList?.currentCourse?.currentCourse![isIndex.row].id
        
        //        ActionSheetStringPicker.show(withTitle: "", rows: ["Edit" , "Delete" ] , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value)  in
        //            if index == 0 {
        //
        //            } else if index == 1 {
        //                self!.deleteCourse(courseId: courseId!)
        //
        //                if let index  =   self!.listOfMyCourse?.courseList?.currentCourse?.currentCourse?.index(where: {$0.id == courseId}) {
        //                    self!.listOfMyCourse?.courseList?.currentCourse?.currentCourse?.remove(at: index)
        //                    self!.tblViewss.reloadData()
        //                }
        //
        //            }
        //            return
        //            }, cancel: { (actionStrin ) in
        //
        //        }, origin: cell.btnMoreBtnClick)
        
        //        if let index  = self.listOfMyCourse?.courseList?.currentCourse?.currentCourse(where: {$0 == courseId}) {
        //            self.listOfMyCourse?.courseList?.currentCourse?.currentCourse.remove(at: index)
        //        }
        //        let indexPath = IndexPath(item: selectIndex.row , section: 0)
        //        self.tblViewss.reloadRows(at: [indexPath], with: .none)
        
        
    }
    
}
