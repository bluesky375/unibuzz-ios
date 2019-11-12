//
//  UBCalenderVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SVProgressHUD
//protocol DisableActionDelegate : class {
//    func calndarDelegate()
//}
class UBCalenderVC: UIViewController {
    @IBOutlet weak var addEventView: UIView!
    
    var index: Int?
    var groupObj : GroupList?
    var selectedRow : [Int] = []
    var userFeeds : UserResponse?
    var eventData: CalendarData?
    var eventTypeList: [EventData]?
    var selectText : String?
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var tblViewEvent:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblViewEvent.separatorStyle = .none
        SVProgressHUD.show()
        self.fetchEventsType()
        selectText = "There are currently no file in your list.".localized()
        if #available(iOS 10.0, *) {
            tblViewEvent.refreshControl = refreshControl
        } else {
            tblViewEvent.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWithData(_:)), for: .valueChanged)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllEvents()
    }
    @objc private func refreshWithData(_ sender: Any) {
        self.getAllEvents()
    }
    
    func fetchEventsType() {
        SVProgressHUD.show()
        WebServiceManager.get(params: nil, serviceName: EVENTTYPE, serviceType: "Country List".localized(), modelType: EventTypeModel.self, success: {[weak self] (response) in
            guard let self = self else {return}
            SVProgressHUD.dismiss()
            if let response = response as? EventTypeModel {
                self.eventTypeList = response.data
            }
        }) { (error) in
        }
    }
    
    @IBAction func btnAddEventPresses(_ sender: Any) {
        self.getEventType()
    }
    
    func getEventType(object: EventList? = nil) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBGroupAddEventVC" ) as! UBGroupAddEventVC
        vc.groupObj = self.groupObj
        vc.eventId = object
        if let response = self.eventTypeList {
            vc.data = response
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func getAllEvents() {
        if groupObj?.is_member == false && groupObj?.is_private_group == false {
            SVProgressHUD.dismiss()
            self.addEventView.isHidden = true
            refreshControl.endRefreshing()
            selectText = "No access.".localized()
        } else if groupObj?.is_private_group == true && groupObj?.is_member == false && groupObj?.is_my_group == false {
            SVProgressHUD.dismiss()
            self.addEventView.isHidden = true
            refreshControl.endRefreshing()
            selectText = "No access.".localized()
        }
        else {
            let groupId = groupObj?.id
            let serviceUrl = "\(ALLEVENT)\(groupId!)/index"
            WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Get Events".localized(), modelType: CalendarModel.self, success: { [weak self](response) in
                guard let self = self else {return}
                SVProgressHUD.dismiss()
                self.refreshControl.endRefreshing()
                if let response = response as? CalendarModel {
                    if let status = response.status, status {
                        self.eventData = response.data
                        self.tblViewEvent.reloadData()
                    } else {
                        self.showAlert(title: KMessageTitle, message: response.message ?? "" , controller: self)
                    }
                }
            }) { (error) in
                
            }
            
        }
        
        
        
    }
    
    func deleteEvents(indexPath: IndexPath) {
        if let data = eventData?.data, data.count > indexPath.row, let id = data[indexPath.row].id {
            SVProgressHUD.show()
            let serviceUrl = "\(DELETEEVENT)\(id)"
            WebServiceManager.delete(params: [:] , serviceName: serviceUrl , isLoaderShow: true , serviceType: "Delete Event".localized(), modelType: UserResponse.self, success: { (responseData) in
                SVProgressHUD.dismiss()
                self.userFeeds = (responseData as! UserResponse)
                if self.userFeeds?.status == true {
                    self.eventData?.data?.remove(at: indexPath.row)
                    self.tblViewEvent.reloadData()
                } else {
                    self.showAlert(title: KMessageTitle, message: (self.userFeeds?.message!)!, controller: self)
                }
            }, fail: { (error) in
            }, showHUD: true)
        }
        
    }
}

extension UBCalenderVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if let list = eventData?.data, list.count > 0  {
            numOfSections = 1
            tableView.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = selectText
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .none
        }
        return numOfSections
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let list = eventData?.data {
            return list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCellIdentifier", for: indexPath) as! EventTableViewCell
        if let list = eventData?.data, let eventTypeList = self.eventTypeList {
            if let index = eventTypeList.firstIndex(where: {$0.id! == list[indexPath.row].event_type!}) {
                cell.setUpCell(event: list[indexPath.row], isHidden: selectedRow.contains(indexPath.row), eventType: eventTypeList[index].name)
            }
        }
        cell.editBtnClosure = {[weak self] in
            guard let self = self else {return}
            if let list = self.eventData?.data {
                self.getEventType(object: list[indexPath.row])
            }
        }
        cell.deleteBtnClosure = {[weak self] in
            guard let self = self else {return}
            self.deleteEvents(indexPath: indexPath)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.estimatedRowHeight = 100
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selectedRow.contains(indexPath.row){
            if let index = selectedRow.firstIndex(of: indexPath.row) {
                selectedRow.remove(at: index)
            }
        }else{
            selectedRow.append(indexPath.row)
        }
        UIView.transition(with: tableView, duration: 0.5, options: .transitionCrossDissolve, animations: {tableView.reloadData()}, completion: nil)
    }
    
}

