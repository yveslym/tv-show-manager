//
//  ApiConfiguration.swift
//  Tv show app
//
//  Created by Yveslym on 1/11/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation

class ApiConfiguration{
    
    /// propertie to hold the themoviedb Api key
     var themoviedbApiKey: String?
    
    /// propertie to hold thetvdb username
     var thetvdbUsername: String?
    
    /// propertie to hold thetvdb user Key
     var thetvdbUserKey: String?
    
    /// propertie to hold thetvdb api Key
     var theTvDbApiKey: String?
    
    ///
    static var config = ApiConfiguration()
    
    
    /// function to configure the TV Show Api
    static func TVShow(themoviedbApiKey: String, thetvdbUsername: String, thetvdbUserKey: String, theTvDbApiKey: String){
    
        self.config.themoviedbApiKey = themoviedbApiKey
        self.config.theTvDbApiKey = theTvDbApiKey
        self.config.thetvdbUserKey = thetvdbUserKey
        self.config.thetvdbUsername = thetvdbUsername
    }
}






















