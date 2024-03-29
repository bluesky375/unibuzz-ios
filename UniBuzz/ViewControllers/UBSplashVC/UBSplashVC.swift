//
//  UBSplashVC.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 21/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import Alamofire
class UBSplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        getServerKey()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [weak self] in
            if let session: Session = Persistence(with: .user).load(), let token = session.access_token {
                SKSocketConnection.socketSharedConnection.connectSocket()
                WAShareHelper.goToHomeController(vcIdentifier: VCIdentifier.KTABBARCONTROLLER, storyboardName: "Home", navController: self!.navigationController!, leftMenuIdentifier: "UBSideMenuVC")
            } else {
                self!.pushToViewControllerWithStoryboardID(storyboardId: VCIdentifier.KUBLOGIN)

            }

        })
        
    }

}

extension UITextField {
    
    /// Runtime key
    private struct AssociatedKeys {
        /// max lenght key
        static var maxlength: UInt8 = 0
        /// temp string key
        static var tempString: UInt8 = 0
    }
    
    /// Limit the maximum input length of the textfiled
    @IBInspectable var maxLength: Int {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.maxlength) as? Int ?? 0
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.maxlength, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            addTarget(self, action: #selector(handleEditingChanged(textField:)), for: .editingChanged)
        }
    }
    
    /// temp string
    private var tempString: String? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.tempString) as? String
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.tempString, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    /// When the text changes, process the amount of text in the input box so that its length is within the controllable range.
    @objc private func handleEditingChanged(textField: UITextField) {
        
        /// Special Processing for Chinese Input Method
        guard markedTextRange == nil else { return }
        
        if textField.text?.count == maxLength {
            
            /// SET lastQualifiedString where text length == max lenght
            tempString = textField.text
        } else if textField.text?.count ?? 0 < maxLength {
            
            /// clear lastQualifiedString when text lengeht > maxlength
            tempString = nil
        }
        
        /// keep current text range in arcgives
        let archivesEditRange: UITextRange?
        
        if textField.text?.count ?? 0 > maxLength {
            
            /// if text length > maxlength,remove last range,to move to -1 postion.
            let position = textField.position(from: safeTextPosition(selectedTextRange?.start), offset: -1) ?? textField.endOfDocument
            archivesEditRange = textField.textRange(from: safeTextPosition(position), to: safeTextPosition(position))
        } else {
            
            /// just set current select text range
            archivesEditRange = selectedTextRange
        }
        
        /// main handle string max length
        textField.text = tempString ?? String((textField.text ?? "").prefix(maxLength))
        
        /// last config edit text range
        textField.selectedTextRange = archivesEditRange
    }
    
    /// get safe textPosition
    private func safeTextPosition(_ optionlTextPosition: UITextPosition?) -> UITextPosition {
        
        /* beginningOfDocument -> The end of the the text document. */
        return optionlTextPosition ?? endOfDocument
    }
}
