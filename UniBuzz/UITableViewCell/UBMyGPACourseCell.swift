//
//  UBMyGPACourseCell.swift
//  UniBuzz
//
//  Created by Asim Khan on 8/8/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

protocol UBMyGPACourseCellDelegate:class {
    func deleteCell(at indexPath: IndexPath, sender: AnyObject, course: Course?)
    func selectCredits(at indexPath: IndexPath)
    func selectGrades(at indexPath: IndexPath, with: UITextField)
}

class UBMyGPACourseCell: UITableViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var coursesTxtField              : UITextField!
    @IBOutlet weak var gradesTxtField               : UITextField!
    @IBOutlet weak var creditsTxtField              : UITextField!
    @IBOutlet weak var deleteButton                 : UIButton!
    @IBOutlet weak var deleteButtonWidthConstraint  : NSLayoutConstraint!
    @IBOutlet weak var deleteButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteImageView              : UIImageView!

    //MARK:- Variables
    weak var delegate   :  UBMyGPACourseCellDelegate?
    var course          :  Course?
    var indexPath       :  IndexPath?
    var currentGPA      : UITextField?
    var lastSemesterCH  : UITextField?
    
    //MARK:- Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.coursesTxtField.text   = ""
        self.gradesTxtField.text    = ""
        self.creditsTxtField.text   = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func cellDataSource(at indexPath: IndexPath, course: Course? = nil, universityGPA: [GPAUniversityGpa]? = nil, currentGPA: UITextField? = nil, lastSemesterCH: UITextField? = nil) {
        
        self.indexPath = indexPath
        self.course = course
        self.currentGPA = currentGPA
        self.lastSemesterCH = lastSemesterCH
        
        self.coursesTxtField.text   = ""
        self.gradesTxtField.text    = ""
        self.creditsTxtField.text   = ""
        
        if indexPath.row == 0 {
            self.deleteButtonWidthConstraint.constant   = 0
            self.deleteButtonLeadingConstraint.constant = 0
            self.deleteImageView.isHidden               = true
            self.deleteButton.isHidden                  = true
        }else {
            self.deleteImageView.isHidden               = false
            self.deleteButton.isHidden                  = false
        }
        
        if let course = course {
            self.coursesTxtField.text = course.course!
            let obj = universityGPA!.filter{$0.id == course.grade!}
            self.gradesTxtField.text = obj.first!.grade!
            self.creditsTxtField.text = course.creditHour!
        }
    }

    @IBAction func deleteButtonAction(_ sender: AnyObject) {
//        if Connectivity.isConnectedToInternet() {
            if self.course != nil {
                if self.indexPath != nil {
                    self.delegate?.deleteCell(at: self.indexPath!, sender: sender, course: self.course)
                }
            }
            
//        } else {
//             let alertController = UIAlertController(title: KMessageTitle , message: KValidationOFInternetConnection, preferredStyle: UIAlertController.Style.alert)
//             alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//             }))
//             alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
//             }))
//               UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
//        }
    }
}

extension UBMyGPACourseCell: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.creditsTxtField {
            self.delegate?.selectCredits(at: self.indexPath!)
        }else if textField == self.gradesTxtField {
            self.gradesTxtField.resignFirstResponder()
            self.delegate?.selectGrades(at: self.indexPath!, with: self.gradesTxtField)
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.gradesTxtField {
            self.creditsTxtField.resignFirstResponder()
            self.coursesTxtField.resignFirstResponder()
            guard let lastSemis = self.lastSemesterCH else {
                return false
            }
            self.lastSemesterCH!.resignFirstResponder()
            guard let textField = self.currentGPA  else {
                return false
            }
            self.currentGPA!.resignFirstResponder()

        }
        
        return true
    }
}
