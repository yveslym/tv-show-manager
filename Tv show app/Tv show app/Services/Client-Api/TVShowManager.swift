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
    /// An helper method tofind tv without season in it
  func findTvShow(title:  String, completionHandler: @escaping([TVSHow]?)-> Void){
        var tvShows = [TVSHow]()
        var idResult = [ShowsID]()
        let dg = DispatchGroup()
        
        self.tvShowIDs(title: title) { (tvshowIDResult) in
            
            guard let tvshowidResult = tvshowIDResult else {return completionHandler(nil)}
            idResult = tvshowidResult.results!
            
            DispatchQueue.global().async {
                idResult.forEach{
                    dg.enter()
                    // get tvshow info
                    self.tvShowDetails(id: $0.id!, completionHandler: { (tvshow) in
                        guard let tvShow = tvshow else {return completionHandler(nil)}
                        tvShows.append(tvShow)
                        dg.leave()
                        
                    })
                    
                    dg.notify(queue: DispatchQueue.global(), execute: {
                        completionHandler(tvShows)
                    })
                }
            }
            
            
        }
    }
    
    /// method to find tv show with seasons and episodes
    func SearchTV(title: String,completionHandler: @escaping([TVSHow])-> Void){
        
        
        var tvshows = [TVSHow]()
        let dg = DispatchGroup()
        
        self.findTvShow(title: title) { (tvshow) in
            
            DispatchQueue.global().async {
                
                
                tvshow?.forEach{
                    var newtv = $0
                    dg.enter()
                    self.seasons(tvshow: $0.id!, numberofseason: $0.numberOfSeasons!, completionHandler: { (seasons) in
                        newtv.seasons = seasons
                        tvshows.append(newtv)
                        
                        dg.leave()
                    })
                    dg.notify(queue: .global(), execute: {
                        completionHandler(tvshows)
                    })
                }
            }
        }
    }
    
    func tvShowComplet(tvShowId: Int, completionHandler: @escaping(TVSHow?, [Season]?)-> Void){
        
        self.tvShowDetails(id: tvShowId) { (tv) in
            self.seasons(tvshow: tvShowId, numberofseason: (tv?.numberOfSeasons!)!, completionHandler: { (seasons) in
                completionHandler(tv,seasons)
            })
            
        }
    }
    
    
    
    
    // helper method to find season and episode
    func seasons(tvshow id: Int, numberofseason: Int, completionHandler:@escaping([Season]?)-> Void){
        let numberofseason = self.createArray(number: numberofseason)
        let dg = DispatchGroup()
        var seasons = [Season]()
        DispatchQueue.global().async {
            
            
            numberofseason.forEach{
                dg.enter()
                self.tvShowSeason(tvShows: id, season: $0, completionHandler: { (season) in
                    seasons.append(season!)
                    dg.leave()
                })
                
                
            }
            dg.notify(queue: .main, execute: {
                completionHandler(seasons)
            })
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
    
    /// an Helper method to find season of tvshow
    private func tvShowSeason(tvShows id: Int, season number: Int, completionHandler:@escaping(Season?)-> Void) {
        NetworkAdapter.request(target: .getSeasons(tvShowID: id, seasonNumber: number, language: .english), success: { (response) in
            do{
                
                let newSeason: Season = try response.map(to: Season.self)
                completionHandler(newSeason)
                
            }
                
            catch{
                print("something goes wrong when decoding json on getSeasons method")
            }
        }, error: { (error) in
            print("error occured: check the apiconfig is correct")
            completionHandler(nil)
        }) { (error) in
            print("error occured: check your internet connection")
            completionHandler(nil)
        }
    }
    /// helper method to get tv show details
    func tvShowDetails(id: Int, completionHandler: @escaping(TVSHow?)->Void){
        
        DispatchQueue.global().async {
            
            
            NetworkAdapter.request(target: .TVShowDetail(id: id, language: .english), success: { (response) in
                
                do{
                    let tvshows = try response.map(to: TVSHow.self)
                    completionHandler(tvshows)
                    
                }catch{
                    print("something goes wrong when decoding json tvshow detail")
                }
            }, error: { (error) in
                print("error occured: check the apiconfig is correct")
                return completionHandler(nil)
            }) { (error) in
                print("error occured: check your internet connection")
                return completionHandler(nil)
            }
        }
    }
    
    /// Method that return list of popular tvshow
    func popularTV(completionHandler: @escaping([TVSHow]?)-> Void){
        
        DispatchQueue.global().async {
            
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
}
    /// method to get best rated tv show
    func bestRateTV(completionHandler: @escaping([TVSHow]?)-> Void){
        DispatchQueue.global().async {
            
            
            NetworkAdapter.request(target: .bestRateTvShow(language: .english), success: { (response) in
                do {
                    let tvShowResult: TVShowResult = try response.map(to: TVShowResult.self)
                    guard let tvShows: [TVSHow] = tvShowResult.result else {return}
                    return completionHandler(tvShows)
                } catch {
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
    ///method to get simalar tv show to a given tv show
    func similarTV(tvShowID id: Int,completionHandler: @escaping([TVSHow]?)-> Void ){
        DispatchQueue.global().async {
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
    
    func airingTodayTV(completionHandler: @escaping([TVSHow])-> Void){
        DispatchQueue.global().async {
            NetworkAdapter.request(target: .airingToday(language: .english), success: { (response) in
                do{
                    let tvshowResult = try response.map(to: TVShowResult.self)
                    completionHandler(tvshowResult.result!)
                }catch{
                    print("couldn't decode tvshow")
                }
            }, error: { (error) in
                print("error occured: check the apiconfig is correct")
                
            }) { (error) in
                print("error occured: check your internet connection")
                
            }
        }
    }
    
    func getVideos(withId id: Int, completionHandler: @escaping([videoModel]?) -> Void){
        NetworkAdapter.request(target: .getVideos(id: id, language: .english), success: { (response) in
            
            let video = try! response.map(to: [videoModel].self, keyPath: "results")
            completionHandler(video)
        }, error: { (error) in
            
        }) { (error) in
            
        }
    }
    
    func discoverShow(completionHandler: @escaping([TVSHow])-> Void){
        DispatchQueue.global().async {
            NetworkAdapter.request(target: .discover(language: .english, page: 1), success: { (response) in
                let discover = try! response.map(to: [TVSHow].self, keyPath: "results")
                completionHandler(discover)
            }, error: { (error) in
                
            }) { (error) in
                
            }
        }
    }
    
    private func createArray(number: Int) ->[Int]{
        var index = 1
        var array = [Int]()
        if number > 0{
            while index <= number{
                array.append(index)
                index += 1
            }
        }
        return array
    }
    /// function to return if the last episode pass already
    private func isMoreEpisode(_ lastAiringDate: String) -> Bool{
        return Date().toString() < lastAiringDate
    }
    
    /// function to return all episodes of a tv show
    private func getAllEpisodes(_ seasons: [Season]) -> [Episodes]{
        var episodes = [Episodes]()
        seasons.forEach{
            $0.episodes?.forEach{
                episodes.append($0)
            }
        }
        return episodes
    }
    
    private func getEpisodeDate(_ episodes: [Episodes]) -> [String]{
        var episodeDate = [String]()
        episodes.forEach{
            episodeDate.append(($0.airedDate)!)
        }
        return episodeDate
    }
    
    // function to return next episodes
    func nextEpisode(_ tvshow: TVSHow) -> Episodes? {
        
        var allEpisodes = [Episodes]()
        var episodesDate = [String]()
        let today = Date().toString()
        episodesDate.append(today)
        
        tvshow.seasons?.forEach({ (season) in
            season.episodes?.forEach({ (episode) in
                episodesDate.append((episode.airedDate ?? "")!)
                allEpisodes.append(episode)
            })
        })
        let sortedDate = episodesDate.sorted(by: {$0 < $1})
        let airingDateIndex = sortedDate.index(where: {$0 == today})
       
        
        if today > sortedDate.last!{
            return nil
        }
        else if sortedDate.last! == today{
            return allEpisodes.last!
        }
        else{
            return allEpisodes[airingDateIndex!]
        }
        
    }
    
    /// function to update tvshow recorded
    func upDateRecordedTV(_ tvShows: [TVSHow]){
       let stack  = CoreDataStack.instance
        
        /// get the recorded tv show
        let favoriteTV = stack.fetchRecordsForEntity(.FavoriteTV, inManagedObjectContext: stack.viewContext) as! [FavoriteTV]
        /// map and update the recorded movie with the updated one
        _ = favoriteTV.map { (favorite) -> FavoriteTV? in
           let tv = tvShows.filter{return $0.id! == Int(favorite.tvShowID!)!}.first
            
               return FavoriteTV(context: stack.viewContext, tvshow: tv!)
        }
        // save
        stack.saveTo(context: stack.viewContext)
    }
}












