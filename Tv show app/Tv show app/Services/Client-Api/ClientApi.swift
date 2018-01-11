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
    case popularTvShow (language: String)
    case similarTvShow(id: Int, language: String)
    case bestRateTvShow ( language: String)
    case getVideos(id: Int, language: String)
    
    case findTvShow(query: String,language: String)
    case theTvDBLogin
    case theTvDBEpisode(episodeId: Int, Authorization: String)
    case theTvdbFindShow(name:String, authorization: String)
}

extension TvShowApi:  TargetType{
    // propertie to get the base url
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
        case .findTvShow:
            return URL(string: "https://api.themoviedb.org")!
        case .theTvDBLogin:
            return URL(string: "https://api.thetvdb.com")!
        case .theTvDBEpisode:
            return URL(string: "https://api.thetvdb.com")!
        case .theTvdbFindShow:
            return URL(string: "https://api.thetvdb.com")!
        }
    }
    // propertie to get the path
    public var path: String {
        switch self{
            
        case .popularTvShow:
            return "/3/tv/popular"
        case .similarTvShow(let id):
            return "/3/tv/\(id)/similar"
        case .bestRateTvShow:
            return "/3/tv/top_rated"
        case .getVideos(let id):
            return "/3/tv/\(id)/videos"
        case .findTvShow:
            return "/3/search/tv"
        case .theTvDBLogin:
            return "/login"
        case .theTvDBEpisode(let episodeId, _):
             return "/series/\(episodeId)/episodes"
        case .theTvdbFindShow:
             return "/search/series"
        }
    }
    // properties to get the method
    public var method: Moya.Method {
        switch self{
            
        case .popularTvShow:
            return .get
        case .similarTvShow:
            return .get
        case .bestRateTvShow:
            return .get
        case .getVideos:
            return .get
       
        case .findTvShow:
            return .get
       
        case .theTvDBEpisode:
            return .get
        case .theTvdbFindShow:
            return .get
        
        case .theTvDBLogin:
            return .post
        }
    }
    
    // i have no idea what it does
    public var sampleData: Data {
        switch self{
            
        
        case .popularTvShow:
             return "{}".data(using: String.Encoding.utf8)!
        case .similarTvShow:
             return "{}".data(using: String.Encoding.utf8)!
        case .bestRateTvShow:
             return "{}".data(using: String.Encoding.utf8)!
        case .getVideos:
             return "{}".data(using: String.Encoding.utf8)!
        case .findTvShow:
             return "{}".data(using: String.Encoding.utf8)!
        case .theTvDBLogin:
             return "{}".data(using: String.Encoding.utf8)!
        case .theTvDBEpisode:
             return "{}".data(using: String.Encoding.utf8)!
        case .theTvdbFindShow:
             return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    // properties to get parameter
    public var task: Task {
        
         let api = ApiConfiguration.config
        switch self{
        
        case .popularTvShow(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "page": 1], encoding: URLEncoding.default)
        case .similarTvShow(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "page": 1], encoding: URLEncoding.default)
        case .bestRateTvShow(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "page": 1], encoding: URLEncoding.default)
        case .getVideos(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language], encoding: URLEncoding.default)
        case .findTvShow(let query,let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "query": query, "page": 1], encoding: URLEncoding.default)
            
        case .theTvDBLogin:
            return .requestParameters(parameters: ["userkey": api.thetvdbUsername!, "username": api.thetvdbUsername!, "apikey": api.theTvDbApiKey!], encoding: URLEncoding.default)
            
        case .theTvDBEpisode:
            return .requestPlain

        case .theTvdbFindShow(let name):
            return .requestParameters(parameters: ["name": name], encoding: URLEncoding.default)
        }
    }
    
    // propertie to get header
    public var headers: [String : String]? {
        switch self{
            
        case .popularTvShow:
            return [:]
        case .similarTvShow:
            return [:]
        case .bestRateTvShow:
            return [:]
        case .getVideos:
            return [:]
       
        case .findTvShow:
            return [:]
        case .theTvDBLogin:
            return ["Cookie" : "__cfduid=df47b370f57362bb39426d245aace88f11515483423",
                    "Content-Type" : "application/json"]
        case .theTvDBEpisode(_, let authorization):
            return ["Authorization" : authorization,
                    "Content-Type" : "application/json"]
        case .theTvdbFindShow( _, let authorization):
            return ["Authorization" : authorization,
                    "Content-Type" : "application/json"]
        }
    }
}
