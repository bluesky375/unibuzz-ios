//
//  UBAllNotesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
import ActionSheetPicker_3_0

class UBAllNotesVC: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    var listOfNote : Note?
    private var isNoteSlideOrSylabus  : [Int] = []
    private var isReportOrEssay  : [Int] = []
    private var isQuiz  : [Int] = []
    private var isNotes  : [Int] = []
    private var isNoteFav  : [Int] = []
    var isSearch  : Bool?
    var  isPageRefreshing = false
    var numberOfPage   : Int?
    var page = 1
    var data: FilterData?
    var categoryId: String?
    var searchStr: String?
    var filterUniVersity: Universities?
    var filterTopic: FilterCategories?
    var filterCourses: FilterCourses?
    @IBOutlet weak var activity: UIActivityIndicatorView!
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectTopicButton: UIButton!
    @IBOutlet weak var selectCourseButton: UIButton!
    @IBOutlet weak var selectUniversityButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerHeightConstant: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if categoryId != nil {
            containerHeightConstant.constant = 0
        }
        isSearch = false
        searchBar.showsCancelButton = false
        tblViewss.rowHeight = 0.0
        tblViewss.estimatedRowHeight = 0.0
        
        tblViewss.registerCells([
            AllNotesCell.self
        ])
        
        if #available(iOS 10.0, *) {
            tblViewss.refreshControl = refreshControl
        } else {
            tblViewss.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData), for: .valueChanged)
        SVProgressHUD.show()
        if let searchStr = self.searchStr {
            containerHeightConstant.constant = 0
            searchBar.text = searchStr
            getSearchResult(search: "q=\(searchStr)")
        } else {
            getAllNotes()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            self.filterTopic = nil
            self.filterCourses = nil
            self.filterUniVersity = nil
            self.data = nil
        }
    }
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func refreshWithData(_ sender: Any) {
        if Connectivity.isConnectedToInternet() {
            getAllNotes()
        } else {
            self.showAlertViewWithTitle(title: KMessageTitle, message: KValidationOFInternetConnection) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    @IBAction func searchButtonAction(_ sender: Any) {
        SVProgressHUD.show()
        var qwery = ""
        let search = searchBar.text!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !search.isEmpty {
            qwery =  qwery + "q=\(search)"
        }
        if let id = filterCourses?.id{
            if !qwery.isEmpty {
                qwery =  qwery + "&course=\(id)"
            } else {
                qwery = qwery + "course=\(id)"
            }
        }
        
        if let id = filterTopic?.id{
            if !qwery.isEmpty {
                qwery =  qwery + "&cat=\(id)"
            } else {
                qwery = qwery + "cat=\(id)"
            }
        }
        if let id = filterUniVersity?.id{
            if !qwery.isEmpty {
                qwery =  qwery + "&uni=\(id)"
            } else {
                qwery = qwery + "uni=\(id)"
            }
        }
        if qwery.isEmpty {
            self.getAllNotes()
        } else {
            self.getSearchResult(search: qwery)
        }
    }
    
    @IBAction func clearButtonAction(_ sender: Any) {
        searchBar.text = ""
        self.filterTopic = nil
        self.filterCourses = nil
        self.filterUniVersity = nil
        selectTopicButton.setTitle("Select Topic", for: .normal)
        selectCourseButton.setTitle("Select Course", for: .normal)
        selectUniversityButton.setTitle("Select University", for: .normal)
    }
    @IBAction func selectUniversityButtonAction(_ sender: Any) {
        if let universities = data?.universities, universities.count > 0 {
            var temp = universities
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            var allUniversities = [String]()
            if AppDelegate.isArabic() {
                allUniversities = temp.map({$0.name_ar!})
            } else {
                allUniversities = temp.map({$0.name!})
            }
            ActionSheetStringPicker.show(withTitle: "Select University".localized(), rows: allUniversities , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.selectUniversityButton.setTitle(value, for: .normal)
                self.filterUniVersity = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
        
    }
    
    @IBAction func selectCourceButtonAction(_ sender: Any) {
        if let courses = data?.courses, courses.count > 0 {
            var temp = courses
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            var allUniversities = [String]()
            if AppDelegate.isArabic() {
                allUniversities = temp.map({$0.name_ar!})
            } else {
                allUniversities = temp.map({$0.name!})
            }
            ActionSheetStringPicker.show(withTitle: "Select Course".localized(), rows: allUniversities , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.selectCourseButton.setTitle(value, for: .normal)
                self.filterCourses = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
        
        
    }
    
    @IBAction func filterButtonAction(_ sender: Any) {
        containerHeightConstant.constant = containerHeightConstant.constant == 0 ? 210 : 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectTopicButtonAction(_ sender: Any) {
        
        if let categories = data?.categories, categories.count > 0 {
            var temp = categories
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            var allUniversities = [String]()
            if AppDelegate.isArabic() {
                allUniversities = temp.map({$0.name_ar!})
            } else {
                allUniversities = temp.map({$0.name!})
            }
            ActionSheetStringPicker.show(withTitle: "Select Topic".localized(), rows: allUniversities , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.selectTopicButton.setTitle(value, for: .normal)
                self.filterTopic = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
    }
    
    func getAllNotes() {
        var url = MYNOTELIST
        if let categoryId = categoryId {
            url = "\(MYNOTELIST)/\(categoryId)"
        }
        WebServiceManager.get(params: nil, serviceName: url , serviceType: "Group List".localized(), modelType: Note.self, success: {[weak self] (response) in
            guard let self = self else {
                return
            }
            SVProgressHUD.dismiss()
            self.listOfNote = (response as! Note)
            self.numberOfPage = self.listOfNote?.note?.last_page
            self.page = 1
            self.isPageRefreshing = false
            
            
            if self.listOfNote?.status == true {
                for (_ , noteType) in (((self.listOfNote?.note?.noteList?.enumerated()))!) {
                    if  noteType.notes_type == "Reports" {
                        self.isReportOrEssay.append(noteType.id!)
                    }
                    else  if noteType.notes_type == "Slides"  {
                        self.isNoteSlideOrSylabus.append(noteType.id!)
                    }
                    else   if noteType.notes_type == "Notes" {
                        self.isNotes.append(noteType.id!)
                    }
                    else if noteType.notes_type == "Quiz" {
                        self.isQuiz.append(noteType.id!)
                    }
                    
                    if noteType.is_favorite == true {
                        self.isNoteFav.append(noteType.id!)
                    }
                    
                    
                }
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.reloadData()
                self.refreshControl.endRefreshing()
                
                self.page = self.page + 1
                
            }
            else {
                self.showAlert(title: KMessageTitle, message: (self.listOfNote?.message!)!, controller: self)
            }
        }) { (error) in
        }
    }
    
    
    func makeRequest(pageSize : Int)  {
        var serviceURL : String?
        serviceURL = "\(MYNOTELIST)?page=\(page)"
        if let categoryId = categoryId {
            serviceURL = "\(MYNOTELIST)/\(categoryId)?page=\(page)"
        }
        WebServiceManager.get(params: nil, serviceName: serviceURL! , serviceType: "", modelType: Note.self , success: { [weak self] (response) in
            let responeOfPagination = (response as! Note)
            
            self!.numberOfPage = responeOfPagination.note?.last_page
            if responeOfPagination.status == true {
                self!.isPageRefreshing = false
                
                for (_ , noteType) in (((responeOfPagination.note?.noteList?.enumerated()))!) {
                    self!.listOfNote?.note?.noteList?.append(noteType)
                    
                    if  noteType.notes_type == "Reports" {
                        self!.isReportOrEssay.append(noteType.id!)
                    }
                    else if noteType.notes_type == "Slides"  {
                        self!.isNoteSlideOrSylabus.append(noteType.id!)
                    }
                    else if noteType.notes_type == "Notes" {
                        self!.isNotes.append(noteType.id!)
                    }
                        
                    else if noteType.notes_type == "Quiz" {
                        self!.isQuiz.append(noteType.id!)
                    }
                    
                    if noteType.is_favorite == true {
                        self!.isNoteFav.append(noteType.id!)
                    }
                    
                }
                self!.tblViewss.tableFooterView?.isHidden = true
                self!.activity.stopAnimating()
                self!.tblViewss.reloadData()
                self!.refreshControl.endRefreshing()
                self!.tblViewss.layoutIfNeeded()
                self!.page = self!.page + 1
                
            }
            
            
        }) { (error) in
        }
    }
    
    
    func getSearchResult(search : String) {
        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
        let serviceUrl = "\(MYNOTELIST)?\(allSearch)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: Note.self, success: {[weak self] (response) in
            guard let self = self else {
                return
            }
            SVProgressHUD.dismiss()
            self.listOfNote = (response as! Note)
            if self.listOfNote?.status == true {
                for (_ , noteType) in (((self.listOfNote?.note?.noteList?.enumerated()))!) {
                    if  noteType.notes_type == "Reports" {
                        self.isReportOrEssay.append(noteType.id!)
                    }
                    else  if noteType.notes_type == "Slides"  {
                        self.isNoteSlideOrSylabus.append(noteType.id!)
                    }
                    else if noteType.notes_type == "Notes" {
                        self.isNotes.append(noteType.id!)
                    }
                    else if noteType.notes_type == "Quiz" {
                        self.isQuiz.append(noteType.id!)
                    }
                    if noteType.is_favorite == true {
                        self.isNoteFav.append(noteType.id!)
                    }
                    
                }
                self.tblViewss.reloadData()
            }
            else {
                self.showAlert(title: KMessageTitle, message: (self.listOfNote?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }
    func noteFav(note : NoteList , index : IndexPath) {
        
        let noteId = note.id
        let endPoint = "\(NOTESFAV)\(noteId!)"
        //        let endPoint = "\(POSTRECT)/\(postId!)/\(rection)"
        let endPointss = AuthEndpoint.noteFav(noteId: "\(noteId!)")
        //        group.enter()
        NetworkLayer.fetchPost(endPointss , url: endPoint , with: LoginResponse.self) {[weak self] (result) in
            switch result {
            case .success(let response):
                if response.status == true {
                }
            case .failure(let error):
                break
            }
            
        }
    }
    
    
}

extension UBAllNotesVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listOfNote?.note?.noteList?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: AllNotesCell.self, for: indexPath)
        //        if indexPath.row == 0 {
        //            cell.viewOfHeader.backgroundColor = UIColor(red: 154/255.0, green: 116/255.0, blue: 244/255.0, alpha: 1.0)
        //        }
        
        cell.lblUniName.text =  self.listOfNote?.note?.noteList![indexPath.row].university_name ?? " "
        cell.lblUserName.text =  self.listOfNote?.note?.noteList![indexPath.row].professor_name ?? " "
        cell.lblIsReviewQuestion.text =  self.listOfNote?.note?.noteList![indexPath.row].type_name ?? " "
        cell.lblSubjectOfNote.text =  self.listOfNote?.note?.noteList![indexPath.row].language ?? " "
        cell.delegate = self
        cell.selectIndex = indexPath
        cell.lblNoteCode.text =  self.listOfNote?.note?.noteList![indexPath.row].note_course_code
        cell.lblCourseTitle.text =  self.listOfNote?.note?.noteList![indexPath.row].note_course_name
        //        cell.lblSubjectOfNote.text =  self.listOfNote?.note?.noteList![indexPath.row].language
        if isNoteSlideOrSylabus.contains((self.listOfNote?.note?.noteList![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#d67000")
            cell.imgOFType.image = UIImage(named: "slides")
        }
        else  if isReportOrEssay.contains((self.listOfNote?.note?.noteList![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#058bed")
            cell.imgOFType.image = UIImage(named: "reports")
        } else  if isQuiz.contains((self.listOfNote?.note?.noteList![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#9a6ff7")
            cell.imgOFType.image = UIImage(named: "quiz")
            
        } else  if isNotes.contains((self.listOfNote?.note?.noteList![indexPath.row].id)!) {
            cell.viewOfHeader.backgroundColor = UIColor(hex: "#f86e7e")
            cell.imgOFType.image = UIImage(named: "notes")
        }
        if isNoteFav.contains((self.listOfNote?.note?.noteList![indexPath.row].id)!) {
            cell.btnSave.isSelected = true
        } else {
            cell.btnSave.isSelected = false
        }
        let rate = self.listOfNote?.note?.noteList![indexPath.row].rate
        cell.viewOfRating.rating = Double(rate!)
        
        guard  let image = self.listOfNote?.note?.noteList![indexPath.row].university_logo  else   {
            return cell
        }
        WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUni!), placeHolder: "profile2")
        let cgFloat: CGFloat = cell.imgOfUni.frame.size.width/2.0
        let someFloat = Float(cgFloat)
        WAShareHelper.setViewCornerRadius(cell.imgOfUni, radius: CGFloat(someFloat))
        cell.delegate = self
        cell.selectIndex = indexPath
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 198.0
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBNotesDetailVC") as? UBNotesDetailVC
        vc?.noteDetail = self.listOfNote?.note?.noteList![indexPath.row]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func scrollViewDidEndDecelerating(_  scrollView: UIScrollView) {
        if scrollView == tblViewss {
            if ((tblViewss.contentOffset.y + tblViewss.frame.size.height) >= tblViewss.contentSize.height) {
                if isPageRefreshing == false {
                    isPageRefreshing = true
                    if page <= numberOfPage! {
                        self.makeRequest(pageSize: self.page)
                        self.tblViewss.tableFooterView = self.activity
                        self.activity.startAnimating()
                        self.tblViewss.tableFooterView?.isHidden = false
                    } else {
                        
                    }
                    
                }  else {
                }
            } else {
            }
            
        }
        
    }
    
}

extension UBAllNotesVC : BookMarkNotesDeelegate {
    func addedToBookMarked(cell: AllNotesCell, index: IndexPath) {
        // Book Marked button selection
        let  noteObj  = self.listOfNote?.note?.noteList![index.row]
        if cell.btnSave.isSelected == true {
            DispatchQueue.global().async { [weak self] in
                self!.noteFav(note: noteObj! , index: index)
                DispatchQueue.main.sync { [weak self] in
                    self!.isNoteFav.append((noteObj?.id!)!)
                    self!.listOfNote?.note?.noteList![index.row].is_favorite = true
                }
            }
        }
            
        else {
            DispatchQueue.global().async { [weak self] in
                self!.noteFav(note: noteObj! , index: index)
                
                DispatchQueue.main.sync { [weak self] in
                    if let index  = self!.isNoteFav.index(where: {$0 == noteObj?.id}) {
                        self!.isNoteFav.remove(at: index)
                    }
                    self!.listOfNote?.note?.noteList![index.row].is_favorite = false
                }
            }
        }
    }
}

extension UBAllNotesVC : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        getSearchResult(search: "q=\(searchBar.text!)")
        isSearch = true
    }
}


extension UBAllNotesVC: UIScrollViewDelegate {
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        containerHeightConstant.constant = 0
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
}
