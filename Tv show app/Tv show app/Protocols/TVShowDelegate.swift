//
//  TVShowDelegate.swift
//  Tv show app
//
//  Created by Yveslym on 1/28/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import FSPagerView
import Kingfisher
protocol TVShowDelegate: class{
    func TVShowDetailViewController(tvShow: TVSHow)
    func tvShowSimilar(tvShow: TVSHow, TVShowController:TVShowDetailsTableViewController)
    func TVShowDetail(tvShow: TVSHow,tvDetailViewController:TVShowDetailsTableViewController )
}

extension TVShowDelegate where Self: UIViewController{
    
    
    func TVShowDetail(tvShow: TVSHow, tvDetailViewController:TVShowDetailsTableViewController){
        
        
        let manager = TVSHowManager()
        
        DispatchQueue.global().async {
            manager.tvShowComplet(tvShowId: tvShow.id!, completionHandler: { (tv, seasons) in
                var completTv = tv!
                completTv.seasons = seasons!
                
               
                
                 var imageList = [UIImage]()
                
                completTv.seasons?.forEach{
                    do{
                        if let url = $0.imageURL{
                            let data = try Data(contentsOf: url)
                            let image = UIImage(data: data)
                            imageList.append(image!)
                        }
                        else{
                            imageList.append( tvDetailViewController.posterImage)
                        }
                    }catch{
                        let image = UIImage(named: "search")
                        imageList.append(image!)
                    }
                }
                
                
                if seasons?.first?.episodes?.first?.imageURL != nil{
                    let data = try! Data(contentsOf: (seasons?.first?.episodes?.first?.imageURL)!)
                    let image = UIImage(data: data)
                    //let blurImage = UIImage.blurImage(image: image!)
                    tvDetailViewController.coverImage = image!
                }else{
                    let data = try! Data(contentsOf: (tv?.imageURL)!)
                    let image = UIImage(data: data)
                    
                    tvDetailViewController.coverImage = image!
                }
                
                // load poster image
                let data = try! Data(contentsOf: (tv?.imageURL!)!)
                let poster = UIImage(data: data)
                tvDetailViewController.posterImage = poster!
                tvDetailViewController.tvShow = completTv
                tvDetailViewController.seasonImage = imageList
                
               
                    self.reloadInputViews()
                
            })
        }
    }
    
    
    /// function to transite from main view to tvshow detail view controlloer
    func TVShowDetailViewController(tvShow: TVSHow){
        
       
        let manager = TVSHowManager()
        
        DispatchQueue.global().async {
            manager.tvShowComplet(tvShowId: tvShow.id!, completionHandler: { (tv, seasons) in
                var completTv = tv!
                completTv.seasons = seasons!
                let tvDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "tvshow") as! TVShowDetailsTableViewController
                
                 var imageList = [UIImage]()

                completTv.seasons?.forEach{
                    do{
                        if let url = $0.imageURL{
                            let data = try Data(contentsOf: url)
                            let image = UIImage(data: data)
                            imageList.append(image!)
                        }
                        else{
                             imageList.append( tvDetailViewController.posterImage)
                        }
                    }catch{
                        let image = UIImage(named: "search")
                        imageList.append(image!)
                    }
                }
               
                
                if seasons?.first?.episodes?.first?.imageURL != nil{
                let data = try! Data(contentsOf: (seasons?.first?.episodes?.first?.imageURL)!)
                let image = UIImage(data: data)
                    //let blurImage = UIImage.blurImage(image: image!)
                    tvDetailViewController.coverImage = image!
                }else if tv?.imageURL != nil{
                    let data = try! Data(contentsOf: (tv?.imageURL)!)
                    let image = UIImage(data: data)
                    tvDetailViewController.coverImage = image!
                }
                else{
                   
                    let image = UIImage(named: "search")
                    tvDetailViewController.coverImage = image!
                }
                
                // load poster image
                let data = try! Data(contentsOf: (tv?.imageURL!)!)
                let poster = UIImage(data: data)
                tvDetailViewController.posterImage = poster!
                
                tvDetailViewController.tvShow = completTv
                tvDetailViewController.seasonImage = imageList
                //self.present(tvDetailViewController, animated: true, completion: nil)
                self.performSegue(withIdentifier: "tvshow", sender: tvDetailViewController)
            })
        }
    }
    func tvShowSimilar(tvShow: TVSHow, TVShowController:TVShowDetailsTableViewController){
       
        DispatchQueue.global().async {
            let manager = TVSHowManager()
            manager.similarTV(tvShowID: TVShowController.tvShow.id!, completionHandler: { (similarTvshow) in
                
                var imageList = [UIImage]()
                /// download all similar tv show poster
                TVShowController.similarTV.forEach{
                    do{
                        if $0.imageURL != nil{
                            TVShowController.similarTVName.append($0.name!)
                            let data = try Data(contentsOf: $0.imageURL!)
                            let image = UIImage(data: data)
                            imageList.append(image!)
                        }
                        else{
                            let image = UIImage(named: "search")
                           imageList.append(image!)
                        }
                    }catch{
                        let image = UIImage(named: "search")
                        imageList.append(image!)
                    }
                    if $0.name == nil{
                        TVShowController.similarTVName.append("")
                    }
                }
                TVShowController.similarImage = imageList
                TVShowController.similarTV = similarTvshow!
                
                DispatchQueue.main.async {
                    //TVShowController.tableview.reloadData()
                    TVShowController.similarTVShowView.reloadData()
                    //TVShowController.tvShowSeasonsView.reloadData()
                    //TVShowController.similarTVCell.isHidden = false
                }
            })
        }
    }
}
















