//
//  UBGroupInfoVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 15/08/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import SCLAlertView
  

class UBGroupInfoVC: UIViewController {
    
    @IBOutlet weak var tblViewss: UITableView!
    private  var responseObj : UserResponse?
    var selectGroupOrUser : ChatList?
    var groupMember   :       [GroupChatMember]?
    var userObj : Session?
    
    @IBOutlet weak var btnAddButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupMember = []
        let persistence = Persistence(with: .user)
        userObj  = persistence.load()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didAddParticipant(_:)), name: NSNotification.Name(rawValue: "addParticipant"), object: nil)
        
        if selectGroupOrUser?.sender_id == userObj?.id {
            self.btnAddButton.isHidden = false
        } else {
            self.btnAddButton.isHidden = true

        }
        tblViewss.registerCells([
            GroupInfoHeaderCell.self , ParticipantCell.self
            ])
        getGroupIngo()
    }
    
    @objc func didAddParticipant(_ notification: NSNotification) {
        getGroupIngo()
    }
    func getGroupIngo() {
        let groupId = selectGroupOrUser?.id
        let serviceUrl = "\(GROUPINFO)\(groupId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "Get Participant".localized(), modelType: UserResponse.self, success: { [weak self] (response) in
            guard let this = self else {
                return
            }
            this.responseObj = (response as? UserResponse)
            if this.responseObj!.status == true {
                
//                if self?.userObj?.id ==
                
                this.tblViewss.delegate = self
                this.tblViewss.dataSource = self
                this.tblViewss.reloadData()
            } else {
                self!.showAlert(title: KMessageTitle, message: this.responseObj!.message!, controller: self)
            }
            
        }) { (error) in
            
        }
        
    }

    private func deleteUser(memberId : Int) {
        let groupId = selectGroupOrUser?.id
//        let memberId = responseObj?.groupInfo?.chatMembers![index.row - 1].userInfo?.id
        let param =    [ : ] as [String : Any]
        let serviceURl = "\(DESTROY)\(groupId!)/member/\(memberId)/destroy"
        WebServiceManager.delete(params: param as Dictionary<String, AnyObject> , serviceName: serviceURl, isLoaderShow: true , serviceType: "React On Post".localized(), modelType: UserResponse.self, success: { (responseData) in
            if  let post = responseData as? UserResponse {
                if post.status == true {
                    self.navigationController?.popViewController(animated: true)
                } else {
                    self.showAlert(title: KMessageTitle, message: post.message!, controller: self)
                }
            }
        }, fail: { (error) in
        }, showHUD: true)
    }
    
    @IBAction private func btnAddMember(_ sender : UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBAddParticipantVC") as? UBAddParticipantVC
        vc?.selectGroupOrUser = self.selectGroupOrUser
        self.navigationController?.pushViewController(vc!, animated: true)

    }


}

extension UBGroupInfoVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return ((responseObj?.groupInfo?.chatMembers!.count)! + 1)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(with: GroupInfoHeaderCell.self, for: indexPath)
            cell.lblGroupName.text = responseObj?.groupInfo?.group_name
            let numberOfMember = (responseObj?.groupInfo?.chatMembers!.count)! + 1
            let totalMemeber = "\(numberOfMember)" + " Members".localized()
            cell.lblTotalParticipant.text = "\(totalMemeber)"
            guard  let image = responseObj?.groupInfo?.group_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfGroup!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfGroup.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfGroup, radius: CGFloat(someFloat))

            return cell

        } else {
            
            let cell = tableView.dequeueReusableCell(with: ParticipantCell.self, for: indexPath)
            
           
            if indexPath.row ==  0 {
                cell.lblName.text = responseObj?.groupInfo?.sender?.full_name
                cell.btnAdmin.isHidden = false
                cell.btnRemoveParticipant.isHidden = true
                guard  let image = responseObj?.groupInfo?.sender?.profile_image  else   {
                    return cell
                }
                WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
                let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

            } else {
                cell.lblName.text = responseObj?.groupInfo?.chatMembers![indexPath.row - 1].userInfo?.full_name
//                cell.lblUniName.text = responseObj?.groupInfo?.chatMembers![indexPath.row - 1].

                cell.btnAdmin.isHidden = true
                cell.btnRemoveParticipant.isHidden = false
                cell.delegate = self
                cell.selectIndex = indexPath
                
                if self.selectGroupOrUser?.sender_id == self.userObj?.id  {
                    cell.btnRemoveParticipant.isHidden = false
                } else {
                    cell.btnRemoveParticipant.isHidden = true
                    
                }
                
                guard  let image = responseObj?.groupInfo?.chatMembers![indexPath.row - 1].userInfo?.profile_image  else   {
                    return cell
                }
                WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
                let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
                let someFloat = Float(cgFloat)
                WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))

            }

           
            

            return cell

        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 206.0
        } else {
            return 66.0
        }
    }
}

extension UBGroupInfoVC : AddParticipantDelegate {
    func RemoveParticipant(cell: ParticipantCell, selectIndex: IndexPath) {
        
        let appearance = SCLAlertView.SCLAppearance(
            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
            showCloseButton: false,
            dynamicAnimatorActive: true,
            buttonsLayout: .horizontal
        )
        let alert = SCLAlertView(appearance: appearance)
        
        _  = alert.addButton("Yes".localized(), action: {
            let memberId = self.responseObj?.groupInfo?.chatMembers![selectIndex.row - 1].user_id
            self.deleteUser(memberId: memberId!)
            self.responseObj?.groupInfo?.chatMembers?.remove(at: selectIndex.row - 1)
            self.tblViewss.reloadData()
           
        })
        _  = alert.addButton("No".localized(), action: {
            
        })
        
        let color = UIColor(red: 55/255.0, green: 69/255.0, blue: 163/255.0, alpha: 1.0)
        
        let icon = UIImage(named:"wall_checked")
            _ = alert.showCustom("UniBuzz".localized(), subTitle: ("Are you sure to want to delete this ? " as? String)!.localized(), color: color, icon: icon!, circleIconImage: icon!)
        }
    }


