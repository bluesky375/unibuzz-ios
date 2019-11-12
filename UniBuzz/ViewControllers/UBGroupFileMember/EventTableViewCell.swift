//
//  EventTableViewCell.swift
//  UniBuzz
//
//  Created by Manoj Kumar on 06/11/19.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblMonth: UILabel!
    @IBOutlet weak var eventDescription: UILabel!
    @IBOutlet weak var buttonVw: UIView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var lblEventHost: UILabel!
    @IBOutlet weak var btnEventType: UIButton!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var btnExpandCollapse: UIButton!
    
    
    var editBtnClosure:(()->())?
    var deleteBtnClosure:(()->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let view = UIView(frame: self.frame)
        view.backgroundColor = .clear
        self.selectedBackgroundView = view
        btnEventType.layer.cornerRadius = 12
        btnEventType.layer.borderColor = UIColor.white.cgColor
        btnEventType.layer.borderWidth = 2
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setData(event:EventList){
        lblEventName.text = event.title
        btnLocation.setTitle(event.address, for: .normal)
        if let host = event.user {
            lblEventHost.text = "By \((host.first_name ?? "") + (host.last_name ?? ""))"
        }
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy-MM-dd"
        if let start_date = event.start_date {
            guard let date = formatter.date(from: start_date) else {
                return
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E"
            lblDay.text = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "dd"
             lblDate.text = dateFormatter.string(from: date)
            dateFormatter.dateFormat = "MM"
             lblMonth.text = dateFormatter.string(from: date)

            
        }
        

        

    }
    
    @IBAction func btnEditPressed(_ sender: Any) {
        if let editBtnClosure = editBtnClosure{
            editBtnClosure()
        }
    }
    @IBAction func btnDeletePressed(_ sender: Any) {
        if let deleteBtnClosure = deleteBtnClosure{
            deleteBtnClosure()
        }
    }
    
    func setUpCell(event: EventList, isHidden: Bool, eventType: String?) {
        btnLocation.isHidden = !isHidden
        lblEventHost.isHidden = !isHidden
        buttonVw.isHidden = !isHidden
        eventDescription.isHidden = !isHidden
        let image = isHidden ?  UIImage(named: "mi-icon") : UIImage(named: "plus-icon")
        btnExpandCollapse.setImage(image, for: .normal)
        if let startDate = event.start_date {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            if let date = formatter.date(from: startDate) {
                formatter.dateFormat = "EEE dd MMM"
                let formatString = formatter.string(from: date)
                let array = formatString.components(separatedBy: " ")
                if array.count == 3 {
                    lblDate.text = array[1]
                    lblDay.text = array[0].uppercased()
                    lblMonth.text = array[2]
                }
            }
        }
        
        let templateImage = btnLocation.imageView?.image?.withRenderingMode(.alwaysTemplate)
        btnLocation.setImage(templateImage, for: .normal)
        btnLocation.imageView?.tintColor = .white
        
        if let location = event.address {
            btnLocation.setTitle( " \(location)", for: .normal)
        }
        
        if let user = event.user {
            lblEventHost.text = "By \(user.first_name ?? "")  \(user.last_name ?? "")"
        }
        eventDescription.text = event.description
        if let time_to = event.time_to, let  time_from = event.time_from {
            eventTime.text = "\(time_to) - \(time_from)"
        } else {
            if !isHidden {
                eventTime.text = " "
                eventTime.isHidden = false
            }else {
                eventTime.isHidden = true
            }
        }
        lblEventName.text = event.title
        btnEventType.setTitle("   \(eventType ?? "")   ", for: .normal)
        if let type = event.event_type {
            switch type {
            case 4:
              containerView.backgroundColor = UIColor(red: 191, green: 178, blue: 0)
            case 3:
              containerView.backgroundColor = UIColor(red: 212, green: 128, blue: 48)
            case 1:
              containerView.backgroundColor = UIColor(red: 71, green: 92, blue: 179)
            default:
              containerView.backgroundColor = UIColor(red: 212, green: 128, blue: 48)
            }
        }
    }
    
}
