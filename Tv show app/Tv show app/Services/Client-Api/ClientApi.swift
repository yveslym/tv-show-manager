//
//  ClientApi.swift
//  Tv show app
//
//  Created by Yveslym on 1/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Moya

enum TvShowApi{
    case popularTvShow
    case similarTvShow(id: Int)
    case bestRateTvShow
    case getVideos(id: Int)
    case getImage
    case findTvShow(title: String)
    case theTvDBLogin
    case findEpisode(episodeId: Int)
    case theTvdbFindShow(title: Int)
}

extension TvShowApi:  TargetType{
    
    public var baseURL: URL{
        switch self{
            
        case .popularTvShow:
            return URL(string: "https://api.themoviedb.org")!
        case .similarTvShow:
            return URL(string: "https://api.themoviedb.org")!
        case .bestRateTvShow:
            return URL(string: "https://api.themoviedb.org")!
        case .getVideos:
            return URL(string: "https://api.themoviedb.org")!
        case .getImage:
            return URL(string: <#T##String#>)!
        case .findTvShow:
            return URL(string: "https://api.themoviedb.org")!
        case .theTvDBLogin:
            return URL(string: "https://api.thetvdb.com")!
        case .findEpisode:
            return URL(string: "https://api.thetvdb.com/series/")!
        case .theTvdbFindShow:
            return URL(string: "https://api.thetvdb.com/search/series")!
        }
    }
    
    var path: String {
        switch self{
            
        case .popularTvShow:
            return "/3/tv/popular"
        case .similarTvShow(let id):
            return "/3/tv/\(id)/similar"
        case .bestRateTvShow:
            return "/3/tv/top_rated"
        case .getVideos(let id):
            return "/3/tv/\(id)/videos"
        case .getImage:
            <#code#>
        case .findTvShow:
            return "/3/search/tv"
        case .theTvDBLogin:
            return "/login"
        case .findEpisode(let id):
             return "/series/\(id)/episodes"
        case .theTvdbFindShow(let id):
             return "/series/\(id)"
        }
    }
    
    var method: Moya.Method {
        switch self{
            
        case .popularTvShow:
            <#code#>
        case .similarTvShow:
            <#code#>
        case .bestRateTvShow:
            <#code#>
        case .getVideos:
            <#code#>
        case .getImage:
            <#code#>
        case .findTvShow:
            <#code#>
        case .theTvDBLogin:
            <#code#>
        case .findEpisode:
            <#code#>
        case .theTvdbFindShow:
            <#code#>
        }
    }
    
    var sampleData: Data {
        switch self{
            
        case .popularTvShow:
            <#code#>
        case .similarTvShow:
            <#code#>
        case .bestRateTvShow:
            <#code#>
        case .getVideos:
            <#code#>
        case .getImage:
            <#code#>
        case .findTvShow:
            <#code#>
        case .theTvDBLogin:
            <#code#>
        case .findEpisode:
            <#code#>
        case .theTvdbFindShow:
            <#code#>
        }
    }
    
    var task: Task {
        <#code#>
    }
    
    var headers: [String : String]? {
        switch self{
            
        case .popularTvShow:
            <#code#>
        case .similarTvShow:
            <#code#>
        case .bestRateTvShow:
            <#code#>
        case .getVideos:
            <#code#>
        case .getImage:
            <#code#>
        case .findTvShow:
            <#code#>
        case .theTvDBLogin:
            <#code#>
        case .findEpisode:
            <#code#>
        case .theTvdbFindShow:
            <#code#>
        }
    }
    
}
