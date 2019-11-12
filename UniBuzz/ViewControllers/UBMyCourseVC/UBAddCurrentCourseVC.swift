//
//  UBAddCurrentCourseVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
  
class UBAddCurrentCourseVC: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    private var itemsOfTime: [MenuItemStruct] = []
    private var itemOfWeekly: [CourseCreate] = []
    var courseInfo : GradesProfessorObject?
    var numberOfRows = 1
    var numberOfSection : Int?
    var isSelectCourseFine : Bool?
    @IBOutlet var txtLocation: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isSelectCourseFine = false
        itemsOfTime = [
            MenuItemStruct(title: "8:00 AM".localized() ),
            MenuItemStruct(title: "8:15 AM".localized() ),
            MenuItemStruct(title: "8:30 AM".localized()),
            MenuItemStruct(title: "8:45 AM".localized()),
            MenuItemStruct(title: "9:00 AM".localized()),
            MenuItemStruct(title: "9:15 AM".localized()),
            MenuItemStruct(title: "9:30 AM".localized()),
            MenuItemStruct(title: "9:45 AM".localized()),
            MenuItemStruct(title: "10:00 AM".localized()),
            MenuItemStruct(title: "10:15 AM".localized()),
            MenuItemStruct(title: "10:30 AM".localized()),
            MenuItemStruct(title: "10:45 AM".localized()),
            MenuItemStruct(title: "11:00 AM".localized()),
            MenuItemStruct(title: "11:15 AM".localized()),
            MenuItemStruct(title: "11:30 AM".localized()),
            MenuItemStruct(title: "11:45 AM".localized()),
            MenuItemStruct(title: "12:00 PM".localized()),
            MenuItemStruct(title: "12:15 PM".localized()),
            MenuItemStruct(title: "12:30 PM".localized()),
            MenuItemStruct(title: "12:45 PM".localized()),
            MenuItemStruct(title: "1:00 PM".localized()),
            MenuItemStruct(title: "1:15 PM".localized()),
            MenuItemStruct(title: "1:30 PM".localized()),
            MenuItemStruct(title: "1:45 PM".localized()),
            MenuItemStruct(title: "2:00 PM".localized()),
            MenuItemStruct(title: "2:15 PM".localized()),
            MenuItemStruct(title: "2:30 PM".localized()),
            MenuItemStruct(title: "2:45 PM".localized()),
            MenuItemStruct(title: "3:00 PM".localized()),
            MenuItemStruct(title: "3:15 PM".localized()),
            MenuItemStruct(title: "3:30 PM".localized()),
            MenuItemStruct(title: "3:45 PM".localized()),
            MenuItemStruct(title: "4:00 PM".localized()),
        ]
        
//        itemsOfTime = items

        numberOfSection = 3
        tblViewss.registerCells([
            CurrentCourseHeaderCell.self  ,  CourseAddCell.self ,  ChoseWeekDaysCell.self , ADDCourseCELL.self
            ])

        getAllMyCourseInfo()
    }
    
    
    func getAllMyCourseInfo() {
        
        let createCourse = "\(MYCOURSECREATE)cr"
        WebServiceManager.get(params: nil, serviceName: createCourse, serviceType: "Course Create".localized(), modelType: GradesProfessorObject.self, success: {[weak self] (response) in
            guard let this = self else {
                    return
                }
            this.courseInfo = (response as! GradesProfessorObject)
            if this.courseInfo?.status == true {
                self!.tblViewss.delegate = self
                self!.tblViewss.dataSource = self
                self!.tblViewss.reloadData()
            }
            else {
                this.showAlert(title: KMessageTitle, message: (this.courseInfo?.message!)!, controller: self)
            }
        }) { (error) in
      }
    }
}

extension UBAddCurrentCourseVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSection!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSelectCourseFine == true {
            if section == 0 {
                return 1
            } else if section == 1 {
                 return 1
            }
            else  if section == 2 {
                return numberOfRows
            } else {
                return 1
            }
        } else {
            if section == 0 {
                return 1
            } else  if section == 1 {
                return numberOfRows
            } else {
                return 1
            }
        }
       
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        if isSelectCourseFine == true {
            if indexPath.section  == 0 {
                let cell = tableView.dequeueReusableCell(with: CurrentCourseHeaderCell.self, for: indexPath)
                cell.delegate = self
                cell.indexSelect = indexPath
                cell.selectSect = indexPath.section
                txtLocation = cell.txtLocation
                cell.txtLocation.delegate = self

                return cell
            }
              
            else if indexPath.section == 1  {
                let cell = tableView.dequeueReusableCell(with: CourseAddCell.self, for: indexPath)
                return cell
                
            }
                
            else if indexPath.section == 2  {
                let cell = tableView.dequeueReusableCell(with: ChoseWeekDaysCell.self, for: indexPath)
                if indexPath.row == 0 {
                    cell.btnCross.isHidden = true
                } else {
                    cell.btnCross.isHidden = false
                }
                cell.delegate = self
                cell.indexSelect = indexPath
                cell.selectSect = indexPath.section
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(with: ADDCourseCELL.self, for: indexPath)
                cell.delegate = self
                cell.indexSelect = indexPath
                cell.selectSect = indexPath.section
                
                return cell
                
                
            }

        } else {
        
        if indexPath.section  == 0 {
            let cell = tableView.dequeueReusableCell(with: CurrentCourseHeaderCell.self, for: indexPath)
              cell.delegate = self
              cell.indexSelect = indexPath
              cell.selectSect = indexPath.section
            return cell
        }
          
            
        else if indexPath.section == 1  {
            let cell = tableView.dequeueReusableCell(with: ChoseWeekDaysCell.self, for: indexPath)
            if indexPath.row == 0 {
                cell.btnCross.isHidden = true
            } else {
                 cell.btnCross.isHidden = false
            }
            cell.delegate = self
            cell.indexSelect = indexPath
            cell.selectSect = indexPath.section
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(with: ADDCourseCELL.self, for: indexPath)
            cell.delegate = self
            cell.indexSelect = indexPath
            cell.selectSect = indexPath.section

            return cell

            
        }
    
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isSelectCourseFine == true {
            if indexPath.section == 0 {
                return 255.0
            }  else if indexPath.section == 1 {
                return 116.0
            }
            else if indexPath.section == 2 {
                return 40.0
            } else {
                return 130.0
            }

        } else {
            if indexPath.section == 0 {
                return 255.0
            } else if indexPath.section == 1 {
                return 40.0
            } else {
                return 130.0
            }

        }
    }
    
}

extension UBAddCurrentCourseVC : CurrentCourseDelegate {
   
    func selectCourse(cell: CurrentCourseHeaderCell, index: IndexPath, section: Int) {
        var allCourse = [String]()
        for (_ , info) in (courseInfo?.courseList?.courses?.enumerated())! {
            allCourse.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Course".localized(), rows: allCourse , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            let category = self?.courseInfo?.courseList?.courses![index]
          
            cell.btnselectCourse.setTitle(category?.name, for: .normal)
            return
        }, cancel: { (actionStrin ) in
        }, origin: cell.btnselectCourse)
    }
    
    func selectProfessor(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int) {
        var professorList = [String]()
        for (_ , info) in (courseInfo?.courseList?.professor?.enumerated())! {
            professorList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Professor".localized(), rows: professorList , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            let category = self?.courseInfo?.courseList?.professor![index]
            cell.btnSelectProfessor.setTitle(category?.name, for: .normal)
            return
            }, cancel: { (actionStrin ) in
        }, origin: cell.btnSelectProfessor)
    }
    
    
    func selectYear(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int) {
        
        ActionSheetStringPicker.show(withTitle: "Select Year".localized(), rows: ["2019".localized()]  , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            cell.btnselectYear.setTitle(value as? String, for: .normal)
            return
            }, cancel: { (actionStrin ) in
        }, origin: cell.btnselectYear)

    }
   
    func selectSemister(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int) {
        var semisterList = [String]()
        for (_ , info) in (courseInfo?.courseList?.semesters?.enumerated())! {
            semisterList.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Semister".localized(), rows: semisterList , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            let category = self?.courseInfo?.courseList?.semesters![index]
            cell.btnSelectSemister.setTitle(category?.name, for: .normal)
            return
            }, cancel: { (actionStrin ) in
        }, origin: cell.btnSelectSemister)
    }
  
    func selectCouldNotFindLoc(cell : CurrentCourseHeaderCell , index : IndexPath , section : Int) {
        if cell.btnCourse.isSelected == true {
            self.numberOfSection = 4
            isSelectCourseFine = true
            tblViewss.reloadData()
            
        } else {
            self.numberOfSection = 3
            isSelectCourseFine = false

            tblViewss.reloadData()
        }
       
    }
    
    
    
    
    
}

extension UBAddCurrentCourseVC : WeekDaysDelegate {
    func timeToSelect(cell: ChoseWeekDaysCell, indexS : IndexPath, section: Int) {
//        var allTime = [String]()
        
        var allTime = [String]()
        for (_ , info) in (itemsOfTime.enumerated()) {
            allTime.append(info.title)
        }
        ActionSheetStringPicker.show(withTitle: "Select Time".localized(), rows: allTime , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            let category = self!.itemsOfTime[index].title
            cell.btnselectTimeTo.setTitle(category, for: .normal)
            return
            }, cancel: { (actionStrin ) in
        }, origin: cell.btnselectTimeTo)
    }
    
    func daySelect(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int) {
        var allWeekDay = [String]()
        for (_ , info) in (courseInfo?.courseList?.weekdays?.enumerated())! {
            allWeekDay.append(info.name!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Week Day".localized(), rows: allWeekDay , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            let category = self?.courseInfo?.courseList?.weekdays![index]
            cell.btnselectDay.setTitle(category?.name, for: .normal)
        
            self?.itemOfWeekly[indexS.row] = CourseCreate(id: category!.id!  , start_time: cell.btnselectTimeTo.titleLabel?.text ?? " "  , end_time: cell.btnselectTimeFrom.titleLabel?.text ?? " ")

//            var weeklyId : Int?
//            if cell.btnselectDay.titleLabel?.text == "Saturday" {
//                weeklyId = 1
//            } else if cell.btnselectDay.titleLabel?.text == "Sunday" {
//                weeklyId = 2
//            } else if cell.btnselectDay.titleLabel?.text == "Monday" {
//                weeklyId = 3
//            } else if cell.btnselectDay.titleLabel?.text == "Tuesday" {
//                weeklyId = 4
//            } else if cell.btnselectDay.titleLabel?.text == "Wednesday" {
//                weeklyId = 5
//            } else if cell.btnselectDay.titleLabel?.text == "Thursday" {
//                weeklyId = 6
//            } else if cell.btnselectDay.titleLabel?.text == "Friday" {
//                weeklyId = 7
//            } else {
//                weeklyId = 0
//            }
           
            return
            }, cancel: { (actionStrin ) in
        }, origin: cell.btnselectDay)
    }
    
    func timeFromOrToSelect(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int) {
     
        var allTime = [String]()
        for (_ , info) in (itemsOfTime.enumerated()) {
            allTime.append(info.title)
        }
        ActionSheetStringPicker.show(withTitle: "Select Time".localized(), rows: allTime , initialSelection: 0 , doneBlock: { [weak self]   (picker, index, value) in
            let category = self!.itemsOfTime[index].title
            cell.btnselectTimeFrom.setTitle(category, for: .normal)
            return
            }, cancel: { (actionStrin ) in
        }, origin: cell.btnselectTimeFrom)
    }
    func deleteCell(cell : ChoseWeekDaysCell , indexS : IndexPath , section : Int) {
        if numberOfRows < 7 {
            numberOfRows -= 1
            self.tblViewss.deleteRows(at: [indexS], with: .none)
            tblViewss.reloadData()
            
        }
    }
}

extension  UBAddCurrentCourseVC : AddCellDelegate {
    func addCellDelegate(cell : ADDCourseCELL  , indexSelect : IndexPath , sec : Int) {
        if numberOfRows < 7 {
            numberOfRows += 1
            tblViewss.reloadData()
            
        }
    }
}



extension UBAddCurrentCourseVC : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        isNumberOfSeatSelect = textField.text
        print("DidBegin \(textField.text!)")
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("DidEnd \(textField.text!)")
//        isNumberOfSeatSelect = textField.text
        
        
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("shouldBEgin \(textField.text!)")
//        isNumberOfSeatSelect = textField.text
        
        
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("shouldClear \(textField.text!)")
//        isNumberOfSeatSelect = textField.text
        
        
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("shouldEndEditing \(textField.text!)")
//        isNumberOfSeatSelect = textField.text
        
        
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print("Range Character \(textField.text!)")
//        isNumberOfSeatSelect = textField.text
        
        
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Text Field Should Return \(textField.text!)")
//        isNumberOfSeatSelect = textField.text
        
        textField.resignFirstResponder();
        return true;
    }
    
}
