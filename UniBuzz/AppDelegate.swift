//
//  AppDelegate.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SVProgressHUD
import Firebase
import Crashlytics
import Fabric
import PKRevealController
import SlideMenuControllerSwift
import LanguageManager_iOS
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabBarSelect  = 0
    var badgeCount  = 0
    var isSelectPost : Bool?
    var isSelectFile : Bool?
    var isSelectMember : Bool?
    var isChatView : Bool?
    var menuControllers = [String: PKRevealController]()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SlideMenuOptions.contentViewScale = 1.0
        APPVERSION = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!
        isChatView = false
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        LanguageManager.shared.defaultLanguage = .en
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom)
        SVProgressHUD.setDefaultAnimationType(SVProgressHUDAnimationType.flat)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.black)
        SVProgressHUD.setForegroundColor(UIColor(red: 54/255.0, green: 17/255.0, blue: 143/255.0, alpha: 1.0))
        SVProgressHUD.setBackgroundColor(UIColor.white)
        UIApplication.shared.statusBarStyle = .lightContent
        IQKeyboardManager.shared.enable = true
        isSelectPost = false
        isSelectFile = false
        isSelectMember = false
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        Fabric.sharedSDK().debug = true
    
       

//        Instabug.start(withToken: "c2f98da1891a37a5ed6d5c3e87710db1", invocationEvents: [.shake, .screenshot])
//        [Instabug startWithToken:@"c2f98da1891a37a5ed6d5c3e87710db1" invocationEvents: IBGInvocationEventShake | IBGInvocationEventScreenshot];
//         Instabug.start(withToken: "c2f98da1891a37a5ed6d5c3e87710db1", invocationEvents: [.shake, .screenshot])
//        Instabug.autoScreenRecordingDuration = 1.0
////        NetworkLogger.enabled = true
//        BugReporting.shouldCaptureViewHierarchy = true


        return true
    }

//    private func setupKeyboardManager() {
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
//        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
//        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
//    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        
    }
    
    class func isArabic() -> Bool {
        return LanguageManager.shared.currentLanguage == .ar
    }
    

}

