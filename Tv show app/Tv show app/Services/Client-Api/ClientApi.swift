//
//  ClientApi.swift
//  Tv show app
//
//  Created by Yveslym on 1/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Moya
import KeychainSwift

enum TvShowApi{
    case popularTvShow (language: Language)
    case similarTvShow(id: Int, language: Language)
    case bestRateTvShow ( language: Language)
    case getVideos(id: Int, language: Language)
    case getSeasons(tvShowID: Int, seasonNumber: Int,language: Language)
    case findTvShow(query: String,language: Language)
    case TVShowDetail(id: Int, language: Language)
    case airingToday(language: Language)
    case discover (language: Language, page: Int)
    case createUser
    case logOut
    case getUser
    case login
}

extension TvShowApi:  TargetType{
    // propertie to get the base url
    public var baseURL: URL{
        switch self{
            
        case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons,.airingToday, .discover:
            return URL(string: "https://api.themoviedb.org")!
        case .createUser, .logOut, .getUser, .login:
            return URL(string:"https://api-show-bix.herokuapp.com")!
      
        }
    }
    // propertie to get the path
    public var path: String {
        switch self{
            
        case .popularTvShow:
            return "/3/tv/popular"
        case .similarTvShow(let id, _):
            return "/3/tv/\(id)/similar"
        case .bestRateTvShow:
            return "/3/tv/top_rated"
        case .getVideos(let id, _):
            return "/3/tv/\(id)/videos"
        case .findTvShow:
            return "/3/search/tv"
        case .getSeasons(let id,let number, _):
            return "/3/tv/\(id)/season/\(number)"
       
        case .TVShowDetail(let id,_):
             return "/3/tv/\(id)"
        case .airingToday:
            return "/3/tv/airing_today"
        case .discover:
            return "/3/discover/tv"
        case .createUser, .logOut, .getUser:
            return "/v1/sessions"
        case .login:
             return "/v1/login"
        }
    }
    // properties to get the method
    public var method: Moya.Method {
        switch self{
            
        case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons, .airingToday, .discover, .getUser:
            return .get
       
        case .createUser, .login:
            return .post
        case .logOut:
            return .delete
        
        }
    }
    
    // i have no idea what it does
    public var sampleData: Data {
        switch self{
            
        case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons, .airingToday, .discover, .createUser, .logOut, .getUser, .login:
           
            return "{}".data(using: String.Encoding.utf8)!
        }
    }
    
    // properties to get parameter
    public var task: Task {
        
         let api = ApiConfiguration.config
        switch self{
        
        case .popularTvShow(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "page": 1,"with_runtime.gte": "40"], encoding: URLEncoding.default)
        case .similarTvShow(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "page": 1, "with_runtime.gte": "40"], encoding: URLEncoding.default)
        case .bestRateTvShow(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "page": 1, "with_runtime.gte": "40"], encoding: URLEncoding.default)
        case .getVideos(let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language], encoding: URLEncoding.default)
        case .findTvShow(let query,let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "query": query, "page": 1], encoding: URLEncoding.default)
      
        case .getSeasons(_,_, let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language], encoding: URLEncoding.default)
       
            
        case .TVShowDetail(_, let language):
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language], encoding: URLEncoding.default)
            
        case .airingToday(let language):
             return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "with_runtime.gte": "40"], encoding: URLEncoding.default)
        case .discover( let language, let page):
            let sort = ["popularity.desc","vote_average.desc",]
            let date = ["2010","2011","2012","2013","2014","2015"]
            let genre = ["18","10759","10765"]
            let sortRan = arc4random_uniform(2)
            
           
            return .requestParameters(parameters: ["api_key": api.themoviedbApiKey!, "language": language, "sort_by": sort[Int(sortRan)], "page": page, "with_genres": genre[Int(arc4random_uniform(3))], "with_runtime.gte": "40", "air_date.gte": date[Int(arc4random_uniform(6))]], encoding: URLEncoding.default)
            
        case .createUser:
            return .requestParameters(parameters: ["email": User.currentUser.email!, "username":  User.currentUser.userName!, "password":  User.currentUser.password!, "name": User.currentUser.name ?? ""], encoding: URLEncoding.default)

        case .logOut: fallthrough
        case .getUser:
             return .requestPlain
        case .login:
             return .requestParameters(parameters: ["email":  User.currentUser.email!, "password":  User.currentUser.password!], encoding: URLEncoding.queryString)
        }
    }
    
    // propertie to get header
    public var headers: [String : String]? {
        switch self{
         case .popularTvShow, .bestRateTvShow, .similarTvShow, .TVShowDetail, .findTvShow, .getVideos, .getSeasons, .airingToday:
            return [:]
        case .discover:
            return [:]
        case .createUser, .login:
             return ["Content-Type" : "application/json; charset=utf-8"]
        case .logOut:  fallthrough
           
        case .getUser:
            let email: String? = KeychainSwift().get("email")
            let token: String? = KeychainSwift().get("token")
            
            return ["x-User-Email": email ?? "",
                    "x-User-Token": token ?? ""]
        }
    }
}
