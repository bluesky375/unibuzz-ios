//
//  PostVC.swift
//  Unibuzz
//
//  Created by kh on 8/31/19.
//  Copyright © 2019 jonh. All rights reserved.
//

import UIKit

class PostVC: BaseVC, UITableViewDelegate, UITableViewDataSource, OptionCellEventDelegate {
   
    var groupList: [Group] = []
    
    var optionTitleList: [String] = ["Option 1*", "Option 2*"]
    var optionValueList: [String] = ["", ""]
    
    var isPost: Bool = true
    var selectedGroupIndex = -1
    var isCreatePost: Bool = true
    
    var disableSubmitButton: Bool = false {
        didSet {
            submitButton.isEnabled = !disableSubmitButton
        }
    }
    
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var postTypeSelectionButtonHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postTitleText: UITextView!
    @IBOutlet weak var btnPost: UIButton!
    @IBOutlet weak var btnPoll: UIButton!
    
    @IBOutlet weak var addOptionButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var pollOptionTableHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var pollOptionTable: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var isPostAsAnonymous: CheckBox!
    @IBOutlet weak var isPostDisableComments: CheckBox!
    
    @IBOutlet weak var contentViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var groupNameText: UILabel!
    @IBOutlet weak var btnSelectGroup: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnSelectGroup.isEnabled = false
        ApiClient.getAllGroups() { res in
            self.groupList = Group.fromDicArray(data: res!)
            self.btnSelectGroup.isEnabled = true
        }
    }
    
    override func getHeightConstraint() -> NSLayoutConstraint? {
        return mainViewHeightConstraint
    }
    
    @IBAction func onBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionTitleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "pollOptionCell", for: indexPath) as! PollOptionCell
        cell.setOptionTitle(idx: indexPath.row, value: optionValueList[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func toggleView() {
        switch isPost {
        case true:
            btnPost.setImage(UIImage(named: "ic_post_selected"), for: .normal)
            btnPoll.setImage(UIImage(named: "ic_poll_n_selected"), for: .normal)
            
            optionTitleList = [optionTitleList[0], optionTitleList[1]]
            optionValueList = [optionValueList[0], optionValueList[1]]
            
            pollOptionTable.reloadData()
            
            let diffHeight = 50 * (self.optionTitleList.count)
            UIView.animate(withDuration: 0.5, animations: {
                self.addOptionButtonHeightConstraint.constant = 0
                self.pollOptionTableHeightConstraint.constant = 0
                
                self.contentViewHeightConstraint.constant -= CGFloat(diffHeight)
                self.mainViewHeightConstraint.constant -= CGFloat(diffHeight)
            })
            break
        case false:
            btnPost.setImage(UIImage(named: "ic_post_n_selected"), for: .normal)
            btnPoll.setImage(UIImage(named: "ic_poll_selected"), for: .normal)
            
            UIView.animate(withDuration: 0.5) {
                self.pollOptionTableHeightConstraint.constant = 100
                self.addOptionButtonHeightConstraint.constant = 30
                
                self.contentViewHeightConstraint.constant += 130
                self.mainViewHeightConstraint.constant += 130
            }
            break
        }
    }
    
    @IBAction func onPostSelected(_ sender: UIButton) {
        switch sender.tag {
        case 100:   // Post
            if(!isPost) {
                isPost = true
                toggleView()
            }
            break
        case 101:  // Poll
            if(isPost) {
                isPost = false
                toggleView()
            }
            break
        default:
            break
        }
    }
    
    @IBAction func onAddPollOption(_ sender: Any) {
        optionTitleList.append("Option")
        optionValueList.append("")
        
        if optionTitleList.count == 5 {
            addOptionButtonHeightConstraint.constant = 0
        }
        
        pollOptionTable.reloadData()
        
        self.pollOptionTableHeightConstraint.constant += 50
        self.contentViewHeightConstraint.constant += 50
        self.mainViewHeightConstraint.constant += 50
    }
    
    @IBAction func onPost(_ sender: Any) {
        
        isPost ? addPost() : addPoll()
    }
    
    func addPost() {
        if(postTitleText.text.count > 5) {
            if(selectedGroupIndex == -1) {
                showToastMessage(msg: "Please Select Group!")
                return
            }
            disableSubmitButton = true
            ApiClient.addPost(groupId: groupList[selectedGroupIndex].groupId, barCode: groupList[selectedGroupIndex].groupBarCode, comment: postTitleText.text!, disableComments: isPostDisableComments.isChecked(), isAnonymous: isPostAsAnonymous.isChecked()) { res in
                WallVC.shared?.addNewPostorPoll(post: PostData.fromDictionary(postData: res))
                self.disableSubmitButton = false
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            Global.showToastMessage(msg: "Post must be more than 5 characters")
        }
    }
    
    func addPoll() {
        if(postTitleText.text.count > 5) {
            if(selectedGroupIndex == -1) {
                showToastMessage(msg: "Please Select Group!")
                return
            }
            
            var optionArray: [String] = []
            for value in optionValueList {
                if value == "" || value.count < 2 {
                    showToastMessage(msg: "Option must be more than 2 characters!")
                    return
                } else {
                    optionArray.append(value)
                }
            }
            disableSubmitButton = true
                ApiClient.addPoll(groupId: groupList[selectedGroupIndex].groupId, barCode: groupList[selectedGroupIndex].groupBarCode, comment: postTitleText.text!, disableComments: isPostDisableComments.isChecked(), isAnonymous: isPostAsAnonymous.isChecked(), optionArray: optionArray) { res in
                    WallVC.shared?.addNewPostorPoll(post: PostData.fromDictionary(postData: res))
                    self.disableSubmitButton = false
                    self.navigationController?.popViewController(animated: true)
                }
        } else {
            Global.showToastMessage(msg: "Post must be more than 5 characters")
        }
    }
    
    func onOptionRemoved(idx: Int) {
        optionTitleList.remove(at: idx)
        optionValueList.remove(at: idx)
        
        if addOptionButtonHeightConstraint.constant == 0 {
            addOptionButtonHeightConstraint.constant = 30
        }
        
        pollOptionTable.reloadData()
        
        self.pollOptionTableHeightConstraint.constant -= 50
        self.contentViewHeightConstraint.constant -= 50
        self.mainViewHeightConstraint.constant -= 50
    }
    
    @IBAction func onSelectGroup(_ sender: Any) {
        var nameList: [String] = []
        for group in groupList {
            nameList.append(group.groupName)
        }
        showSearchDialog(strList: nameList, title: "Group") { idx in
            self.selectedGroupIndex = idx
            self.groupNameText.text = self.groupList[idx].groupName
        }
    }
    
    func onOptionValueChanged(idx: Int, value: String) {
        optionValueList[idx] = value
    }

}
