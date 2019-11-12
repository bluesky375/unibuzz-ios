//
//  WallCell.swift
//  Unibuzz
//
//  Created by kh on 8/31/19.
//  Copyright © 2019 jonh. All rights reserved.
//

import UIKit
import SDWebImage
import DropDown
import NicoProgress

class WallCell: UITableViewCell, CheckBoxDelegate {
    
    var postData: PostData!
    let dropDown = DropDown()
    
    @IBOutlet weak var commentersImageContainer: UIView!
    
    var isCellInPostDetailVC: Bool = false
    
    @IBOutlet weak var optionOneWidthConst: NSLayoutConstraint!
    @IBOutlet weak var optionTwoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var optionThreeWidthConst: NSLayoutConstraint!
    @IBOutlet weak var optionFourWidthConst: NSLayoutConstraint!
    @IBOutlet weak var optionFiveWidthConst: NSLayoutConstraint!
    
    var imagesContainer: UIView?
    
    @IBOutlet weak var favoriteCheckbox: CheckBox!
    @IBOutlet weak var likeCountText: UILabel!
    @IBOutlet weak var dislikeCountText: UILabel!
    @IBOutlet weak var laughCountText: UILabel!
    @IBOutlet weak var angryCountText: UILabel!
    
    @IBOutlet weak var actionViewHeghtConstraint: NSLayoutConstraint!
    
    var progressViewHeight: CGFloat = 45
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var postUserImageView: UIImageView!
    @IBOutlet weak var postUserName: UILabel!
    @IBOutlet weak var postGroupName: UILabel!
    @IBOutlet weak var postMainTitle: UILabel!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var commentCountText: UILabel!
    @IBOutlet weak var totalVotesCountText: UILabel!
    
    @IBOutlet weak var isDislikeCheckBox: CheckBox!
    @IBOutlet weak var isLikeCheckBox: CheckBox!
    @IBOutlet weak var isLaughCheckBox: CheckBox!
    @IBOutlet weak var isAngryCheckBox: CheckBox!
    
    
    @IBOutlet weak var optionNameOne: UILabel!
    @IBOutlet weak var progressOne: ProgressBar!
    @IBOutlet weak var optionPercentOne: UILabel!
    
    @IBOutlet weak var optionNameTwo: UILabel!
    @IBOutlet weak var progressTwo: ProgressBar!
    @IBOutlet weak var optionPercentTwo: UILabel!
    
    @IBOutlet weak var optionNameThree: UILabel!
    @IBOutlet weak var progressThree: ProgressBar!
    @IBOutlet weak var optionPercentThree: UILabel!
    
    @IBOutlet weak var optionNameFour: UILabel!
    @IBOutlet weak var progressFour: ProgressBar!
    @IBOutlet weak var optionPercentFour: UILabel!
    
    @IBOutlet weak var optionNameFive: UILabel!
    @IBOutlet weak var progressFive: ProgressBar!
    @IBOutlet weak var optionPercentFive: UILabel!
    
    @IBOutlet weak var progressOneHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressTwoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressThreeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressFourHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressFiveHeightConstraint: NSLayoutConstraint!
    
    var actionViewHeight: CGFloat = 80
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        favoriteCheckbox.delegate = self 
        isLikeCheckBox.delegate = self
        isDislikeCheckBox.delegate = self
        isLaughCheckBox.delegate = self
        isAngryCheckBox.delegate = self
        
        dropDown.anchorView = favoriteCheckbox
        dropDown.width = 150
        
        print(CFGetRetainCount(self))
        
        dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            if item == "Edit" {
                if self.postData.isPoll {
                    let vc = WallVC.shared?.storyboard?.instantiateViewController(withIdentifier: "editPollVC") as! EditPollVC
                    vc.postData = self.postData
                    vc.onEdited = self.receiveEditedPost
                    WallVC.shared?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = WallVC.shared?.storyboard?.instantiateViewController(withIdentifier: "editPostVC") as! EditPostVC
                    vc.postData = self.postData
                    vc.onEdited = self.receiveEditedPost
                    WallVC.shared?.navigationController?.pushViewController(vc, animated: true)
                }
            } else if item == "Delete" {
                Global.showConfirmDialog(vc: WallVC.shared!, title: "Delete Wall", message: "Are you sure you want delete?") {
                    ApiClient.deletePost(postId: self.postData.id) { result in
                        if result {
                            WallVC.shared?.loadData()
                        }
                    }
                }
            } else if item == "Report" {
                Global.showReportDialog { (reason) in
                    ApiClient.reportPost(postId: self.postData.id, reason: reason, finished: { (result) in
                        if result {
                            self.dropDown.dataSource = ["Already Reported"]
                        } else {
                            
                        }
                    })
                }
            }
        }
    }
    
    func receiveEditedPost(data: PostData) {
        print(data)
        setPostData(data: data)
    }
    
    override func prepareForReuse() {
        optionOneWidthConst.constant = 0
        optionTwoWidthConst.constant = 0
        optionThreeWidthConst.constant = 0
        optionFourWidthConst.constant = 0
        optionFiveWidthConst.constant = 0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func showMenu() {
        dropDown.show()
    }
    
    func hideMenu() {
        dropDown.hide()
    }
    
    func setPostData(data: PostData) {
        self.postData = data
        bindData()
    }
    
    func setReactions() {
        isLikeCheckBox.setUnCheck()
        isDislikeCheckBox.setUnCheck()
        isLaughCheckBox.setUnCheck()
        isAngryCheckBox.setUnCheck()
        
        likeCountText.text = "\(postData.postLikeCount!)"
        dislikeCountText.text = "\(postData.postDislikeCount!)"
        laughCountText.text = "\(postData.postLaughCount!)"
        angryCountText.text = "\(postData.postAngryCount!)"
        
        switch postData.userReaction {
        case 0:      // like
            isLikeCheckBox.setCheck()
            break
        case 1:      // dislike
            isDislikeCheckBox.setCheck()
            break
        case 2:      // laugh
            isLaughCheckBox.setCheck()
            break
        case 5:      // angry
            isAngryCheckBox.setCheck()
            break
        default:
            break
        }
    }
    
    func bindData() {
        let url = postData.user.profileImage
        let userId = SessionManager.getUserId()
        let userId2 = postData.userID
        
        // more action button
        if userId == userId2 {     // if current post is my post
            dropDown.dataSource = ["Edit", "Delete"]
        } else {                   // if current post is not my post
            if postData.isReported {    // if current post is already reported
                dropDown.dataSource = ["Already Reported"]
            } else {
                dropDown.dataSource = ["Report"]
            }
        }
        
        if postData.isFavorite {
            favoriteCheckbox.setCheck()
        } else {
            favoriteCheckbox.setUnCheck()
        }
        
        if userId == userId2 {
            if postData.userAs == 1 {
                postUserImageView.image = UIImage(named: "ic_anonymous_avatar")
                postUserName.text = "Anonymous"
            } else {
                postUserImageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "ic_anonymous_avatar"))
                postUserName.text = "Me"
            }
        } else if(postData.userAs != 1) {
            postUserImageView.sd_setImage(with: URL(string: url!), placeholderImage: UIImage(named: "ic_anonymous_avatar"))
            postUserName.text = postData.user.fullName
        } else {
            postUserImageView.image = UIImage(named: "ic_anonymous_avatar")
            postUserName.text = "Anonymous"
        }
        
        postGroupName.text = postData.postGroupName
        postMainTitle.text = postData.comment
        postDate.text = DateUtils.convertDate( dateString: postData.createdAt)
        
        initialzieCommentUserImages()
        
        if postData.allowcomment != 1 {
            commentCountText.text = "\(postData.totalComments ?? 0)"
            commentImageView.image = UIImage(named: "ic_comment")
            addCommentUserImage()
        } else {
            commentCountText.text = ""
            commentImageView.image = UIImage(named: "ic_disable_comments_icon")
        }
        
        setReactions()
        
        progressOneHeightConstraint.constant = 0
        progressTwoHeightConstraint.constant = 0
        progressThreeHeightConstraint.constant = 0
        progressFourHeightConstraint.constant = 0
        progressFiveHeightConstraint.constant = 0
        totalVotesCountText.text = ""
        
        if postData.postOptionsList.count > 0 {
            totalVotesCountText.text = "\(postData.totalPollVotes!) Votes"
            for userId in 0...postData.postOptionsList.count-1 {
                
                let progress = calcProgressVotes(totalPollVotes: postData.totalPollVotes, postVotesCount: postData.postOptionsList[userId].postVotesCount)
                var progressValue: CGFloat = CGFloat(progress)
                progressValue = progressValue/100
                print(progressValue)
                
                
                if(userId == 0) {
                    if postData.postOptionsList[userId].myVote == nil {
                        optionNameOne.text = postData.postOptionsList[userId].name
                    } else {
                        optionNameOne.text = postData.postOptionsList[userId].name + " (my vote)"
                    }
                    if isCellInPostDetailVC && !postData.isVoted && postData.user.id != SessionManager.getUserId() {
                        optionOneWidthConst.constant = 30
                    } else {
                        optionOneWidthConst.constant = 0
                    }
                    //                    nicroProgressOne.transition(to: .determinate(percentage: CGFloat(progressValue)))
                    progressOne.progress = progress
                    progressOneHeightConstraint.constant = progressViewHeight
                    optionPercentOne.text = "\(progress)%"
                }
                else if(userId == 1) {
                    if postData.postOptionsList[userId].myVote == nil {
                        optionNameTwo.text = postData.postOptionsList[userId].name
                    } else {
                        optionNameTwo.text = postData.postOptionsList[userId].name + " (my vote)"
                    }
                    
                    if isCellInPostDetailVC && !postData.isVoted  && postData.user.id != SessionManager.getUserId() {
                        optionTwoWidthConst.constant = 30
                    } else {
                        optionTwoWidthConst.constant = 0
                    }
                    //                    nicoProgressTwo.transition(to: .determinate(percentage: CGFloat(progressValue)))
                    progressTwo.progress = progress
                    progressTwoHeightConstraint.constant = progressViewHeight
                    optionPercentTwo.text = "\(progress)%"
                } else if(userId == 2) {
                    if postData.postOptionsList[userId].myVote == nil {
                        optionNameThree.text = postData.postOptionsList[userId].name
                    } else {
                        optionNameThree.text = postData.postOptionsList[userId].name + " (my vote)"
                    }
                    if isCellInPostDetailVC && !postData.isVoted && postData.user.id != SessionManager.getUserId() {
                        optionThreeWidthConst.constant = 30
                    } else {
                        optionThreeWidthConst.constant = 0
                    }
                    //                    nicoProgressThree.transition(to: .determinate(percentage: CGFloat(progressValue)))
                    progressThree.progress = progress
                    progressThreeHeightConstraint.constant = progressViewHeight
                    optionPercentThree.text = "\(progress)%"
                } else if(userId == 3) {
                    if postData.postOptionsList[userId].myVote == nil {
                        optionNameFour.text = postData.postOptionsList[userId].name
                    } else {
                        optionNameFour.text = postData.postOptionsList[userId].name + " (my vote)"
                    }
                    if isCellInPostDetailVC && !postData.isVoted && postData.user.id != SessionManager.getUserId() {
                        optionFourWidthConst.constant = 30
                    } else {
                        optionFourWidthConst.constant = 0
                    }
                    //                    nicoProgressFour.transition(to: .determinate(percentage: CGFloat(progressValue)))
                    progressFour.progress = progress
                    progressFourHeightConstraint.constant = progressViewHeight
                    optionPercentFour.text = "\(progress)%"
                } else if(userId == 4) {
                    if postData.postOptionsList[userId].myVote == nil {
                        optionNameFive.text = postData.postOptionsList[userId].name
                    } else {
                        optionNameFive.text = postData.postOptionsList[userId].name + " (my vote)"
                    }
                    if isCellInPostDetailVC && !postData.isVoted && postData.user.id != SessionManager.getUserId() {
                        optionFiveWidthConst.constant = 30
                    } else {
                        optionFiveWidthConst.constant = 0
                    }
                    //                    nicoProgressFive.transition(to: .determinate(percentage: CGFloat(progressValue)))
                    progressFiveHeightConstraint.constant = progressViewHeight
                    progressFive.progress = progress
                    optionPercentFive.text = "\(progress)%"
                }
            }
        }
    }
    
    func initialzieCommentUserImages() {
        imagesContainer?.removeFromSuperview()
        imagesContainer = UIView(frame: CGRect(x: 0, y: 0, width: commentersImageContainer.frame.width, height: commentersImageContainer.frame.height))
        commentersImageContainer.addSubview(imagesContainer!)
    }
    
    func addCommentUserImage() {
        let commentUserAvatarList = postData.commentUserAvatarList
        commentImageView.clipsToBounds = true
        
        if commentUserAvatarList?.count == 0 {
            return
        }
        
        let interval: CGFloat = 15
        for index in 0..<(commentUserAvatarList?.count)!{
            var imageView = UIImageView(frame: CGRect(x: CGFloat(index-1)*interval, y: 0, width: 20, height: 20))
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.sd_setImage(with: URL(string: commentUserAvatarList![index].imageURL), placeholderImage: UIImage(named: "ic_anonymous_avatar"))
            imagesContainer!.addSubview(imageView)
        }
    }
    
    @IBAction func onMoreActionButtonClicked(_ sender: Any) {
        showMenu()
    }
    
    @IBAction func onAvatarClick(_ sender: Any) {
        if postData.userAs != 1 && SessionManager.getUserId() != postData.userID {
            let user = postData.user
            showCustomDialog(userId: postData.userID, imageUrl: (user?.profileImage)!, fullname: (user?.fullName)!, groupName: postData.postGroupName)
        } else if postData.userAs == 1 && SessionManager.getUserId() != postData.userID {
            Global.showToastMessage(msg: "Anonymous :)")
        }
    }
    
    func calcProgressVotes(totalPollVotes: Int, postVotesCount: Int) -> Int {
        if(totalPollVotes == 0) {
            return 0
        }
        return (postVotesCount * 100) / totalPollVotes ;
    }
    
    func showCustomDialog(userId: Int, imageUrl: String, fullname: String, groupName: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.showSendMessageDialog(userId: userId, username: fullname, userImage: imageUrl, groupname: groupName)
    }
    
    @IBAction func onVotedOnPoll(_ sender: DLRadioButton) {
        var optionId = 0
        switch sender.tag {
        case 901:   // First Option
            optionId = postData.postOptionsList[0].id
            break
        case 902:
            optionId = postData.postOptionsList[1].id
        break  // Second Option
        case 903:  // Third Option
            optionId = postData.postOptionsList[2].id
            break
        case 904:  // Fourth Option
            optionId = postData.postOptionsList[3].id
            break
        case 905:  //Fifth Option
            optionId = postData.postOptionsList[4].id
            break
        default:
            break
        }
        
        ApiClient.voteOnPoll(optionId: optionId, postId: postData.id) { result in
            if result {
                DispatchQueue.main.async {
                    self.optionOneWidthConst.constant = 0
                    self.optionTwoWidthConst.constant = 0
                    self.optionThreeWidthConst.constant = 0
                    self.optionFourWidthConst.constant = 0
                    self.optionFiveWidthConst.constant = 0
                    UIView.animate(withDuration: 0.1) {
                        self.layoutIfNeeded()
                    }
                }
                PostDetailVC.shared?.loadCommentsAndPost()
            }
        }
    }
    
    
    func checkBoxStatusChanged(checkBox: CheckBox, isChecked: Bool) {
        switch checkBox.tag {
        case 500:  // favorite
            if isChecked {
                postData.isFavorite = true
            } else {
                postData.isFavorite = false
            }
            ApiClient.setFavorite(postId: postData.id)
            break
        case 501:  // like checkbox
            if !isChecked {
                postData.postLikeCount = postData.postLikeCount - 1
                postData.userReaction = -1
            } else {
                if postData.userReaction != -1 {
                    switch postData.userReaction {
                    case 0:
                        postData.postLikeCount = postData.postLikeCount - 1
                        break
                    case 1:
                        postData.postDislikeCount = postData.postDislikeCount - 1
                        break
                    case 2:
                        postData.postLaughCount = postData.postLaughCount - 1
                        break
                    case 5:
                        postData.postAngryCount = postData.postAngryCount - 1
                        break
                    default:
                        break
                    }
                }
                postData.postLikeCount = postData.postLikeCount + 1
                postData.userReaction = 0
            }
            ApiClient.setPostReact(postId: postData.id, reactionType: 0)
            setReactions()
            break
        case 502:  // dislike checkbox
            if !isChecked {
                postData.postDislikeCount = postData.postDislikeCount - 1
                postData.userReaction = -1
            } else {
                if postData.userReaction != -1 {
                    switch postData.userReaction {
                    case 0:
                        postData.postLikeCount = postData.postLikeCount - 1
                        break
                    case 1:
                        postData.postDislikeCount = postData.postDislikeCount - 1
                        break
                    case 2:
                        postData.postLaughCount = postData.postLaughCount - 1
                        break
                    case 5:
                        postData.postAngryCount = postData.postAngryCount - 1
                        break
                    default:
                        break
                    }
                }
                postData.postDislikeCount = postData.postDislikeCount + 1
                postData.userReaction = 1
            }
            
            ApiClient.setPostReact(postId: postData.id, reactionType: 1)
            setReactions()
            break
        case 503:  // laugh checkbox
            if !isChecked {
                postData.postLaughCount = postData.postLaughCount - 1
                postData.userReaction = -1
            } else {
                if postData.userReaction != -1 {
                    switch postData.userReaction {
                    case 0:
                        postData.postLikeCount = postData.postLikeCount - 1
                        break
                    case 1:
                        postData.postDislikeCount = postData.postDislikeCount - 1
                        break
                    case 2:
                        postData.postLaughCount = postData.postLaughCount - 1
                        break
                    case 5:
                        postData.postAngryCount = postData.postAngryCount - 1
                        break
                    default:
                        break
                    }
                }
                postData.postLaughCount = postData.postLaughCount + 1
                postData.userReaction = 2
            }
            
            ApiClient.setPostReact(postId: postData.id, reactionType: 2)
            setReactions()
            break
        case 504:  // angry checkbox
            if !isChecked {
                postData.postAngryCount = postData.postAngryCount - 1
                postData.userReaction = -1
            } else {
                if postData.userReaction != -1 {
                    switch postData.userReaction {
                    case 0:
                        postData.postLikeCount = postData.postLikeCount - 1
                        break
                    case 1:
                        postData.postDislikeCount = postData.postDislikeCount - 1
                        break
                    case 2:
                        postData.postLaughCount = postData.postLaughCount - 1
                        break
                    case 5:
                        postData.postAngryCount = postData.postAngryCount - 1
                        break
                    default:
                        break
                    }
                }
                postData.postAngryCount = postData.postAngryCount + 1
                postData.userReaction = 5
            }
            
            ApiClient.setPostReact(postId: postData.id, reactionType: 5)
            setReactions()
            break
        default:
            break
        }
    }
}
