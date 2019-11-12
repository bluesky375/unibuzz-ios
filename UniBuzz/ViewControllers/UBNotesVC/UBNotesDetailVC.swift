//
//  UBNotesDetailVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 03/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import PDFKit
import SVProgressHUD
import ActionSheetPicker_3_0
  

class UBNotesDetailVC: UIViewController {

    @IBOutlet weak var pdfView: PDFView!
    var noteDetail : NoteList?
    var listOfNoteDetail : Note?
    var pageNumber  = 1
    @IBOutlet weak var lblNumberOfPage: UILabel!
    var pageCount : Int?
    @IBOutlet weak var btnSelecrPdf: UIButton!
    @IBOutlet weak var progrssBar: UIProgressView!
    var progressBarTimer: Timer!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTypeCreater: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
//        pageNumber = 1
        
        progrssBar.progress = 0.0
//        progrssBar.layer.cornerRadius = 10
//        progrssBar.clipsToBounds = true
//        progrssBar.layer.sublayers![1].cornerRadius = 10
//        progrssBar.subviews[1].clipsToBounds = true
        
        lblTitle.text = noteDetail?.note_course_name ?? "Document".localized()
        lblDescription.text = noteDetail?.descriptionOfNote ?? " "
        lblType.text = noteDetail?.type_name ?? " "
        lblTypeCreater.text = noteDetail?.created_by ?? " "
        lblLanguage.text = noteDetail?.language ?? " "
        progrssBar.isHidden = false
        getNotesDetail()
        // Do any additional setup after loading the view.
    }
    
    @objc func updateProgressView(){
//        progrssBar.progress += 0.1
//        progrssBar.setProgress(progrssBar.progress , animated: true)
        progrssBar.progress += 0.1
        progrssBar.setProgress(progrssBar.progress, animated: true)
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func btnSelectPdf_PRessed(_ sender: UIButton) {
        
        var allPdf = [String]()
        for (_ , info) in (listOfNoteDetail?.noteDetail?.notefileList?.enumerated())! {
            allPdf.append(info.filename!)
        }
        ActionSheetStringPicker.show(withTitle: "Select Pdf ".localized(), rows: allPdf , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
            let pdfFile = self!.listOfNoteDetail?.noteDetail?.notefileList![index]
            self!.btnSelecrPdf.setTitle(pdfFile?.filename , for: .normal)
            self!.viewPdf(pdfSelect: pdfFile!)
            return
        }, cancel: { (actionStrin ) in
        }, origin: sender)
    }
    
    func viewPdf(pdfSelect : NotesFile) {
        

        let pdfFileName = pdfSelect.filename
        let fullUrl = "\(PDFBASE_URL)\(pdfFileName!)"
        self.pageNumber = 1
        guard let url = URL(string: fullUrl) else {return}
        do{
            self.pdfView.displayMode = .singlePageContinuous
//            SVProgressHUD.show()
            DispatchQueue.global(qos: .background).async {
              let pdfDocument = PDFDocument(url: url)
                DispatchQueue.main.async(execute: {() -> Void in
                    self.pdfView.autoScales = true
                    self.pageCount = pdfDocument?.pageCount
                    self.lblNumberOfPage.text = "Page".localized() + " 1 /\(self.pageCount!)"
                    self.pdfView.document = pdfDocument
                    SVProgressHUD.dismiss()

                })
                }
            
     } catch let err{
            print(err.localizedDescription)
        }

    }
    @IBAction private func btnNext(_ sender : UIButton) {
//        pdfView.currentPage
        
        if pageNumber !=  pageCount {
             pageNumber += 1
        }
        self.lblNumberOfPage.text = "Page".localized() + " \(pageNumber) /\(pageCount!)"

        pdfView.goToNextPage(sender)
    }
    
    @IBAction private func btnPrev(_ sender : UIButton) {
        
        if pageNumber > 1 {
              pageNumber -= 1
        }
        self.lblNumberOfPage.text = "Page".localized() + " \(pageNumber) /\(pageCount!)"
        pdfView.goToPreviousPage(sender)

    }

    func getNotesDetail() {
        let noteId = noteDetail?.id
        let serviceUrl = "\(NOTEVIEW)\(noteId!)"
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Note Detail".localized(), modelType: Note.self, success: {[weak self] (response) in
            self!.listOfNoteDetail = (response as! Note)
            if self!.listOfNoteDetail?.status == true {
                let pdfFileName = self?.listOfNoteDetail?.noteDetail?.notefileList![0].filename
                let fullUrl = "\(PDFBASE_URL)\(pdfFileName!)"
                guard let url = URL(string: fullUrl) else {return}
                 do{
                    self!.pdfView.displayMode = .singlePageContinuous
                    self!.btnSelecrPdf.setTitle(pdfFileName , for: .normal)
                    let pdfDocument = PDFDocument(url: url)
                    self!.pdfView.autoScales = true
                    self!.pageCount = pdfDocument?.pageCount
                    self?.lblNumberOfPage.text = "Page".localized() + " 1 /\(self!.pageCount!)"
                    self!.pdfView.document = pdfDocument
                    SVProgressHUD.dismiss()

                } catch let err{
                        print(err.localizedDescription)
                }

                
            } else {
                self!.showAlert(title: KMessageTitle, message: (self!.listOfNoteDetail?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }

    

}
