//
//  UBBookSliderVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 08/10/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import ImageSlideshow
import SDWebImage

class UBBookSliderVC: UIViewController {
    @IBOutlet weak var imgOfSlider: ImageSlideshow!
    var slideImage : String?
    var defaultitle : String?
    @IBOutlet weak var lblTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = defaultitle
        var sdWebImages = [SDWebImageSource]()
         imgOfSlider.zoomEnabled = true
        imgOfSlider.activityIndicator = DefaultActivityIndicator()
                  imgOfSlider.contentScaleMode = UIView.ContentMode.scaleAspectFill
                  imgOfSlider.clipsToBounds = true
                  imgOfSlider.activityIndicator = DefaultActivityIndicator()
                  sdWebImages.append(SDWebImageSource(urlString: slideImage!)!)
                  imgOfSlider.setImageInputs(sdWebImages)
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
