//
//  ViewController.swift
//  Tv show app
//
//  Created by Yveslym on 1/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let manager = TVSHowManager()
      
        manager.SearchTV(title: "seal team") { (tvshow) in
        print(tvshow)
        
        }
//        let tvShow = TVSHow()
//        manager.similarTV(tvShowID: tvShow.id!, completionHandler: { (similarTV) in
//            print(similarTV)
//        })
//
//        manager.similarTV(tvShowID: tvShow.id!) { (tvShow) in
//            print(tvShow)
//        }
//
//        manager.popularTV { (tvShow) in
//            print(tvShow)
//        }
//
//        manager.bestRateTV { (tvShow) in
//            print(tvShow)
//        }
    }
    

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

