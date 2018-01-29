//
//  TVShowDelegate.swift
//  Tv show app
//
//  Created by Yveslym on 1/28/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import FSPagerView
protocol TVShowDelegate: class{
    func TVShowDetailViewController(tvShow: TVSHow)
}

extension TVShowDelegate where Self: UIViewController{
    func TVShowDetailViewController(tvShow: TVSHow){
       
        let manager = TVSHowManager()
        
        DispatchQueue.main.async {
            manager.tvShowComplet(tvShow: tvShow, completionHandler: { (tv, seasons) in
                var completTv = tv!
                completTv.seasons = seasons!
                 //let tvDetailViewController = TVShowDetailsTableViewController()
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tvDetailViewController = storyboard.instantiateViewController(withIdentifier: "tvshow") as! TVShowDetailsTableViewController
                
                
                completTv.seasons?.forEach{
                    do{
                        if let url = $0.imageURL{
                            let data = try Data(contentsOf: url)
                            let image = UIImage(data: data)
                            tvDetailViewController.seasonImage.append(image!)
                        }
                        else{
                             tvDetailViewController.seasonImage.append( tvDetailViewController.posterImage)
                        }
                    }catch{
                        let image = UIImage(named: "search")
                        tvDetailViewController.seasonImage.append(image!)
                    }
                }
               
                
                if seasons?.first?.episodes?.first?.imageURL != nil{
                let data = try! Data(contentsOf: (seasons?.first?.episodes?.first?.imageURL)!)
                let image = UIImage(data: data)
                    let blurImage = UIImage.blurImage(image: image!)
                    tvDetailViewController.coverImage = blurImage!
                }else{
                    let data = try! Data(contentsOf: (seasons?.first?.imageURL)!)
                    let image = UIImage(data: data)
                    let blurImage = UIImage.blurEffect(image: image!)
                    tvDetailViewController.coverImage = blurImage
                }
                
                // load poster image
                let data = try! Data(contentsOf: (tv?.imageURL!)!)
                let poster = UIImage(data: data)
                tvDetailViewController.posterImage = poster!
                
                tvDetailViewController.tvShow = completTv

                self.present(tvDetailViewController, animated: true, completion: nil)
            })
        }
        
        
    }
}

