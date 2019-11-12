//
//  WAShareHelper.swift
//  WhereApp
//
//  Created by Salman on 24/05/2017.
//  Copyright © 2017 Salman. All rights reserved.
//

import UIKit
import SDWebImage
import UserNotifications
import PKRevealController
import SlideMenuControllerSwift
  
let notificationCenter = UNUserNotificationCenter.current()

class WAShareHelper: NSObject {


    class func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    class func loadImage(urlstring: String, imageView: UIImageView , placeHolder : String) {
        imageView.setShowActivityIndicator(true)
        imageView.setIndicatorStyle(.gray)
        imageView.sd_setImage(with: URL(string: urlstring), placeholderImage: UIImage(named: placeHolder))
        
        
    }
    class func loadImageWithCompletion(urlstring: String, showLoader: Bool, imageView: UIImageView, completion: @escaping (_ image: UIImage?) -> Void) {
        imageView.setShowActivityIndicator(true)
        imageView.setIndicatorStyle(.gray)
        
        let block: SDWebImageCompletionBlock! = ({(image, error, cacheType, imageURL) -> Void in
            completion(image)
        })
        imageView.sd_setImage(with: URL(string: urlstring), completed: block)
        
    }
    
    class func setBorderAndCornerRadius(layer: CALayer, width: CGFloat, radius: CGFloat,color : UIColor ) {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
   class  func addToNotificationCenter(request: UNNotificationRequest!) {

        notificationCenter.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
//                APIManager.sharedInstance.customPOP(isError: true, message: "Error message try again")
                print("Error message try again")
            }else {
                //                APIManager.sharedInstance.customPOP(isError: false, message: "Notification successfuly added")
                print("Notification successfuly added")

            }
        }
    }
    
    class func getFormattedDate(string: String) -> String {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy h:mm a"
        let date: Date? = dateFormatterGet.date(from: string)
        return dateFormatterPrint.string(from: date!);
    }
    
    class func getFormattedDateOnDate(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd "
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        let date: Date? = dateFormatterGet.date(from: string)
        //        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
    
    class func getFormattedDateNotTime(string: String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM yyyy"
        
        let date: Date? = dateFormatterGet.date(from: string)
        //        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }

    
    
    class func getFormattedDate(from: String) -> Date {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        return dateFormatterGet.date(from: from)!
        //        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        //        return dateFormatterPrint.string(from: date!);
    }
    
    class func getFormattedDate2(string: Date) -> String {
        
        //        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: string)) else {
        //            fatalError("Failed to strip time from Date object")
        //        }
        //        return String(describing: date)
        
        
        
        let dateString = String(describing: string)
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss z"
        
        let dateFormatterPrint = DateFormatter()
        
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        let date: Date? = dateFormatterPrint.date(from: dateString)
        //        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }

    class func postImageHeight(serverSideHeight: Double , serverSidewidth:Double, width: CGFloat) -> CGFloat{
        var rHeight = Double(0)
        let rWidth = Double(width)
        if(serverSideHeight == 0 ){
            rHeight = Double((width) * 0.37)
        }else{
            rHeight = (serverSideHeight/serverSidewidth) * rWidth
        }
        return CGFloat(rHeight)
    }

  
    class func getFromUserDefault(key: String) -> String {
        let defaults = UserDefaults.standard
        guard defaults.object(forKey: key) == nil else {
            return defaults.object(forKey: key) as! String
        }
        return ""
    }
    class func setViewCornerRadius(_ view: UIView, radius: CGFloat) {
        view.layer.cornerRadius = radius
        view.layer.masksToBounds = true
    }
    
    class func goToHomeController(vcIdentifier: String, storyboardName: String, navController: UINavigationController?, leftMenuIdentifier: String) {
        let mainStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let homeVC = self.getViewController(from: storyboardName, with: vcIdentifier)
        let menuVC = mainStoryboard.instantiateViewController(withIdentifier: leftMenuIdentifier)
        let homeNavigation = UINavigationController(rootViewController: homeVC)
        var slideMenuController: SlideMenuController!
        if AppDelegate.isArabic() {
            slideMenuController = SlideMenuController(mainViewController: homeNavigation, rightMenuViewController: menuVC)
        } else {
            slideMenuController = SlideMenuController(mainViewController: homeNavigation, leftMenuViewController: menuVC)
        }
        if let window = UIApplication.shared.windows.first {
            UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                window.rootViewController = slideMenuController
            }, completion: nil)
        }
    }
    
    class func goToHomeController(with vc: UIViewController) {
        
        let mainStoryboard = UIStoryboard(name: "Home", bundle: Bundle.main)
        let homeVC = vc
        let menuVC = mainStoryboard.instantiateViewController(withIdentifier: "UBSideMenuVC")
        let homeNavigation = UINavigationController(rootViewController: homeVC)
        let slideMenuController = SlideMenuController(mainViewController: homeNavigation, leftMenuViewController: menuVC)
//        let menuController = PKRevealController(frontViewController: homeNavigation, leftViewController: menuVC)
//        menuController?.recognizesPanningOnFrontView = false
        
        UIApplication.shared.keyWindow?.rootViewController = slideMenuController
    }
    
    class func getViewController(from storyboard: String, with indentifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboard, bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: indentifier)
        
        return vc
    }
    

    
    class func compressImageWithAspectRatio (image: UIImage) -> Data {

        let data = image.jpegData(compressionQuality: 0.0)
        let bcf = ByteCountFormatter()
        bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
        bcf.countStyle = .file
        let string = bcf.string(fromByteCount: Int64(data!.count))
        print("Data size is: \(string)")
        var separatedString = string.components(separatedBy: " ")
        print(separatedString)
        let dataLenth = separatedString[0]
        //let removedComma = dataLenth.stringByReplacingOccurrencesOfString(",", withString: "")
        let removedComma = dataLenth.replacingOccurrences(of: ",", with: "")
        print(Int(removedComma)!)
        
        
        if(Int(removedComma)! > 200 ){
            let actualHeight:CGFloat = image.size.height
            let actualWidth:CGFloat = image.size.width
            let imgRatio:CGFloat = actualWidth/actualHeight
            let maxWidth:CGFloat = 1440.0
            let resizedHeight:CGFloat = maxWidth/imgRatio
            let compressionQuality:CGFloat = 0.5
            
            let rect:CGRect = CGRect(x: 0, y: 0, width: maxWidth, height: resizedHeight)
            UIGraphicsBeginImageContext(rect.size)
            //image.drawInRect(rect)
            image.draw(in: rect)
            let img: UIImage = UIGraphicsGetImageFromCurrentImageContext()!

            let imageData = img.jpegData(compressionQuality: 0.5)

//            let imageData = UIImageJPEGRepresentation(img, compressionQuality)!
            UIGraphicsEndImageContext()
            print("Data size is: \(imageData?.count)")
            let bcf = ByteCountFormatter()
            bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
            bcf.countStyle = .file
//            let string = bcf.string(fromByteCount: Int64(imageData))
////            let string = bcf.string(fromByteCount: Int64(imageData?.count))
//            print("Data size is: \(string)")
            return imageData!
            
        } else{
            return data!
        }
        
        //return UIImage(data: imageData)!
        
    }
    
    
    class  func timeAgoSinceDate(_ date:Date, numericDates:Bool = false) -> String? {
        let calendar = NSCalendar.current
        let unitFlags: Set<Calendar.Component> = [.minute, .hour, .day, .weekOfYear, .month, .year, .second]
        let now = Date()
        let earliest = now < date ? now : date
        let latest = (earliest == now) ? date : now
        let components = calendar.dateComponents(unitFlags, from: earliest,  to: latest)
        
        if (components.year! >= 2) {
            return "\(components.year!)yr"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1yr".localized()
            } else {
                return "Last year".localized()
            }
        } else if (components.month! >= 2) {
            return "\(components.month!)mo"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 mo".localized()
            } else {
                return "Last mo".localized()
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week".localized()
            } else {
                return "Last week".localized()
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) d"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 d".localized()
            } else {
                return "1 d".localized()
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hrs"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hr".localized()
            } else {
                return "1 hr".localized()
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) m"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 m".localized()
            } else {
                return "2 m".localized()
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "seconds".localized()
        }
        
    }

    
    
    
}
