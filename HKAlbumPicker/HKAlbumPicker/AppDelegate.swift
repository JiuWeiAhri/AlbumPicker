//
//  AppDelegate.swift
//  HKAlbumPicker
//
//  Created by AhriLiu on 2020/12/22.
//  Copyright © 2020 AhriLiu. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow()
        self.window = window
        self.window?.makeKeyAndVisible()
        
        let vc = ViewController()
        
        UIApplication.shared.keyWindow?.rootViewController = vc


        return true
    }




}

