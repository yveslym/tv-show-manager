//
//  Notification Center.swift
//  Tv show app
//
//  Created by Yveslym on 2/18/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import UserNotifications
import KeychainSwift


struct Notification{
    static func checkFavoriteAiringTV(completion:@escaping([TVSHow]?)-> Void){
      
       // let defaults = UserDefaults.standard
        let dg = DispatchGroup()
         let keychain = KeychainSwift()
        keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
        guard let email = keychain.get("email") else {return}
        let defaults = UserDefaults(suiteName: "group.sharedTvID")
        let favoriteTVID = defaults?.array(forKey:email)  as? [Int] ?? [Int]()
        
        let manager = TVSHowManager()
        var tvShow: [TVSHow] = []
        if !favoriteTVID.isEmpty{
            
            
            DispatchQueue.global().async {
            
                favoriteTVID.forEach{
                    dg.enter()
                    manager.tvShowComplet(tvShowId: $0, completionHandler: { (tvshow, seasons) in


                        
                        // check if the airing date is today for each favorite tv show

                        guard var tvshow = tvshow else {return}

                        tvshow.seasons = seasons
                        let manager = TVSHowManager()
                        
                        let airingEpisode = manager.nextEpisode(tvshow)
                        if let airingDate = airingEpisode?.airedDate?.toDate(){
                            let day = Date.dayLeft(day: airingDate).day
                            if day == 0{
                                tvShow.append(tvshow)
                            }
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
    
    static func generateNotification() {
        
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
                
                dateComponents.hour = 11
                
                dateComponents.minute = 55
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                // content
                
                let content = UNMutableNotificationContent()
                content.title = "Airing TV"
                content.body = "Hey, Your favorite tv \(tvshowName) is going to air today."
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










