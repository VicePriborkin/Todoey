//
//  AppDelegate.swift
//  Todoey
//
//  Created by Vice Priborkin on 11/02/2018.
//  Copyright © 2018 Vice Priborkin. All rights reserved.
//

import UIKit
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        return true
    }
    
}
