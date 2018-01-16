//
//  AppDelegate.swift
//  Tv show app
//
//  Created by Yveslym on 1/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().barTintColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 0.0)
        //UINavigationBar.appearance().backgroundColor = UIColor(red: 51/255, green: 51/255, blue: 51/255, alpha: 1)
        //UITabBar.appearance()
        UINavigationBar.appearance().isTranslucent = true
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        ApiConfiguration.TVShow(themoviedbApiKey: "ba61b7a133d03578fcb757842f1d9e79")
        
        
//        let manager = TVSHowManager()
//        var tvs = [TVSHow]()
//        manager.airingTodayTV { (tvshow) in
//            tvs = tvshow
//            manager.similarTV(tvShowID: (tvs.first?.id!)!, completionHandler: { (tvshows) in
//                print(tvshows)
//            })
//        }
        
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

