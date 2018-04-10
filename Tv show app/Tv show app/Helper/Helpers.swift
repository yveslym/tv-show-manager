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

import Foundation
import UIKit


class ViewControllerUtils {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView) {
        container.frame.size.height = uiView.frame.height + 200
        container.frame.size.width = uiView.frame.width
        
        container.center.y = uiView.center.y - 100
        container.center.x = uiView.center.x
        container.backgroundColor = UIColor(rgb: 0xffffff).withAlphaComponent(0.3)
        container.tag = 100
        
        loadingView.frame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
        loadingView.center.y = uiView.center.y + 100
        loadingView.center.x = uiView.center.x
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        let actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        actInd.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(actInd)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        actInd.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        //        uiView.removeFromSuperview()
        activityIndicator.stopAnimating()
        loadingView.removeFromSuperview()
        //        container.removeFromSuperview()
        
        for subView in uiView.subviews {
            print(uiView.subviews)
            if subView.tag == 100 {
                subView.removeFromSuperview()
            }
        }
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}



