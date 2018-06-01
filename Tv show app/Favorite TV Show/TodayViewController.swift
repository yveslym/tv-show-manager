//
//  TodayViewController.swift
//  Favorite TV Show
//
//  Created by Yveslym on 5/31/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit
import NotificationCenter
import KeychainSwift

class TodayViewController: UIViewController, NCWidgetProviding {
    
    // - MARK: PROPERTIES
        var currentFavoriteTV: [FavoriteTV] = {
            
            let stack = CoreDataStack.instance
            let favorite = stack.fetchRecordsForEntity(.FavoriteTV, inManagedObjectContext: stack.viewContext) as! [FavoriteTV]

            return favorite
        }()
    let keychain = KeychainSwift()
    
    var email: String!
    
    var userDef = UserDefaults(suiteName: "group.sharedTvID")
    
    lazy var favoriteID = userDef!.array(forKey: self.email)  as? [Int] ?? [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
         keychain.accessGroup = "K7R433H2CL.yveslym-corp.showbix2"
         email = keychain.get("email")
        let movie = CoreDataStack.instance.fetchRecordsForEntity(.FavoriteTV, inManagedObjectContext: CoreDataStack.instance.viewContext) as! [FavoriteTV]
        print(movie)
        
    }
   
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}
