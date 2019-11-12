//
//  UBTabBarController.swift
//  UniBuzz
//
//  Created by Ahmed Durrani on 20/07/2019.
//  Copyright © 2019 unibuss. All rights reserved.
//

import UIKit

class UBTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appearance = UITabBarItem.appearance()
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Montserrat", size: 13)]
        appearance.setTitleTextAttributes(attributes as [NSAttributedString.Key : Any], for: .normal)
        let selectedColor   = UIColor.black
        let unselectedColor = UIColor(red: 129/255.0, green: 124/255.0, blue: 169/255.0, alpha: 1.0)
        self.tabBar.items![0].selectedImage = UIImage(named:"homeS")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![0] ).image = UIImage(named:"homeUn")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![1].selectedImage = UIImage(named:"chatS")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![1] ).image = UIImage(named:"chatUn")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![2].selectedImage = UIImage(named:"groupS")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![2] ).image = UIImage(named:"groupUn")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![3].selectedImage = UIImage(named:"notificationS")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![3] ).image = UIImage(named:"notificationUn")!.withRenderingMode(.alwaysOriginal)
        self.tabBar.items![4].selectedImage = UIImage(named:"taskS")!.withRenderingMode(.alwaysOriginal)
        (self.tabBar.items![4] ).image = UIImage(named:"taskSUn")!.withRenderingMode(.alwaysOriginal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: unselectedColor], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: selectedColor], for: .selected)


    }
    

   

}
