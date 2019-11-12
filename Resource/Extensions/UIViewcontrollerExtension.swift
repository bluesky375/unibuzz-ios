//
//  UIViewcontrollerExtension.swift
//  WhereApp
//
//  Created by Salman Nasir on 10/03/2017.
//  Copyright © 2017 Ilsainteractive. All rights reserved.
//

import UIKit
import CoreLocation

//protocol popForviewController : class {
//    func AcceptButtonClick()
@objc //    func RejectButtonClick()
//}
//
//enum ToggleState {
//    case on
//    case off
//}



extension UIViewController {
    
    
    func showAlert(title: String, message: String, controller: UIViewController?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        if controller != nil {
            controller?.present(alert, animated: true, completion: nil)
        }else {
            present(alert, animated: true, completion: nil)
        }
        

    }
    
    func showConfirmationAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alertController.addAction(UIAlertAction(title: "NO", style: .cancel, handler: { action -> Void in
            //Do some other stuff
            
        }))
        alertController.addAction(UIAlertAction(title: "YES", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        present(alertController, animated: true, completion:nil)
    }

    
    func showAlertViewWithTitle(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Do some other stuff
//            dismissCompletion()
        }))
        
        present(alertController, animated: true, completion:nil)
    }

    func showAlertViewWithTitless(title:String,message : String, dismissCompletion:@escaping (AlertViewDismissHandler))
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            //Do some other stuff
            dismissCompletion()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
            //Do some other stuff
          dismissCompletion()
        }))
        
        present(alertController, animated: true, completion:nil)
    }

    
    @IBAction func popController(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    

    func pushToViewControllerWithStoryboardID(storyboardId:String) {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: storyboardId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    


    
//    func showAlertAppeareance() {
//        let appearance = SCLAlertView.SCLAppearance(
//            kTitleFont: UIFont(name: "HelveticaNeue", size: 20)!,
//            kTextFont: UIFont(name: "HelveticaNeue", size: 14)!,
//            kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 14)!,
//            showCloseButton: false,
//            dynamicAnimatorActive: true,
//            buttonsLayout: .horizontal
//        )
//        let alert = SCLAlertView(appearance: appearance)
//        _ = alert.addButton("YES", target:self, selector:#selector(UIViewController.firstButton))
//        _ = alert.addButton("NO", target:self, selector:#selector(UIViewController.secondButton))
//        let icon = UIImage(named:"logo")
//        let color = UIColor.orange
//
//        _ = alert.showCustom("Hot Shot", subTitle: ("Are you sure to cancel the booking" as? String)!, color: color, icon: icon!, circleIconImage: icon!)
//
//    }
//
//    @objc func firstButton() {
//
//    }
//
//    @objc func secondButton() {
//
//    }
}

extension UITextView : UITextViewDelegate
{
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = self.text.count > 0
        }
    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = self.text.count > 0
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
}


extension UITextField {
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
}


extension UITableView {
    func registerCells(_ cells: [UITableViewCell.Type]) {
        
        cells.forEach({ register(UINib(nibName: String(describing: $0), bundle: nil), forCellReuseIdentifier: String(describing: $0)) })
    }
    
    func registerHeaderFooter(_ headerFooter: [UITableViewHeaderFooterView.Type]) {
        headerFooter.forEach({ register(UINib(nibName: String(describing: $0), bundle: nil), forHeaderFooterViewReuseIdentifier: String(describing: $0)) })
    }
    
    func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        let cell = dequeueReusableCell(withIdentifier: String(describing: type), for: indexPath) as! T
        return cell
    }
    
    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(with type: T.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: String(describing: type)) as? T
    }
    
//    func scrollToBottomRow() {
//            DispatchQueue.main.async {
//                guard self.numberOfSections > 0 else { return }
//
//                // Make an attempt to use the bottom-most section with at least one row
//                var section = max(self.numberOfSections - 1, 0)
//                var row = max(self.numberOfRows(inSection: section) - 1, 0)
//                var indexPath = IndexPath(row: row, section: section)
//
//                // Ensure the index path is valid, otherwise use the section above (sections can
//                // contain 0 rows which leads to an invalid index path)
//                while !self.indexPathIsValid(indexPath) {
//                    section = max(section - 1, 0)
//                    row = max(self.numberOfRows(inSection: section) - 1, 0)
//                    indexPath = IndexPath(row: row, section: section)
//
//                    // If we're down to the last section, attempt to use the first row
//                    if indexPath.section == 0 {
//                        indexPath = IndexPath(row: 0, section: 0)
//                        break
//                    }
//                }
//
//                // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
//                // exception here
//                guard self.indexPathIsValid(indexPath) else { return }
//
//                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//      }
    
        func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
            let section = indexPath.section
            let row = indexPath.row
            return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
        }
    
    func scrollToBottomView(animated: Bool = true) {
        let section = self.numberOfSections
        if section > 0 {
            let row = self.numberOfRows(inSection: section - 1)
            if row > 0 {
                self.scrollToRow(at: NSIndexPath(row: row - 1, section: section - 1) as IndexPath, at: .bottom, animated: animated)
            }
        }
    }
    
    func scrollToBottom(){
        
//        let section = self.numberOfSections
//        let row = self.numberOfRows(inSection: self.numberOfSections - 1) - 1;
//        guard (section > 0) && (row > 0) else{ // check bounds
//            return
//        }
//        let indexPath = IndexPath(row: row - 1, section: section - 1)
//        self.scrollToRow(at: indexPath, at: .top, animated: true)
            DispatchQueue.main.async {
                let indexPath = IndexPath(
                    row: self.numberOfRows(inSection:  self.numberOfSections - 1 ) - 1,
                    section: self.numberOfSections - 1)
                self.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
        
        func scrollToTop() {
            
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: 0, section: 0)
                self.scrollToRow(at: indexPath, at: .top, animated: false)
            }
        }
    
    func reloadWithoutAnimation() {
        let lastScrollOffset = contentOffset
        beginUpdates()
        endUpdates()
        layer.removeAllAnimations()
        setContentOffset(lastScrollOffset, animated: false)
    }

    
    func kostylAgainstJumping(_ block: () -> Void) {
        self.contentInset.bottom = 300
        block()
        self.contentInset.bottom = 0
    }

    func scrollToBottomss(animated: Bool) {
        let y = contentSize.height - frame.size.height
        if y < 0 { return }
        setContentOffset(CGPoint(x: 0, y: y), animated: animated)
    }

    
    func reloadDataSmoothly() {
        UIView.setAnimationsEnabled(false)
        CATransaction.begin()
        
        CATransaction.setCompletionBlock {[weak self] () -> Void in
            UIView.setAnimationsEnabled(true)
        }
        
        reloadData()
        beginUpdates()
        endUpdates()
        
        CATransaction.commit()
    }

    }


extension UIImage {
    func imageWithBorder(width: CGFloat, color: UIColor) -> UIImage? {
        let square = CGSize(width: min(size.width, size.height) + width * 2, height: min(size.width, size.height) + width * 2)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .center
        imageView.image = self
        imageView.layer.borderWidth = width
        imageView.layer.borderColor = color.cgColor
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
}

extension UIImageView {
    func setImage(with urlString: String?, placeholder: UIImage? = nil) {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        //        activityIndicator.center = placeholder.center
        activityIndicator.hidesWhenStopped = true
        //        activityIndicator.activityIndicatorViewStyle = .whiteLarge
        activityIndicator.startAnimating()
        
        self.image = placeholder
        guard let urlString = urlString, let url = URL(string: urlString) else { return }
        image = nil
        //        showLoading()
        
        let cache = URLCache.shared
        
        let request = URLRequest(url: url)
        
        if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data: data) {
            //            hideLoading()
            self.image = image
        }
        else {
            let session = URLSession(configuration: URLSessionConfiguration.default)
            
            let dataTask = session.dataTask(with: request) { [weak self] (data, response, error) in
                guard let this = self else { return }
                if let response = response, let data = data {
                    let image = UIImage(data: data)
                    
                    let cachedData = CachedURLResponse(response: response, data: data)
                    cache.storeCachedResponse(cachedData, for: request)
                    DispatchQueue.main.async {
                        
                        //                        this.hideLoading()
                        this.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        
                        //                        this.hideLoading()
                        this.image = placeholder
                    }
                }
            }
            dataTask.resume()
        }
    }
}

@IBDesignable
class CustomTextField: UITextField {

    @IBInspectable var isPasteEnabled: Bool = true

    @IBInspectable var isSelectEnabled: Bool = true

    @IBInspectable var isSelectAllEnabled: Bool = true

    @IBInspectable var isCopyEnabled: Bool = true

    @IBInspectable var isCutEnabled: Bool = true

    @IBInspectable var isDeleteEnabled: Bool = true

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
             #selector(UIResponderStandardEditActions.select(_:)) where !isSelectEnabled,
             #selector(UIResponderStandardEditActions.selectAll(_:)) where !isSelectAllEnabled,
             #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
             #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled,
             #selector(UIResponderStandardEditActions.delete(_:)) where !isDeleteEnabled:
            return false
        default:
            //return true : this is not correct
            return super.canPerformAction(action, withSender: sender)
        }
    }
}






