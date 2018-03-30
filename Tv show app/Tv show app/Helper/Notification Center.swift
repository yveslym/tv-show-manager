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
        let favoriteTVID = UserDefaults.standard.array(forKey: "favoriteID")  as? [Int] ?? [Int]()
        let manager = TVSHowManager()
        var tvShow: [TVSHow] = []
        if !favoriteTVID.isEmpty{
            
            
            DispatchQueue.global().async {
            
                favoriteTVID.forEach{
                    dg.enter()
                    manager.tvShowDetails(id: $0, completionHandler: { (tvshow) in
                        
                        // check if the airing date is today for each favorite tv show
                        if Date.dayLeft(day: (tvshow?.lastAirDate?.toDate())!).day == 0{
                            tvShow.append(tvshow!)
                             print(tvshow?.name! ?? " no name ", " airing tonight")
                        }
                        else{
                            print(tvshow?.name! ?? " no name ", " NO")
                        }
                        dg.leave()
                    })
                    
                    
                }
                dg.notify(queue: .global(), execute: {
                   completion(tvShow)
                })
            }

    }
}
    
    static func generateNotification(){
        
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        Notification.checkFavoriteAiringTV { (tvshow) in
            if tvshow?.first != nil{
                var tvshowName = [String]()
                tvshow?.forEach{
                    tvshowName.append($0.name!)
                }
                // trigger
                var dateComponents = DateComponents()
                
                dateComponents.hour = 10
                
                dateComponents.minute = 00
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










