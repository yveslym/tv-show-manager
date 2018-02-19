//
//  Notification Center.swift
//  Tv show app
//
//  Created by Yveslym on 2/18/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import UserNotifications

struct Notification{
    static func checkFavoriteAiringTV(completion:@escaping([TVSHow]?)-> Void){
      
       // let defaults = UserDefaults.standard
        let dg = DispatchGroup()
        var favoriteTVID = UserDefaults.standard.array(forKey: "favoriteID")  as? [Int] ?? [Int]()
        let manager = TVSHowManager()
        var tvShow: [TVSHow] = []
        if !favoriteTVID.isEmpty{
            favoriteTVID.forEach{
                dg.enter()
                manager.tvShowDetails(id: $0, completionHandler: { (tvshow) in
                    if Date.dayLeft(day: (tvshow?.lastAirDate?.toDate())!).day == 0{
                        tvShow.append(tvshow!)
                    }
                     dg.leave()
                })
                dg.notify(queue: .global(), execute: {
                    completion(tvShow)
                })
            }
        }
    }
    static func generateNotification(){
        
        let center = UNUserNotificationCenter.current()
        
        Notification.checkFavoriteAiringTV { (tvshow) in
            if tvshow != nil{
                var tvshowName = [String]()
                tvshow?.forEach{
                    tvshowName.append($0.name!)
                }
                // trigger
                var dateComponents = DateComponents()
                
                dateComponents.hour = 16
                
                dateComponents.minute = 03
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                // content
                let content = UNMutableNotificationContent()
                content.title = "Your Favorite TV airing Today"
                content.body = "Hey, Your favorite tv \(tvshowName) is going to be air today."
                //content.categoryIdentifier = "customIdentifier"
                //content.userInfo = ["customData": "fizzbuzz"]
                content.sound = UNNotificationSound.default()
                content.badge =  tvshow?.count as NSNumber?
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                center.add(request)
            }
        }
    }
}










