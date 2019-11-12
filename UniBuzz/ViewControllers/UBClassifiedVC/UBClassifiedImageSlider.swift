//
//  UBClassifiedImageSlider.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 02/10/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage


class UBClassifiedImageSlider: UIViewController {
    
    @IBOutlet weak var imgOfSlider: ImageSlideshow!
    var classified : ClassifiedPost?
    private var slideImage : [String] = []
    @IBOutlet weak var lblClassifiedTitle : UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
            lblClassifiedTitle.text = classified?.postTitle
          imgOfSlider.slideshowInterval = 3.0
          imgOfSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
          imgOfSlider.contentScaleMode = UIView.ContentMode.scaleToFill
          let pageControl = UIPageControl()
          pageControl.currentPageIndicatorTintColor = UIColor(red: 103/255.0, green: 114/255.0, blue: 229/255.0, alpha: 1.0)
          pageControl.pageIndicatorTintColor = UIColor.lightGray
          imgOfSlider.pageIndicator = pageControl
          imgOfSlider.activityIndicator = DefaultActivityIndicator()
          imgOfSlider.contentScaleMode = UIView.ContentMode.scaleToFill
          imgOfSlider.clipsToBounds = true
          imgOfSlider.zoomEnabled = true
          imgOfSlider.activityIndicator = DefaultActivityIndicator()
            
        
                                    slideImage.append(classified!.postImage!)

                                   var sdWebImages = [SDWebImageSource]()
                                   let imgPAth = classified!.image_path
                                
            //                    var sdWebImages = [SDWebImageSource]()
            //                    let imgPAth = classified!.image_path
                                    for (_ , obj) in ((self.classified?.postImages?.enumerated())!) {
                                        slideImage.append(obj.name!)
                                    }
                                
                                    for(_ , imgName) in self.slideImage.enumerated() {
                                        let imgFullUrl = "\(imgPAth!)/\(imgName)"
                                        sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
                                    }

//          var sdWebImages = [SDWebImageSource]()
//          let imgPAth = classified!.image_path
//          let postImage = self.classified?.postImage
//          let imgFullUrls = "\(imgPAth!)/\(postImage!)"
//          sdWebImages.append(SDWebImageSource(urlString: imgFullUrls)!)
////                        slideImage.append(classified!.postImage!)
//
//            //            if self.classified?.postImage?.count == 0 {
//            //            }  else
//            for (_ , obj) in ((self.classified?.postImages?.enumerated())!) {
//              let imgFullUrl = "\(imgPAth!)/\(obj.name!)"
//               sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//             }
//
//          var sdWebImages = [SDWebImageSource]()
//          let imgPAth = classified!.image_path
//
//          if (self.classified?.postImages!.count)! > 0 {
//              for (_ , obj) in ((self.classified?.postImages?.enumerated())!) {
//                  let imageName = obj.name
//                  let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//
//                  sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//              }
//          } else {
//              let imageName = classified?.postImage
//              let imgFullUrl = "\(imgPAth!)/\(imageName!)"
//
//              sdWebImages.append(SDWebImageSource(urlString: imgFullUrl)!)
//
//          }
        
          imgOfSlider.setImageInputs(sdWebImages)

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
