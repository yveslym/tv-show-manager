//
//  TVShowManager.swift
//  Tv show app
//
//  Created by Yveslym on 1/11/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Moya
import Mapper
import Moya_ModelMapper

struct TVSHowManager{
    /// method to find tv show
    func findTvShow(title:  String, completionHandler: @escaping([TVSHow]?)-> Void){
        var tvShows = [TVSHow]()
        var idResult = [ShowsID]()
        let dg = DispatchGroup()
        
        self.tvShowIDs(title: title) { (tvshowIDResult) in
            
            guard let tvshowidResult = tvshowIDResult else {return completionHandler(nil)}
            idResult = tvshowidResult.results!
            
            idResult.forEach{
                dg.enter()
                // get tvshow info
                self.tvShowDetails(id: $0.id!, completionHandler: { (tvshow) in
                    guard let findTvShow = tvshow else {return completionHandler(nil)}
                    
                
                    tvShows.append(findTvShow)
                    dg.leave()
                })
                
                dg.notify(queue: DispatchQueue.main, execute: {
                    completionHandler(tvShows)
                })
            }
        }
        
    }
    // method to return id of tv show
    private func tvShowIDs(title: String, completionHandler: @escaping(ShowIDResult?)-> Void){
        
        NetworkAdapter.request(target: .findTvShow(query: title, language: .english), success: { (response) in
            do {
                let tvShowID: ShowIDResult = try response.map(to: ShowIDResult.self)
               
                completionHandler(tvShowID)
            }catch{
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
    
   /// method to find season of tvshow
    private func tvShowSeason(tvShows: TVSHow?, completionHandler: @escaping([Season]?)-> Void){
        
        var index = 1
        let dg = DispatchGroup()
        var seasons = [Season]()
        
        guard let tvShow = tvShows else {return completionHandler(nil)}
         dg.enter()
        while index >= tvShow.numberOfSeasons!{
         
            // get season by id
            NetworkAdapter.request(target: .getSeasons (tvShowID: index, seasonNumber: 5, language: .english), success: { (response) in
            do{
            let newSeason: Season = try response.map(to: Season.self)
            seasons.append(newSeason)
            }catch{
                print("something goes wrong when decoding json")
            }
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            return completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            return completionHandler(nil)
        }
            index += 1
    }
    dg.leave()

        dg.notify(queue: .main) {
            completionHandler(seasons)
        }
}
    /// method to get tv show details
    private func tvShowDetails(id: Int, completionHandler: @escaping(TVSHow?)->Void){
        NetworkAdapter.request(target: .TVShowDetail(id: id, language: .english), success: { (response) in
        
            do{
        let tvshows = try response.map(to: TVSHow.self)
        completionHandler(tvshows)
        
            }catch{
                print("something goes wrong when decoding json")
            }
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            return completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            return completionHandler(nil)
        }
    }
    
    /// Method that return list of popular tvshow
    func popularTvShow(completionHandler: @escaping([TVSHow]?)-> Void){
        NetworkAdapter.request(target: .popularTvShow(language: .english), success: { (response) in
            
            do {
                let tvShowResult: TVShowResult = try response.map(to: TVShowResult.self)
                guard let tvShows: [TVSHow] = tvShowResult.result else {return}
                return completionHandler(tvShows)
                
            } catch{
                print("couldn't decode tvshow")
                return completionHandler(nil)
            }
            
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            return completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
           return completionHandler(nil)
        }
    }
    /// method to get best rated tv show
    func bestRateTvShow(completionHandler: @escaping([TVSHow]?)-> Void){
        NetworkAdapter.request(target: .popularTvShow(language: .english), success: { (response) in
            
            do {
                let tvShowResult: TVShowResult = try response.map(to: TVShowResult.self)
                guard let tvShows: [TVSHow] = tvShowResult.result else {return}
                return completionHandler(tvShows)
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
                let tvShowResult: TVShowResult = try response.map(to: TVShowResult.self)
                guard let tvShows: [TVSHow] = tvShowResult.result else {return}
                return completionHandler(tvShows)
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









