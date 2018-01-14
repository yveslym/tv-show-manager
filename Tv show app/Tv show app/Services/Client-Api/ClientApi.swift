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
    case popularTvShow (language: Language)
    case similarTvShow(id: Int, language: Language)
    case bestRateTvShow ( language: Language)
    case getVideos(id: Int, language: Language)
    case getSeasons(tvShowID: Int, seasonNumber: Int,language: Language)
    case findTvShow(query: String,language: Language)
    case TVShowDetail(id: Int, language: Language)
}

extension TvShowApi:  TargetType{
    // propertie to get the base url
    public var baseURL: URL{
        switch self{
            
        case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons:
            return URL(string: "https://api.themoviedb.org")!
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
        case .getSeasons(let id,let number, _):
            return "/3/tv/\(id)/season/\(number)"
       
        case .TVShowDetail(let id,_):
             return "/3/tv/\(id)"
        }
    }
    // properties to get the method
    public var method: Moya.Method {
        switch self{
            
        case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons:
            return .get
        }
    }
    
    // i have no idea what it does
    public var sampleData: Data {
        switch self{
            
        case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons:
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
      
        case .getSeasons(_,_, let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language], encoding: URLEncoding.default)
       
        case .TVShowDetail(_, let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language], encoding: URLEncoding.default)
        }
    }
    
    // propertie to get header
    public var headers: [String : String]? {
        switch self{
         case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons:
            return [:]
        }
    }
}
