//
//  Route.swift
//  Tv show app
//
//  Created by Yveslym on 1/9/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import KeychainSwift
class Route{
    
    
}

enum DBRoute: String{
    case popularTvShow = "https://api.themoviedb.org/3/tv/popular"
    case similarTvShow = "https://api.themoviedb.org/3/tv/1399/similar"
    case bestRateTvShow = "https://api.themoviedb.org/3/tv/top_rated"
    case getVideos = "https://api.themoviedb.org/3/tv/1399/videos"
    case findTvShow = "https://api.themoviedb.org/3/search/tv"
   // case thetvdbLogin = "https://api.thetvdb.com/login"
    case findEpisode = "https://api.thetvdb.com/series/"
    case theTvdbFindShow = "https://api.thetvdb.com/search/series"
    case getUser = "https://api-show-bix.herokuapp.com/v1/sessions/"
    case createAccount = " https://api-show-bix.herokuapp.com/v1/sessions/"
    case logOut = "https://api-show-bix.herokuapp.com/v1/sessions/ "
    
    func httpBody()-> Data?{
        
        switch self {
        case .popularTvShow: fallthrough
        case .similarTvShow: fallthrough
        case .bestRateTvShow: fallthrough
        case .getVideos: fallthrough
        case .findTvShow: fallthrough
        case .theTvdbFindShow: return nil
//        case .thetvdbLogin:
//            let body = [
//                "apikey": "63BACB580FC7C248",
//                "userkey": "D0DFD1EBB2AC406B",
//                "username": "yveslym"
//            ]
//            let data = try! JSONEncoder().encode(body)
//            return data
        case .findEpisode:
            return nil
        case .getUser:
            return nil
        case .createAccount:
            let body = [
                "name": User.currentUser.name ?? "",
                "eamil": User.currentUser.email!,
                "password": User.currentUser.password!,
                "userName": User.currentUser.userName!
            ]
            return try! JSONEncoder().encode(body)
        case .logOut:
            return nil
        }
    }
    func parameters(tvShowName: String? = nil) -> [String:String]?{
                
            switch self{
            //case .thetvdbLogin:
              // return nil
            case .popularTvShow:
                let URLParams = [
                    "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
                    "language": "en-US",
                    "page": "1",
                ]
            return URLParams
                
            case .similarTvShow:
                let URLParams = [
                    "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
                    "language": "en-US",
                    "page": "1",
                ]
                return URLParams
                
            case .bestRateTvShow:
                let URLParams = [
                    "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
                    "language": "en-US",
                    "page": "1",
                ]
                return URLParams
            case .getVideos:
                let URLParams = [
                    "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
                    "language": "en-US",
                ]
                return URLParams
                
            case .findTvShow:
                let URLParams = [
                    "api_key": "427d56490d26ac41ba7eb76387dcf1fe",
                    "language": "en-US",
                    "query": tvShowName,
                    "page": "1",
                    ]
                return URLParams as? [String : String]
            case .theTvdbFindShow:
                let URLParams = [
                    "name": tvShowName,
                    ]
                return URLParams as? [String : String]
            case .findEpisode:
                return nil
            case .getUser:
                return nil
            case .createAccount:
                return nil
            case .logOut:
                return nil
        }
        }
    
    func extrasUrl(tvShowId: Int? = nil) -> String?{
        switch self{
            
        case .popularTvShow:
            return nil
        case .similarTvShow:
            return nil
        case .bestRateTvShow:
            return nil
        case .getVideos:
            let extra = ("\(tvShowId ?? 0)/videos")
            return extra
        case .findTvShow:
            return nil
        case .findEpisode:
            let extra = ("\(tvShowId ?? 0)/episodes")
            return extra
        case .theTvdbFindShow:
            let id = String(tvShowId!)
            return id
        case .getUser:
            return nil
        case .createAccount:
            return nil
        case .logOut:
            return nil
        }
    }
    
    func headers(Authorization: String? = nil)-> [String: String]?{
        switch self{
            
        case .popularTvShow:
            return nil
        case .similarTvShow:
            return nil
        case .bestRateTvShow:
            return nil
        case .getVideos:
            return nil
        case .findTvShow:
            return nil
//        case .thetvdbLogin:
//            return ["application/json":"Content-Type"]
        case .findEpisode:
            return ["application/json":"Content-Type",
                    Authorization!:"Authorization"]
        case .theTvdbFindShow:
             return ["application/json":"Content-Type",
                     Authorization!:"Authorization"]
        case .getUser:
            let email: String? = KeychainSwift().get("email")
            let token: String? = KeychainSwift().get("email")
            
            return ["x-User-Email": email ?? "",
                    "x-User-Token": token ?? ""]
            
        case .createAccount:
            return nil
        case .logOut:
            let email: String? = KeychainSwift().get("email")
            let token: String? = KeychainSwift().get("email")
            
            return ["x-User-Email": email ?? "",
                    "x-User-Token": token ?? ""]
        }
    }
}































