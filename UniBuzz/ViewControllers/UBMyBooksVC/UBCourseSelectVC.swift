//
//  UBCourseSelectVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 10/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

protocol CourseSelectDelegate : class {
    func selectedCourse(course : [CoursesList])
}

class UBCourseSelectVC: UIViewController {
    
    var courseList : [CoursesList]?
    @IBOutlet weak var tblViewss    : UITableView!
    var selectCourseList : [CoursesList]?
    public var isSelectedCourse  : [Int] = []
    weak var delegate : CourseSelectDelegate?
    
    @IBOutlet weak var searchCourse: UISearchBar!
    var searchActive : Bool = false
    var listOfFilter : [CoursesList]?
    var courseListsss   :       [UpdatedCoursesList]?

    override func viewDidLoad() {
        super.viewDidLoad()
        selectCourseList = []
//        if isSelectedCourse.count > 0 {
//
//        } else {
//            if courseListsss != nil {
//                for(_ , obj) in ((courseListsss?.enumerated())!) {
//                    selectCourseList?.append(obj.course!)
//                }
//            }

//        }
        
        
        searchCourse.delegate = self
        tblViewss.delegate = self
        tblViewss.dataSource = self
        tblViewss.reloadData()

        // Do any additional setup after loading the view.
    }
    
    @IBAction private func  btnCross_Pressed(_ sender : UIButton) {
        if searchActive == true {
            if selectCourseList!.count > 0 {
                delegate?.selectedCourse(course: selectCourseList!)
            }
            self.dismiss(animated: true) {
                
            }
        } else {
                if selectCourseList!.count > 0 {
                    delegate?.selectedCourse(course: selectCourseList!)
                } else {
                    delegate?.selectedCourse(course: selectCourseList!)

                }
            
            self.dismiss(animated: true) {
                
            }
        }
    }
    @IBAction func btnDismis_Pressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            
        }

    }
    

    
}

extension UBCourseSelectVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return courseList?.count ?? 0
        if searchActive == true {
            return self.listOfFilter?.count ?? 0
        } else {
            return courseList?.count ?? 0
        }
        

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: CourseCell.self, for: indexPath)
        
        if searchActive == true {
            cell.lblCourseName.text =  self.listOfFilter![indexPath.row].name
            
            if  isSelectedCourse.contains((self.listOfFilter![indexPath.row].id)!) {
                cell.btnRemove.isSelected = true
            } else {
                 cell.btnRemove.isSelected = false
            }
            cell.delegate = self
            cell.indexSelect = indexPath

        } else {
            if  isSelectedCourse.contains((self.courseList![indexPath.row].id)!) {
                cell.btnRemove.isSelected = true
            } else {
                cell.btnRemove.isSelected = false
            }

            cell.lblCourseName.text =  self.courseList![indexPath.row].name
            cell.delegate = self
            cell.indexSelect = indexPath

        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension UBCourseSelectVC : AddOrRemoveUserDelegate {
    func addremoveUser(cell: CourseCell, selectIndex: IndexPath) {
        let obj : CoursesList?
        if searchActive == true {
            obj = self.listOfFilter![selectIndex.row]
        } else {
            obj = courseList![selectIndex.row]
        }
        if selectCourseList!.count < 4 {
            if cell.btnRemove.isSelected == true {
                self.isSelectedCourse.append(obj!.id!)
                selectCourseList?.append(obj!)
            } else {
                if let index  = self.selectCourseList?.index(where: {$0.id == obj!.id}) {
                    self.selectCourseList?.remove(at: index)
                }
                if let removeIndex = self.isSelectedCourse.index(where: {$0 == obj!.id}) {
                    self.isSelectedCourse.remove(at: removeIndex)
                }
            }
        } else {
            cell.btnRemove.isSelected = false
            if let index  = self.selectCourseList?.index(where: {$0.id == obj!.id}) {
                self.selectCourseList?.remove(at: index)
            }
            if let removeIndex = self.isSelectedCourse.index(where: {$0 == obj!.id}) {
                self.isSelectedCourse.remove(at: removeIndex)
            }

        }


    }
    
    
}

extension UBCourseSelectVC : UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
        self.tblViewss.reloadData()
        searchBar.showsCancelButton = true

    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchCourse.showsCancelButton = true
        searchActive = true
        let filterss = self.courseList?.filter {(($0.name?.lowercased().contains(searchText.lowercased()))!) }
        self.listOfFilter  = filterss
        self.tblViewss.reloadData()
        
    }
    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        //        getAllGroupList(page: 1)
//        isSearch = false
//        //        getAllGroupList(page: 1)
//        getAllGroupList(page: 1)
//        searchBar.showsCancelButton = true
//    }

}
