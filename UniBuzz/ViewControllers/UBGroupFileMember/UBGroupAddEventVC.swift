//
//  UBGroupAddEventVC.swift
//  UniBuzz
//
//  Created by Manoj Kumar on 05/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import SVProgressHUD
class UBGroupAddEventVC: UIViewController {
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var txtTitle: UITextField!
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var txtStartTime: UITextField!
    @IBOutlet weak var txtEndTime: UITextField!
    @IBOutlet weak var txtViewDescription: UITextView!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var btnSelectEvent: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    var data: [EventData]?
    var eventType: EventData?
    var selectedDate = Date()
    var groupObj : GroupList?
    var eventId: EventList?
    var startTime: Date?
    var endTime: Date?
    override func viewDidLoad() {
        super.viewDidLoad()
        txtViewDescription.layer.borderColor = UIColor.init(hex: "#3745A3").cgColor
        txtViewDescription.layer.cornerRadius = 3
        txtViewDescription.layer.borderWidth = 1
        self.txtStartDate.inputView = self.getDatePicker(tag: 0, mode: .date)
        self.txtStartTime.inputView = self.getDatePicker(tag: 1,mode: .time)
        self.txtEndTime.inputView = self.getDatePicker(tag: 2, mode: .time)
        
        if let eventId = eventId {
            btnSave.setTitle("Update", for: .normal)
            txtTitle.text = eventId.title
            if let data = data,  let index = data.firstIndex(where: {$0.id! == eventId.event_type!}) {
                self.eventType = data[index]
                self.btnSelectEvent.setTitle(data[index].name ?? "" , for: .normal)
            }
            txtStartDate.text = eventId.start_date
            txtStartTime.text = eventId.time_from
            txtEndTime.text = eventId.time_to
            txtViewDescription.text = eventId.description
            txtAddress.text = eventId.address
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.isMovingFromParent {
            self.data = nil
            self.eventType = nil
        }
    }
    
    @IBAction func btnSelectEventPressed(_ sender: Any) {
        if let data = data, data.count > 0 {
            var temp = data
            temp = temp.sorted(by: { $0.name!.caseInsensitiveCompare($1.name!) == ComparisonResult.orderedAscending })
            let values = temp.map({$0.name!})
            ActionSheetStringPicker.show(withTitle: "Select Event Type".localized(), rows: values , initialSelection: 0 , doneBlock: { [weak self] (picker, index, value) in
                guard let self = self, let value = value as? String else {return}
                self.btnSelectEvent.setTitle(value, for: .normal)
                self.eventType = temp[index]
                }, cancel: { (actionStrin ) in
                    
            }, origin: sender)
        }
    }
    
    func getDatePicker(tag: Int, mode: UIDatePicker.Mode) -> UIDatePicker {
        let datePicker = UIDatePicker()
        datePicker.tag = tag
        datePicker.minimumDate = Date()
        datePicker.datePickerMode = mode
        datePicker.addTarget(self, action: #selector(selectDate(_ : )), for: .valueChanged)
        return datePicker
    }
    
    @objc func selectDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        if sender.tag == 0 {
            dateFormatter.dateFormat = "yyyy-MM-dd"
            self.selectedDate = sender.date
            self.txtStartDate.text = dateFormatter.string(from: self.selectedDate)
        } else if sender.tag == 1 {
            dateFormatter.dateFormat = "hh:mm a"
            self.txtStartTime.text = dateFormatter.string(from: sender.date)
        } else {
            dateFormatter.dateFormat = "hh:mm a"
            self.txtEndTime.text = dateFormatter.string(from: sender.date)
        }
    }
    
    @IBAction func btnSavePressed(_ sender: Any) {
        var message = ""
        if txtTitle.text!.isBlank() {
            message = StringConstants.titleMessage
        } else if txtTitle.text!.trim().count < 5 {
            message = StringConstants.titleLength
        } else if btnSelectEvent.titleLabel!.text!.trim() ==  "Select Event Type" {
            message = StringConstants.eventType
        } else if txtStartDate.text!.isBlank() {
            message = StringConstants.eventDate
        }
        
        if message.count > 0 {
            self.showAlert(title: StringConstants.appName, message: message, controller: self)
        } else {
            SVProgressHUD.show()
            if let id = eventId?.id {
                let eventid = "\(id)"
                let params = self.loadParameters(id: eventid)
                let persistence = Persistence(with: .user)
                let userObj : Session? = persistence.load()
                let user_token = userObj?.access_token
                let headerPath =  "Bearer \(user_token!)"
                let headers = [
                    "Authorization":  headerPath ,
                    "Accept" : "application/json" ,
                    "Content-Type" : "application/json"
                ]
                
                let postData = try!  JSONSerialization.data(withJSONObject: params, options: [])
                let request = NSMutableURLRequest(url: NSURL(string: UPDATEEVENT)! as URL,
                                                  cachePolicy: .useProtocolCachePolicy,
                                                  timeoutInterval: 10.0)
                request.httpMethod = "PUT"
                request.allHTTPHeaderFields = headers
                request.httpBody = postData as Data
                let session = URLSession.shared
                let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [weak self] (data, response, error) -> Void in
                    guard let self = self else {return}
                    SVProgressHUD.dismiss()
                    DispatchQueue.main.async {
                        if let error =  error {
                            self.showAlert(title: StringConstants.appName, message: error.localizedDescription, controller: self)
                        } else {
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    
                })
                
                dataTask.resume()
            } else {
                let params = self.loadParameters(id: nil)
                WebServiceManager.postJson(params: params, serviceName: CREATEEVENT, serviceType: "Create Event".localized(), modelType:  UserResponse.self, success: { [weak self] (response) in
                    guard let self = self else {return}
                    SVProgressHUD.dismiss()
                    if let _ =  response as? UserResponse {
                        self.navigationController?.popViewController(animated: true)
                    }
                    }, fail: {(error) in
                        
                }, showHUD: true)
            }
            
            
        }
    }
    
    func loadParameters(id: String?) ->  Dictionary<String, AnyObject> {
        var params =  [String: Any]()
        if let groupObj =  groupObj?.id {
            params = [
                "group_id": "\(groupObj)",
                "title": txtTitle.text!,
                "type": "\(self.eventType?.id ?? 0)" ,
                "date": txtStartDate.text!,
                "start_time": txtStartTime.text!,
                "end_time": txtEndTime.text!,
                "description": txtViewDescription.text!,
                "location": txtAddress.text!
            ]
            if let id = id {
                params["id"] = id
            }
        }
        return params as Dictionary<String, AnyObject>
    }
    
    @IBAction func btnCrossTaped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
