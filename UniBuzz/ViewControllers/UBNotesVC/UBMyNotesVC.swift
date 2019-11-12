//
//  UBMyNotesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 01/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBMyNotesVC: UIViewController {
    
    @IBOutlet weak var tblViewss    : UITableView!
    var listOfNote : Note?
    private var isNoteSlideOrSylabus  : [Int] = []
    private var isReportOrEssay  : [Int] = []
    private var isQuiz  : [Int] = []
    private var isNotes  : [Int] = []
    private var isNoteFav  : [Int] = []
//    var isSearch  : Bool?
//    @IBOutlet weak var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewss.registerCells([
            AllNotesCell.self
            ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllSavedNotes()
    }
    func getAllSavedNotes() {
        WebServiceManager.get(params: nil, serviceName: NOTESSAVED , serviceType: "Saved Item List".localized() , modelType: Note.self, success: { [weak self] (response) in
            guard let this = self else {
                return
            }
            this.listOfNote = (response as! Note)
            if this.listOfNote?.status == true {
                for (_ , noteType) in (((this.listOfNote?.note?.noteList?.enumerated()))!) {
//                    self!.listOfNote?.note?.noteList?.append(noteType)
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
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
            }
            else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfNote?.message!)!, controller: self)
            }
        }) { (error) in
        }

    }
    
//    func getSearchResult(search : String) {
//        let allSearch = search.replacingOccurrences(of: " ", with: "%20")
//        let serviceUrl = "\(NOTESSAVED)?q=\(allSearch)"
//        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed", modelType: Note.self, success: {[weak self] (response) in
//            guard let this = self else {
//                return
//             }
//            this.listOfNote = (response as! Note)
//            if this.listOfNote?.status == true {
//               for (_ , noteType) in (((this.listOfNote?.note?.noteList?.enumerated()))!) {
//                   if  noteType.notes_type == "Reports" {
//                        self!.isReportOrEssay.append(noteType.id!)
//                      }
//                  if noteType.notes_type == "Slides"  {
//                        self!.isNoteSlideOrSylabus.append(noteType.id!)
//                    }
//                  if noteType.notes_type == "Notes" {
//                        self!.isNotes.append(noteType.id!)
//                    }
//                  if noteType.is_favorite == true {
//                       self!.isNoteFav.append(noteType.id!)
//                    }
//                            }
////                            this.tblViewss.delegate = self
////                            this.tblViewss.dataSource = self
//                  this.tblViewss.reloadData()
//                        }
//                        else {
//                            self!.showAlert(title: KMessageTitle, message: (self!.listOfNote?.message!)!, controller: self)
//                        }
//        }) { (error) in
//
//        }
//    }
    
    func notesUnFav(note : NoteList , index : IndexPath) {

        let noteId = note.id
        let endPoint = "\(NOTESFAV)\(noteId!)"
        let endPointss = AuthEndpoint.noteFav(noteId: "\(noteId!)")
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




extension UBMyNotesVC : UITableViewDelegate , UITableViewDataSource {
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
        
        cell.viewOfHeader.backgroundColor   =   UIColor(red: 154/255.0, green: 116/255.0, blue: 244/255.0, alpha: 1.0)
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
//        let vc  =  self.storyboard?.instantiateViewController(withIdentifier: "UBNotesDetailVC") as? UBNotesDetailVC
//        vc?.noteDetail = self.listOfNote?.note?.noteList![indexPath.row]
//        self.navigationController?.pushViewController(vc!, animated: true)
    }

    
}

extension UBMyNotesVC : BookMarkNotesDeelegate {
    
    func addedToBookMarked(cell: AllNotesCell, index: IndexPath) {
        let  noteObj = self.listOfNote?.note?.noteList![index.row]
        DispatchQueue.global().async {[weak self] in
            self!.notesUnFav(note: noteObj! , index: index)
            DispatchQueue.main.sync { [weak self] in
                
                if let index  = self!.isNoteFav.index(where: {$0 == noteObj?.id}) {
                    self!.isNoteFav.remove(at: index)
                    self?.listOfNote?.note?.noteList?.remove(at: index)
                    self?.tblViewss.reloadData()
                }
            }
        }
        
    }
    
    
}

extension UBMyNotesVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }

}
