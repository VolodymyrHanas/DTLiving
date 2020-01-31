//
//  AppDelegate.swift
//  DTLiving
//
//  Created by Dan Jiang on 2020/1/31.
//  Copyright © 2020 Dan Jiang. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window?.rootViewController = CameraViewController()
        window?.makeKeyAndVisible()
        return true
    }

}

