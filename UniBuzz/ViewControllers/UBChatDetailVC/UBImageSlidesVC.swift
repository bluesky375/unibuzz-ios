//
//  UBImageSlidesVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 25/09/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage
  

class UBImageSlidesVC: UIViewController {
    @IBOutlet weak var imgOfSlider: ImageSlideshow!
    var listOfReceiverFile : AllMessages?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    //    imgOfSlider.slideshowInterval = 3.0
    //    imgOfSlider.pageIndicatorPosition = .init(horizontal: .center, vertical: .under)
    //    imgOfSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
//        let pageControl = UIPageControl()
//        pageControl.currentPageIndicatorTintColor = UIColor(red: 103/255.0, green: 114/255.0, blue: 229/255.0, alpha: 1.0)
//        pageControl.pageIndicatorTintColor = UIColor.lightGray
//        imgOfSlider.pageIndicator = pageControl
//        imgOfSlider.activityIndicator = DefaultActivityIndicator()
//        imgOfSlider.contentScaleMode = UIView.ContentMode.scaleToFill
//        imgOfSlider.clipsToBounds = true
//        imgOfSlider.activityIndicator = DefaultActivityIndicator()

        var sdWebImages = [SDWebImageSource]()
        imgOfSlider.zoomEnabled = true 
        if listOfReceiverFile?.message_files?.count == 0 {
            for (_ , obj) in ((listOfReceiverFile?.parent_message?.messageFile?.enumerated())!) {
                  let imageName = obj.file_path
                  sdWebImages.append(SDWebImageSource(urlString: imageName!)!)
            }
            imgOfSlider.setImageInputs(sdWebImages)
        } else {
                for (_ , obj) in ((listOfReceiverFile?.message_files?.enumerated())!) {
                  let imageName = obj.file_path
                  sdWebImages.append(SDWebImageSource(urlString: imageName!)!)
            }
            imgOfSlider.setImageInputs(sdWebImages)
            
        }

        
    }

}
