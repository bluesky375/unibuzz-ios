//
//  UBMyGPAVC.swift
//  UniBuzz
//
//  Created by Asim Khan on 8/8/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0
import IQKeyboardManagerSwift
import SlideMenuControllerSwift
  
class UBMyGPAVC: UIViewController {
    
    //MARK:- IBOutlets
    @IBOutlet weak var roundedProgress: RoundProgressBar!
    @IBOutlet weak var gpaLabel: UILabel!
    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var currentGPA: UITextField!
    @IBOutlet weak var lastSemesterCH: UITextField!
    @IBOutlet weak var courseTableView: UITableView!
    @IBOutlet weak var addCourseButton: UIButton!
    @IBOutlet weak var semesterGPALabel: UILabel!
    @IBOutlet weak var overallCGPALabel: UILabel!
    @IBOutlet weak var courseTableViewHeightConstraint: NSLayoutConstraint!
    
    //MARK:- Variables
    var fromMenu = false
    var courseTableViewHeight = CGFloat(45)
    
    var numberOfCells = 1
    
    var myGPA : MyGPA?
    
    var selectedGPAUniversityGpa: GPAUniversityGpa?
    var user: Session?
    var gpaJson = [String: Any]()
    let userLoader = UserLoader()
    
    //MARK:- Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentGPA.keyboardType = .decimalPad
        //        textfield.keyboardType =
        //        UIKeyboardType.DecimalPad
        self.view.isUserInteractionEnabled = true
        
        let persistance = Persistence(with: .user)
        self.user = persistance.load()
        
        roundedProgress.progressBarTintColor = .lightGray
        roundedProgress.progressBarProgressColor = .black
        
        roundedProgress.currentValue = 0
        
        self.overallCGPALabel.text = "Overall CGPA 0".localized()
        self.semesterGPALabel.text = "Semester GPA 0".localized()
        
        self.menuButton.isHidden = !fromMenu
        self.backButton.isHidden = fromMenu
        
        self.setupTableView()
        
        self.performAPICall()
        self.setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction private func btnSideMenu(_ sender : UIButton) {
        if AppDelegate.isArabic() {
            self.slideMenuController()?.openRight()
        } else {
            self.slideMenuController()?.openLeft()
        }
    }
    deinit {
        print("<<<<<<<<< UBMyGPAVC delloc")
    }
}

extension UBMyGPAVC {
    
    private func getGPA() -> String {
        
        var totalCreditHours = 0.0
        var totalGrades = 0.0
        var coursesMultiple = 0.0
        for i in 0..<self.numberOfCells {
            let cell = self.courseTableView.cellForRow(at: IndexPath(row : i , section: 0)) as! UBMyGPACourseCell
            if !cell.coursesTxtField.text!.isEmpty &&
                !cell.creditsTxtField.text!.isEmpty &&
                !cell.gradesTxtField.text!.isEmpty {
                let gradeList       = self.myGPA!.data!.universityGpa!.filter{$0.grade! == cell.gradesTxtField.text!}
                let gradeObj        = gradeList.first
                totalGrades         = totalGrades + Double(gradeObj!.gradeValue!)!
                totalCreditHours    = totalCreditHours + Double(cell.creditsTxtField.text!)!
                coursesMultiple     = coursesMultiple + (Double(gradeObj!.gradeValue!)! * Double(cell.creditsTxtField.text!)!)
            }
        }
        
        let gpa = coursesMultiple / totalCreditHours
        print(gpa)
        return String(Double(round(100*gpa)/100))
    }
    
    private func setupTableView() {
        self.courseTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func setupView() {
        if let myGPA = self.myGPA {
            if myGPA.data?.overallGpa == nil {
            }  else {
                if myGPA.data!.overallGpa! != "0" {
                    self.currentGPA.text = myGPA.data!.currentGpa ?? "0".localized()
                }
            }
            if myGPA.data?.creditHour == nil {
            } else {
                if myGPA.data!.creditHour! != "0" {
                    self.lastSemesterCH.text = myGPA.data!.creditHour ?? "0".localized()
                }
            }
            self.gpaLabel.text = myGPA.data!.overallGpa ??  " "
            self.roundedProgress.currentValue = Double(myGPA.data!.overallGpa!)! / 4.0
            if myGPA.data!.gpa!.count > 0 {
                self.numberOfCells = myGPA.data!.gpa!.count
                self.courseTableViewHeightConstraint.constant = courseTableViewHeight * CGFloat(self.numberOfCells)
            }
            self.courseTableView.reloadData()
            self.overallCGPALabel.text = "Overall CGPA ".localized() + myGPA.data!.overallGpa!
            //            self.semesterGPALabel.text = "Semester GPA " + self.getGPA()
            self.semesterGPALabel.text = "Semester GPA ".localized() + myGPA.data!.semesterGpa!
        }
    }
    
    private func calculateShowGPA() {
        var totalCreditHours    = 0.0
        var totalGrades         = 0.0
        var coursesMultiple     = 0.0
        var currentGPA          = 0.0
        var lastSemesterCH      = 0.0
        
        var gpas = [[String: Any]]()
        
        if let chText = self.lastSemesterCH.text, let validValue = Double(chText), validValue <= 0 {
            self.showAlert(title: "Oops".localized(), message: "Please enter valid Credit Hours.".localized(), controller: self)
            return
        }
        
        if !self.currentGPA.text!.isEmpty {
            currentGPA           = Double(self.currentGPA.text!)!
        }
        
        if !self.lastSemesterCH.text!.isEmpty {
            lastSemesterCH      = Double(self.lastSemesterCH.text!)!
        }
        
        let multiple            = currentGPA*lastSemesterCH
        let newSemesterGPA      = multiple / lastSemesterCH
        
        for i in 0..<self.numberOfCells {
            let cell = self.courseTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! UBMyGPACourseCell
            
            if
                !cell.creditsTxtField.text!.isEmpty &&
                    !cell.gradesTxtField.text!.isEmpty {
                
                let gradeList       = self.myGPA!.data!.universityGpa!.filter{$0.grade! == cell.gradesTxtField.text!}
                let gradeObj        = gradeList.first
                totalGrades         = totalGrades + Double(gradeObj!.gradeValue!)!
                totalCreditHours    = totalCreditHours + Double(cell.creditsTxtField.text!)!
                coursesMultiple     = coursesMultiple + (Double(gradeObj!.gradeValue!)! * Double(cell.creditsTxtField.text!)!)
                
                //            gpas.append(["course":cell.coursesTxtField.text! as AnyObject,
                //                         "credit_hour":Double(cell.creditsTxtField.text!) as AnyObject,
                //                         "grade":gradeObj!.id! as AnyObject])
            }
        }
        
        let sumOfTotals = multiple + coursesMultiple
        let totalCH     = totalCreditHours + lastSemesterCH
        let cGPA        = sumOfTotals / totalCH
        let newCGA      = Double(round(100*cGPA)/100)
        self.roundedProgress.currentValue = newCGA / 4.0
        let c = self.currentGPA.text! as Any
        print(c)
        gpaJson["user_id"] = self.user!.id! as Any
        gpaJson["current_gpa"] = c
        gpaJson["credit_hour"] = lastSemesterCH as Any
        gpaJson["gpa"] = gpas as Any
        
        if newCGA.isNaN == true  {
            self.gpaLabel.text = "0.0"
        } else {
            self.gpaLabel.text = String(newCGA)
        }
        self.overallCGPALabel.text = "Overall CGPA ".localized() + String(newCGA)
        let semesterGPA = coursesMultiple / totalCreditHours
        self.semesterGPALabel.text = "Semester GPA ".localized() + String(Double(round(100*semesterGPA)/100))
        
    }
    private func calculateAndShowGPA() {
        var totalCreditHours    = 0.0
        var totalGrades         = 0.0
        var coursesMultiple     = 0.0
        var currentGPA          = 0.0
        var lastSemesterCH      = 0.0
        
        var gpas = [[String: Any]]()
        
        if let chText = self.lastSemesterCH.text, let validValue = Double(chText), validValue <= 0 {
            self.showAlert(title: "Oops".localized(), message: "Please enter valid Credit Hours.".localized(), controller: self)
            return
        }
        
        if !self.currentGPA.text!.isEmpty {
            currentGPA           = Double(self.currentGPA.text!)!
        }
        
        if !self.lastSemesterCH.text!.isEmpty {
            lastSemesterCH      = Double(self.lastSemesterCH.text!)!
        }
        
        let multiple            = currentGPA*lastSemesterCH
        let newSemesterGPA      = multiple / lastSemesterCH
        
        for i in 0..<self.numberOfCells {
            let cell = self.courseTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! UBMyGPACourseCell
            
            if !cell.coursesTxtField.text!.isEmpty &&
                !cell.creditsTxtField.text!.isEmpty &&
                !cell.gradesTxtField.text!.isEmpty {
                
                let gradeList       = self.myGPA!.data!.universityGpa!.filter{$0.grade! == cell.gradesTxtField.text!}
                let gradeObj        = gradeList.first
                totalGrades         = totalGrades + Double(gradeObj!.gradeValue!)!
                totalCreditHours    = totalCreditHours + Double(cell.creditsTxtField.text!)!
                coursesMultiple     = coursesMultiple + (Double(gradeObj!.gradeValue!)! * Double(cell.creditsTxtField.text!)!)
                
                gpas.append(["course":cell.coursesTxtField.text! as AnyObject,
                             "credit_hour":Double(cell.creditsTxtField.text!) as AnyObject,
                             "grade":gradeObj!.id! as AnyObject])
            }
        }
        
        let sumOfTotals = multiple + coursesMultiple
        let totalCH     = totalCreditHours + lastSemesterCH
        let cGPA        = sumOfTotals / totalCH
        let newCGA      = Double(round(100*cGPA)/100)
        self.roundedProgress.currentValue = newCGA / 4.0
        let c = self.currentGPA.text! as Any
        print(c)
        gpaJson["user_id"] = self.user!.id! as Any
        gpaJson["current_gpa"] = c
        gpaJson["credit_hour"] = lastSemesterCH as Any
        gpaJson["gpa"] = gpas as Any
        
        if newCGA.isNaN == true  {
            self.gpaLabel.text = "0.0"
        } else {
            self.gpaLabel.text = String(newCGA)
        }
        self.overallCGPALabel.text = "Overall CGPA ".localized() + String(newCGA)
        let semesterGPA = coursesMultiple / totalCreditHours
        self.semesterGPALabel.text = "Semester GPA ".localized() + String(Double(round(100*semesterGPA)/100))
    }
}

extension UBMyGPAVC {
    @IBAction func addCourseAction() {
        if self.numberOfCells < 12 {
            self.courseTableViewHeightConstraint.constant = self.courseTableViewHeightConstraint.constant + courseTableViewHeight + 5
            self.numberOfCells = self.numberOfCells + 1
            let indexPath = IndexPath(row: numberOfCells - 1, section: 0)
            
            self.courseTableView.beginUpdates()
            self.courseTableView.insertRows(at: [indexPath], with: .automatic)
            self.courseTableView.endUpdates()
            
            if self.numberOfCells == 12 {
                self.addCourseButton.isHidden = true
            }else {
                self.addCourseButton.isHidden = false
            }
        }
    }
    
    @IBAction func calculateAction() {
        //        self.calculateAndShowGPA()
        calculateShowGPA()
    }
    
    @IBAction func saveAction() {
        self.calculateAndShowGPA()
        self.updateGPA()
    }
}

extension UBMyGPAVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberOfCells
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UBMyGPACourseCell.self), for: indexPath) as! UBMyGPACourseCell
        cell.delegate = self
        if let myGPA = self.myGPA {
            if myGPA.data!.gpa!.count < self.numberOfCells {
                cell.cellDataSource(at: indexPath, currentGPA: self.currentGPA, lastSemesterCH: self.lastSemesterCH)
                return cell
            }
            cell.cellDataSource(at: indexPath, course: myGPA.data!.gpa![indexPath.row], universityGPA: myGPA.data!.universityGpa!, currentGPA: self.currentGPA, lastSemesterCH: self.lastSemesterCH)
        }
        return cell
    }
}

extension UBMyGPAVC: UBMyGPACourseCellDelegate {
    
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        if textField == self.currentGPA {
    //            self.lastSemesterCH.resignFirstResponder()
    //        }else if textField == self.lastSemesterCH {
    //            self.currentGPA.resignFirstResponder()
    //        }
    //
    //        return true
    //    }
    
    func selectCredits(at indexPath: IndexPath) {
        
    }
    
    func deleteCell(at indexPath: IndexPath, sender: AnyObject, course: Course?) {
        let hitPoint = sender.convert(CGPoint.zero, to: self.courseTableView)
        if let indexPath = self.courseTableView.indexPathForRow(at: hitPoint) {
            self.courseTableViewHeightConstraint.constant = self.courseTableViewHeightConstraint.constant - courseTableViewHeight
            self.numberOfCells = self.numberOfCells - 1
            
            self.courseTableView.beginUpdates()
            self.courseTableView.deleteRows(at: [indexPath], with: .fade)
            self.courseTableView.endUpdates()
            
            if self.numberOfCells == 12 {
                self.addCourseButton.isHidden = true
            }else {
                self.addCourseButton.isHidden = false
            }
            
            if let myGPA = self.myGPA {
                if myGPA.data!.gpa!.count > indexPath.row {
                    myGPA.data!.gpa!.remove(at: indexPath.row)
                }
            }
        }
    }
    
    func selectGrades(at indexPath: IndexPath, with: UITextField) {
        
        let gradesList = myGPA!.data!.universityGpa!.map{$0.grade}
        ActionSheetStringPicker.show(withTitle: "Please select Grade".localized(), rows: gradesList, initialSelection: 0, doneBlock: { (picker, index, object) in
            with.text = gradesList[index]
        }, cancel: { (picker) in
            
        }, origin: with)
    }
    
}

extension UBMyGPAVC {
    private func performAPICall() {
        let endPoint = GETMYGPA
        if Connectivity.isConnectedToInternet() {
            SVProgressHUD.show()
            WebServiceManager.get(params: nil, serviceName: endPoint, serviceType: "My GPA".localized(), modelType: MyGPA.self, success: {[weak self] (response) in
                guard let this = self else {
                    return
                }
                
                this.myGPA = response as? MyGPA
                this.setupView()
                SVProgressHUD.dismiss()
            }) { (error) in
                SVProgressHUD.dismiss()
                self.showAlert(title: KMessageTitle, message: error.localizedDescription, controller: self)
            }
        }else {
            SVProgressHUD.dismiss()
            self.showAlert(title: KMessageTitle, message: "No internet connection!".localized(), controller: self)
        }
    }
    
    private func updateGPA() {
        let endPoint = GETMYGPA
        if Connectivity.isConnectedToInternet() {
            SVProgressHUD.show()
            let persistence = Persistence(with: .user)
            
            self.userLoader.tryUpdateGPA(parameters: gpaJson as [String:AnyObject], successBlock: { (response) in
                print(response)
                SVProgressHUD.dismiss()
            }) { (error) in
                SVProgressHUD.dismiss()
                print(error!.localizedDescription)
            }
            
        }else {
            SVProgressHUD.dismiss()
            self.showAlert(title: KMessageTitle, message: "No internet connection!".localized(), controller: self)
        }
    }
}

extension UBMyGPAVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.currentGPA {
            
            guard !string.isEmpty else {
                return true
            }
            if let currentGPA = self.currentGPA.text {
                
                let enteredText = self.currentGPA.text! + string
                
                if currentGPA.contains(".") && string == "." {
                    return false
                }
                
                if enteredText.count > 4 {
                    return false
                }
                
                if enteredText == "." {
                    self.currentGPA.text = "0".localized()
                    return true
                }
                
                if enteredText.isArabic {
                    print("Arabic")
                    return false
                } else {
                    if Double(enteredText)! <= 5.00 {
                        return true
                    } else {
                        return false
                        
                    }
                }
                //                else {
                //                    return false
                //                }
            }
        }else if textField == self.lastSemesterCH {
            guard !string.isEmpty else {
                return true
            }
            if let ch = self.lastSemesterCH.text, ch.count > 2 {
                return false
            }
        }
        
        return true
    }
}

//extension String {
//  func isValidDouble(maxDecimalPlaces: Int) -> Bool {
//    // Use NumberFormatter to check if we can turn the string into a number
//    // and to get the locale specific decimal separator.
//    let formatter = NumberFormatter()
//    formatter.allowsFloats = true // Default is true, be explicit anyways
//    let decimalSeparator = formatter.decimalSeparator ?? "."  // Gets the locale specific decimal separator. If for some reason there is none we assume "." is used as separator.
//
//    // Check if we can create a valid number. (The formatter creates a NSNumber, but
//    // every NSNumber is a valid double, so we're good!)
//    if formatter.number(from: self) != nil {
//      // Split our string at the decimal separator
//      let split = self.components(separatedBy: decimalSeparator)
//
//      // Depending on whether there was a decimalSeparator we may have one
//      // or two parts now. If it is two then the second part is the one after
//      // the separator, aka the digits we care about.
//      // If there was no separator then the user hasn't entered a decimal
//      // number yet and we treat the string as empty, succeeding the check
//      let digits = split.count == 2 ? split.last ?? "" : ""
//
//      // Finally check if we're <= the allowed digits
//      return digits.count <= maxDecimalPlaces    // TODO: Swift 4.0 replace with digits.count, YAY!
//    }
//
//    return false // couldn't turn string into a valid number
//  }
//}

extension String {
    var isArabic: Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", "(?s).*\\p{Arabic}.*")
        return predicate.evaluate(with: self)
    }
}
