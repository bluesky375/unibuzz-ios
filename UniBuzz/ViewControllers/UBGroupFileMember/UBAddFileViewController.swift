//
//  UBAddFileViewController.swift
//  UniBuzz
//
//  Created by Manoj Kumar on 07/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import MobileCoreServices
import SVProgressHUD
import ActionSheetPicker_3_0

class UBAddFileViewController: UIViewController {
    
    @IBOutlet weak var txtTitle: TextField!
    
    @IBOutlet weak var txtDescription: TextField!
    @IBOutlet weak var btnSelectNotes: UIButton!
    
    @IBOutlet weak var btnFileBrowser: UIButton!
    @IBOutlet weak var btnSelectLanguage: UIButton!
    var noteType: Notes_type?
    var language: Language?
    var data: FileData?
    var groupObj : GroupList?
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        let yourViewBorder = CAShapeLayer()
        yourViewBorder.strokeColor = UIColor.black.cgColor
        yourViewBorder.lineDashPattern = [5, 5]
        yourViewBorder.frame = btnFileBrowser.bounds
        yourViewBorder.fillColor = nil
        yourViewBorder.path = UIBezierPath(roundedRect: btnFileBrowser.bounds, cornerRadius: 8).cgPath
        btnFileBrowser.layer.addSublayer(yourViewBorder)
        btnFileBrowser.imageView?.contentMode = .scaleAspectFit
        btnFileBrowser.alignTextUnderImage()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            noteType = nil
            language = nil
            data = nil
            groupObj = nil
        }
        
    }
    
    func loadParameters(id: String?) ->  Dictionary<String, AnyObject> {
        var params =  [String: Any]()
        if let groupObj =  groupObj?.id {
            params = [
                "group_id": "\(groupObj)",
                "title": txtTitle.text!,
                "note_type": "\( self.noteType?.id ?? 0)",
                "description": txtDescription.text ?? "",
                "language": "\(self.language?.id ?? "")",
                "creator": "" ,
            ]
        }
        return params as Dictionary<String, AnyObject>
    }
    
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnSelectNotesPressed(_ sender: Any) {
        if let data = data?.notes_type, data.count > 0 {
            var temp = data
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            let values = temp.map({$0.name!.localized()})
            ActionSheetStringPicker.show(withTitle: "Note Type".localized(), rows: values , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.btnSelectNotes.setTitle(value, for: .normal)
                self.noteType = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
    }
    
    @IBAction func btnSelectLanguagePressed(_ sender: Any) {
        if let data = data?.language, data.count > 0 {
            var temp = data
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            let values = temp.map({$0.name!.localized()})
            ActionSheetStringPicker.show(withTitle: "Select Language".localized(), rows: values , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.btnSelectLanguage.setTitle(value, for: .normal)
                self.language = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
    }
    
    
    @IBAction func btnFileBrowserPressed(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.modalPresentationStyle = .fullScreen
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    
    @IBAction func btnSavePressed(_ sender: Any) {
        var message = ""
        if txtTitle.text!.isBlank() {
            message = StringConstants.titleMessage
        } else if txtTitle.text!.trim().count < 5 {
            message = StringConstants.titleLength
        } else if btnSelectNotes.titleLabel!.text!.trim() ==  "Note Type".localized() {
            message = StringConstants.noteType
        }  else if url == nil {
            message = StringConstants.selectFile
        }
        
        if message.count > 0 {
            self.showAlert(title: StringConstants.appName, message: message, controller: self)
        } else {
            SVProgressHUD.show()
            let params = self.loadParameters(id: nil)
            if  let url = self.url {
                WebServiceManager.multiPartURL(params: params, serviceName: FILESTORE, fileParam: "files[]", fileName: url.lastPathComponent, serviceType: "Note Type".localized() , fileURL: url, modelType: UserResponse.self, success: { [weak self](response) in
                    guard let self = self else {return}
                    SVProgressHUD.dismiss()
                    if let response = response as? UserResponse {
                        if response.status == true {
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.showAlert(title: StringConstants.appName, message: response.message ?? "", controller: self)
                        }
                    }
                    
                }) { (error) in
                    
                }
            }
            
        }
    }
    @IBAction func btnCrossPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
extension UBAddFileViewController: UIDocumentPickerDelegate{
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        self.url = myURL
        btnFileBrowser.setTitle(myURL.lastPathComponent, for: .normal)
        print("import result : \(myURL)")
    }
    
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
}
