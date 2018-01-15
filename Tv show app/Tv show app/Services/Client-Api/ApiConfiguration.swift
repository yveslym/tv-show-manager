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
    
    ///configuration propertie
    static var config = ApiConfiguration()
    
    /// function to configure the TV Show Api
    static func TVShow(themoviedbApiKey: String){
    
        self.config.themoviedbApiKey = themoviedbApiKey
       
    }
}






















