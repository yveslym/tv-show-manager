//
//  AppDelegate.swift
//  Tv show app
//
//  Created by Yveslym on 1/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import UserNotifications
import KeychainSwift
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.sharedManager().enable = true
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge]) { (permitionGranted, error) in
            Notification.generateNotification()
        }
        let keychain = KeychainSwift()
       
         keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
        
        if let login: Bool = keychain.getBool("isLogin") {
        
        if login {
             ApiConfiguration.TVShow(themoviedbApiKey: "ba61b7a133d03578fcb757842f1d9e79")
            
            let mainStoryBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let rootController = mainStoryBoard.instantiateViewController(withIdentifier: "home tab")
            window?.rootViewController = rootController
            
           window?.makeKeyAndVisible()
        }
        }
        
        ApiConfiguration.TVShow(themoviedbApiKey: "ba61b7a133d03578fcb757842f1d9e79")
        
        
        
        return true
    }

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


}

