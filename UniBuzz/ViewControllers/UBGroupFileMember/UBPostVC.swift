//
//  UBPostVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 27/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBPostVC: UIViewController {
    
    @IBOutlet weak var tblViewss: UITableView!
    var index: Int?
    var groupObj : GroupList?
    var userFeeds : UserResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblViewss.registerCells([
            PostCell.self , PollingPostCell.self
            ])
        getAllGroupPostList()
        // Do any additional setup after loading the view.
    }
    
    func getAllGroupPostList() {
        let groupId = groupObj?.id
        let serviceUrl = "\(GROUPVIEW)\(groupId!)"
        WebServiceManager.get(params: nil, serviceName: serviceUrl, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
            
            self.userFeeds = (response as! UserResponse)
            if self.userFeeds?.status == true {
                self.tblViewss.delegate = self
                self.tblViewss.dataSource = self
                self.tblViewss.reloadData()
                //                self.refreshControl.stopAnimating()
            } else {
                self.showAlert(title: KMessageTitle, message: (self.userFeeds?.message!)!, controller: self)
            }
        }) { (error) in
            
        }
    }


}

extension UBPostVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  self.userFeeds?.groupPost?.post?.groupList?.isEmpty == false {
            numOfSections = 1
            tblViewss.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Post in your wall.".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tblViewss.backgroundView = noDataLabel
            tblViewss.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFeeds?.groupPost?.post?.groupList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption?.count != 0 {
            let cell = tableView.dequeueReusableCell(with: PollingPostCell.self, for: indexPath)
            //
            
            
            cell.lblNAme.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].user?.full_name
            cell.lblUni.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_group_name
            cell.lblDate.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].created_at
            
            cell.lblPost.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].comment
            let totalComment = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].total_comments
            let likeCount = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_like_count
            let disLike = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_dislike_count
            let launghCount = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_laugh_count
            let angry = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_angry_count
            let vote = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].total_poll_votes
            
            
            cell.lblLikeCount.text = "\(likeCount!)"
            cell.lblDislikeCount.text = "\(disLike!)"
            cell.lblHappy.text = "\(launghCount!)"
            
//            cell.delegate = self
//            cell.index = indexPath
            if angry != nil {
                cell.lblAngry.text = "\(angry!)"
            } else {
                cell.lblAngry.text = "0".localized()
            }
            
            if vote != nil {
                cell.lblTotalVoteCast.text = "\(vote!)".localized() + " Vote"
            } else {
                cell.lblTotalVoteCast.text = "0".localized() + " Vote".localized()
            }
            
            if totalComment != nil {
                cell.btnComment.setTitle("\(totalComment!)", for: .normal)
            } else {
                cell.btnComment.setTitle("0".localized(), for: .normal)
            }
            
            if self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption?.count == 2 {
                cell.lblFirstPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![0].name
                cell.lblSecondPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![1].name
                
                let totalVoteCountOfFirstsss = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![0].post_votes_count)!
                let totalVoteCountOfFirstssssss  = Float(totalVoteCountOfFirstsss) / 100
                
                cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstssssss))
                
                let totalVoteCountSecondss = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![1].post_votes_count)!
                let totalVoteCountSecondsssss  = Float(totalVoteCountSecondss) / 100
                cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondsssss))
                
                
                cell.lblThirdPollQuestion.isHidden = true
                cell.lblFourthQuestion.isHidden = true
                
                cell.progressOfThidPoll.isHidden = true
                cell.progressOfFourthPoll.isHidden = true
                
                
            }
            
            if self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption?.count == 3 {
                
                cell.lblThirdPollQuestion.isHidden = false
                cell.lblFourthQuestion.isHidden = true
                
                cell.progressOfThidPoll.isHidden = false
                cell.progressOfFourthPoll.isHidden = true
                
                cell.lblFirstPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![0].name
                cell.lblSecondPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![1].name
                cell.lblThirdPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![2].name
                
                let totalVoteCountOfFirst = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![0].post_votes_count)!
                
                let totalVoteCountOfFirstsss  = Float(totalVoteCountOfFirst) / 100
                cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss))
                let totalVoteCountSecond = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![1].post_votes_count)!
                let totalVoteCountSecondssss  = Float(totalVoteCountSecond) / 100
                cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondssss))
                
                let totalVoteCount = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![2].post_votes_count)!
                let totalVoteCountsss  = Float(totalVoteCount) / 100
                cell.progressOfThidPoll.animateTo(progress: CGFloat(totalVoteCountsss))
                
            } else  if self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption?.count == 4 {
                
                cell.lblThirdPollQuestion.isHidden = false
                cell.lblFourthQuestion.isHidden = false
                
                cell.progressOfThidPoll.isHidden = false
                cell.progressOfFourthPoll.isHidden = false
                
                cell.lblFirstPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![0].name
                cell.lblSecondPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![1].name
                cell.lblThirdPollQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![2].name
                cell.lblFourthQuestion.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![3].name
                
                let totalVoteCountOfFirst = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![0].post_votes_count)!
                let totalVoteCountOfFirstsss  = Float(totalVoteCountOfFirst) / 100
                cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss))
                
                let totalVoteCountSecond = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![1].post_votes_count)!
                
                let totaVoteCountSecondss  = Float(totalVoteCountSecond) / 100
                
                cell.progressOfSecondPoll.animateTo(progress: CGFloat(totaVoteCountSecondss))
                
                let totalVoteCount = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![2].post_votes_count)!
                let totalVoteCountsss  = Float(totalVoteCount) / 100
                cell.progressOfThidPoll.animateTo(progress: CGFloat(totalVoteCountsss))
                
                let totalVoteCountss = (self.userFeeds?.groupPost?.post?.groupList![indexPath.row].postOption![3].post_votes_count)!
                let totalVoteCountssssss  = Float(totalVoteCountss) / 100
                cell.progressOfFourthPoll.animateTo(progress: CGFloat(totalVoteCountssssss))
                
            }
            
            guard  let image = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].user?.profile_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: PostCell.self, for: indexPath)
            cell.lblNAme.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].user?.full_name
            cell.lblUni.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_group_name
            cell.lblDate.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].created_at
            
            cell.lblPost.text = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].comment
            let totalComment = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].total_comments
            let likeCount = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_like_count
            let disLike = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_dislike_count
            let launghCount = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_laugh_count
            let angry = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].post_angry_count
            cell.lblLikeCount.text = "\(likeCount!)"
            cell.lblDislikeCount.text = "\(disLike!)"
            cell.lblHappy.text = "\(launghCount!)"
            
//            cell.delegate = self
//            cell.index = indexPath
            
            
            if angry != nil {
                cell.lblAngry.text = "\(angry!)"
            } else {
                cell.lblAngry.text = "0".localized()
            }
            
            
            if totalComment != nil {
                cell.btnComment.setTitle("\(totalComment!)", for: .normal)
            } else {
                cell.btnComment.setTitle("0".localized(), for: .normal)
            }
            guard  let image = self.userFeeds?.groupPost?.post?.groupList![indexPath.row].user?.profile_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
            
            
            return cell
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count != 0 {
            return 302.0
        } else {
            return 158.5
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "UBFeedDetailVC") as? UBFeedDetailVC
//        vc!.feedObj = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row]
//        vc!.userObj = self.userObj
//        self.navigationController?.pushViewController(vc!, animated: true)
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        if tblViewss.contentOffset.y >= tblViewss.contentSize.height  - tblViewss.contentSize.width  {
//
//            if isPageRefreshing == false {
//                isPageRefreshing = true
//                page = page + 1
//
//                if page <= numberOfPage! {
//                    DispatchQueue.global(qos: .userInitiated).async {
//                        self.makeRequest(pageSize: self.page)
//                        DispatchQueue.main.async {
//                            self.tblViewss.reloadData()
//                        }
//                    }
//
//                } else {
//                    print("Not true")
//                }
//            }
//
//
//
//        }
//    }
}
