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
        name = try map.from("name")
        overview = try map.from("overview")
        airedDate = try map.from("air_date")
        seasonNumber = try map.from("season_number")
        episodeNumber = try map.from("episode_number")
        id = try map.from("id")
        voteCount = try map.from("vote_count")
        voteAverage = try map.from("vote_average")
        still_path = try map.from("still_path")
        let imageBaseLink = "https://image.tmdb.org/t/p/w500"
        imageURL = URL(string: imageBaseLink+still_path!)
    }
    
    
}

