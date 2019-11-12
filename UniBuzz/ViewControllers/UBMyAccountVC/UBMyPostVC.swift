//
//  UBMyPostVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 30/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
  

class UBMyPostVC: UIViewController {
    @IBOutlet weak var tblViewss: UITableView!
    var index: Int?
    var userFeeds : UserResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tblViewss.registerCells([
            PostCell.self , PollingPostCell.self
            ])
        
    }


    func getAllMyPost() {
        WebServiceManager.get(params: nil, serviceName: USERWALL, serviceType: "User Feed".localized(), modelType: UserResponse.self, success: { (response) in
            
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

extension UBMyPostVC : UITableViewDelegate , UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var numOfSections: Int = 0
        if  self.userFeeds?.feeds?.post?.feedsObject!.isEmpty == false {
            numOfSections = 1
            tblViewss.backgroundView = nil
        }
        else {
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: tblViewss.bounds.size.width, height: tblViewss.bounds.size.height))
            noDataLabel.numberOfLines = 10
            if let aSize = UIFont(name: "Axiforma-Book", size: 14) {
                noDataLabel.font = aSize
            }
            noDataLabel.text = "There are currently no Feeds in your wall.".localized()
            noDataLabel.textColor = UIColor.lightGray
            noDataLabel.textAlignment = .center
            tblViewss.backgroundView = noDataLabel
            tblViewss.separatorStyle = .none
        }
        return numOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFeeds?.feeds?.post?.feedsObject?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count != 0 {
            let cell = tableView.dequeueReusableCell(with: PollingPostCell.self, for: indexPath)
            //
            
            
            cell.lblNAme.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.full_name
            cell.lblUni.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_group_name
            cell.lblDate.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].created_at
            
            cell.lblPost.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
            let totalComment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].total_comments
            let likeCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_like_count
            let disLike = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_dislike_count
            let launghCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_laugh_count
            let angry = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_angry_count
            let vote = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].total_poll_votes
            
            
            cell.lblLikeCount.text = "\(likeCount!)"
            cell.lblDislikeCount.text = "\(disLike!)"
            cell.lblHappy.text = "\(launghCount!)"
            //            cell.lblAngry.text = "\(angry!)"
            
//            cell.delegate = self
//            cell.index = indexPath
            if angry != nil {
                cell.lblAngry.text = "\(angry!)"
            } else {
                cell.lblAngry.text = "0".localized()
            }
            
            if vote != nil {
                cell.lblTotalVoteCast.text = "\(vote!)" + " Vote".localized()
            } else {
                cell.lblTotalVoteCast.text = "0".localized() + " Vote".localized()
            }
            
            if totalComment != nil {
                cell.btnComment.setTitle("\(totalComment!)", for: .normal)
            } else {
                cell.btnComment.setTitle("0".localized(), for: .normal)
            }
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 2 {
                cell.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                
                let totalVoteCountOfFirstsss = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                let totalVoteCountOfFirstssssss  = Float(totalVoteCountOfFirstsss) / 100
                
                cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstssssss))
                
                let totalVoteCountSecondss = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                let totalVoteCountSecondsssss  = Float(totalVoteCountSecondss) / 100
                cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondsssss))
                
                
                cell.lblThirdPollQuestion.isHidden = true
                cell.lblFourthQuestion.isHidden = true
                
                cell.progressOfThidPoll.isHidden = true
                cell.progressOfFourthPoll.isHidden = true
                
                
            }
            
            if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 3 {
                
                cell.lblThirdPollQuestion.isHidden = false
                cell.lblFourthQuestion.isHidden = true
                
                cell.progressOfThidPoll.isHidden = false
                cell.progressOfFourthPoll.isHidden = true
                
                cell.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                cell.lblThirdPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].name
                
                let totalVoteCountOfFirst = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                
                let totalVoteCountOfFirstsss  = Float(totalVoteCountOfFirst) / 100
                cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss))
                let totalVoteCountSecond = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                let totalVoteCountSecondssss  = Float(totalVoteCountSecond) / 100
                cell.progressOfSecondPoll.animateTo(progress: CGFloat(totalVoteCountSecondssss))
                
                let totalVoteCount = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].post_votes_count)!
                let totalVoteCountsss  = Float(totalVoteCount) / 100
                cell.progressOfThidPoll.animateTo(progress: CGFloat(totalVoteCountsss))
                
            } else  if self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption?.count == 4 {
                
                cell.lblThirdPollQuestion.isHidden = false
                cell.lblFourthQuestion.isHidden = false
                
                cell.progressOfThidPoll.isHidden = false
                cell.progressOfFourthPoll.isHidden = false
                
                cell.lblFirstPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].name
                cell.lblSecondPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].name
                cell.lblThirdPollQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].name
                cell.lblFourthQuestion.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![3].name
                
                let totalVoteCountOfFirst = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![0].post_votes_count)!
                let totalVoteCountOfFirstsss  = Float(totalVoteCountOfFirst) / 100
                cell.progressOfFirstPoll.animateTo(progress: CGFloat(totalVoteCountOfFirstsss))
                
                let totalVoteCountSecond = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![1].post_votes_count)!
                
                let totaVoteCountSecondss  = Float(totalVoteCountSecond) / 100
                
                cell.progressOfSecondPoll.animateTo(progress: CGFloat(totaVoteCountSecondss))
                
                let totalVoteCount = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![2].post_votes_count)!
                let totalVoteCountsss  = Float(totalVoteCount) / 100
                cell.progressOfThidPoll.animateTo(progress: CGFloat(totalVoteCountsss))
                
                let totalVoteCountss = (self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].postOption![3].post_votes_count)!
                let totalVoteCountssssss  = Float(totalVoteCountss) / 100
                cell.progressOfFourthPoll.animateTo(progress: CGFloat(totalVoteCountssssss))
                
            }
            
            guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.profile_image  else   {
                return cell
            }
            WAShareHelper.loadImage(urlstring:image , imageView: (cell.imgOfUser!), placeHolder: "profile2")
            let cgFloat: CGFloat = cell.imgOfUser.frame.size.width/2.0
            let someFloat = Float(cgFloat)
            WAShareHelper.setViewCornerRadius(cell.imgOfUser, radius: CGFloat(someFloat))
            
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(with: PostCell.self, for: indexPath)
            cell.lblNAme.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.full_name
            cell.lblUni.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_group_name
            cell.lblDate.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].created_at
            
            cell.lblPost.text = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].comment
            let totalComment = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].total_comments
            let likeCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_like_count
            let disLike = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_dislike_count
            let launghCount = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_laugh_count
            let angry = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].post_angry_count
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
            guard  let image = self.userFeeds?.feeds?.post?.feedsObject![indexPath.row].user?.profile_image  else   {
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
    

}
