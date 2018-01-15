//
//  Season.swift
//  Tv show app
//
//  Created by Yveslym on 1/13/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Mapper

struct Season: Mappable{
    
    var airDate: String?
    var id: Int?
    var overview: String?
    var imageURL: URL?
    var seasonNumber: Int?
    private var posterPath: String?
    var episodes: [Episodes]?
    
    
    init(map: Mapper) throws {
        airDate = try map.from("air_date") ?? nil
        id = try map.from("id") ?? nil
        overview = try map.from("overview") ?? nil
        posterPath = map.optionalFrom("poster_path")
        seasonNumber = try map.from("season_number") ?? nil
         episodes = map.optionalFrom("episodes")
        let imageBaseLink = "https://image.tmdb.org/t/p/w500"
        if posterPath != nil{ imageURL = URL(string: imageBaseLink+posterPath!) }
    }
}
extension Season{
    init(){
        
    }
}

struct Genre: Mappable{
    init(map: Mapper) throws {
        name = try map.from("name")
        id = try map.from("id")
    }
    
   var name: String?
    var id: Int?
}

struct ShowsID: Mappable{
    init(map: Mapper) throws {
        id = try map.from("id")
    }
    var id: Int?
}

struct ShowIDResult: Mappable{
   
    let results: [ShowsID]?
    init(map: Mapper) throws {
        results = try map.from("results")
    }
}




