//
//  Episode.swift
//  Tv show app
//
//  Created by Yveslym on 1/11/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Mapper

struct Episodes: Mappable{
    
    var name: String?
    var overview: String?
    var airedDate: String?
    var seasonNumber: Int?
    var episodeNumber: Int?
    var id: Int?
    var voteAverage: Double?
    var voteCount: Int?
    private var still_path: String?
    var imageURL: URL?
    
    init(map: Mapper) throws {
        name = try map.from("name") ?? nil
        overview = try map.from("overview") ?? nil
        airedDate = try map.from("air_date") ?? nil
        seasonNumber = try map.from("season_number") ?? nil
        episodeNumber = try map.from("episode_number") ?? nil
        id = try map.from("id") ?? nil
        voteCount = try map.from("vote_count") ?? nil
        voteAverage = try map.from("vote_average") ?? nil
        still_path =  map.optionalFrom("still_path") ?? nil
        let imageBaseLink = "https://image.tmdb.org/t/p/w500"
        if still_path != nil{
        imageURL = URL(string: imageBaseLink+still_path!)
        }
    }
    
    
}

