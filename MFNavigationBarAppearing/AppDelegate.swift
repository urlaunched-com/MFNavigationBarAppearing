//
//  AppDelegate.swift
//  MFNavigationBarAppearing
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 molfar.io. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        window?.rootViewController = MFNavigationBarAppearingContoller(rootViewController: MainViewController())
        return true
    }
}

