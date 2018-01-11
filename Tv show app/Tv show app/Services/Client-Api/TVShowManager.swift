//
//  TVShowManager.swift
//  Tv show app
//
//  Created by Yveslym on 1/11/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Moya

struct TVSHowManager{
    /// method to find tv show
    func findTvShow(title:  String, completionHandler: @escaping([TVSHow]?)-> Void){
        NetworkAdapter.request(target: .findTvShow(query: title, language: .english), success: { (response) in
            do {
                let tvshow:[TVSHow] = try response.mapJSON() as! [TVSHow]
                completionHandler(tvshow)
            } catch{
                print("couldn't decode tvshow")
            }
            
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            completionHandler(nil)
        }
        
    }
    /// method to find list of episod of a tv show
    func findEpisode(episode Id: Int){
        DispatchQueue.main.async {
            
            NetworkAdapter.request(target: .theTvDBLogin, success: { (response) in
                
                //let authorization = try response.mapJSON() as Any
            }, error: { (error) in
                print("")
            }, failure: { (error) in
                print("")
            })
            
            
        }
        
        
    }
    /// Method that return list of popular tvshow
    func popularTvShow(completionHandler: @escaping([TVSHow]?)-> Void){
        NetworkAdapter.request(target: .popularTvShow(language: .english), success: { (response) in
            
            do {
                let tvshow:[TVSHow] = try response.mapJSON() as! [TVSHow]
                completionHandler(tvshow)
            } catch{
                print("couldn't decode tvshow")
            }
            
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            completionHandler(nil)
        }
    }
    /// method to get best rated tv show
    func bestRateTvShow(completionHandler: @escaping([TVSHow]?)-> Void){
        NetworkAdapter.request(target: .popularTvShow(language: .english), success: { (response) in
            
            do {
                let tvshow:[TVSHow] = try response.mapJSON() as! [TVSHow]
                completionHandler(tvshow)
            } catch{
                print("couldn't decode tvshow")
            }
            
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            completionHandler(nil)
        }
    }
    ///method to get simalar tv show to a given tv show
    func similarTvShow(tvShow id: Int,completionHandler: @escaping([TVSHow]?)-> Void ){
        NetworkAdapter.request(target: .similarTvShow(id: id, language: .english),success: { (response) in
            do {
                let tvshow:[TVSHow] = try response.mapJSON() as! [TVSHow]
                completionHandler(tvshow)
            } catch{
                print("couldn't decode tvshow")
            }
            
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            completionHandler(nil)
        }
    }
}









