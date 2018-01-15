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
      
        manager.findTV(title: "game of thrones") { (tvshow) in
            DispatchQueue.main.async {
                 print(tvshow)
            }
           
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

