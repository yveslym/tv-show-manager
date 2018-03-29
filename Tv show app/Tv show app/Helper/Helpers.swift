//
//  Helpers.swift
//  Tv show app
//
//  Created by Yveslym on 3/28/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import UIKit

struct Helpers{
    ///function to download tvshow images
    static func downloadImage(tvShow: [TVSHow]) -> [UIImage]{
        
        var images = [UIImage]()
        
        tvShow.forEach{
            do{
                if $0.imageURL != nil{
                    let data = try  Data(contentsOf: $0.imageURL!)
                    let image = UIImage(data: data)
                    images.append(image!)
                }else{
                    let image = UIImage(named:"search")
                   images.append(image!)
                }
            }catch{
                print("couldn't load image")
                let image = UIImage(named:"search")
                images.append(image!)
            }
        }
         return images
    }
   
}
