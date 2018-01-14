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
        airDate = try map.from("air_date")
        id = try map.from("id")
        overview = try map.from("overview")
        posterPath = try map.from("poster_path")
        seasonNumber = try map.from("season_number")
         episodes = try map.from("episodes")
        let imageBaseLink = "https://image.tmdb.org/t/p/w500"
        imageURL = URL(string: imageBaseLink+posterPath!)
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




