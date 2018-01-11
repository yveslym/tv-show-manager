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
    
    var episodeName: String?
    var overview: String?
    var airedDate: String?
    var seasonNumber: Int?
    var episodeNumber: Int?
    
    init(map: Mapper) throws {
        episodeName = try map.from("episodeName")
        overview = try map.from("overview")
        airedDate = try map.from("firstAired")
        seasonNumber = try map.from("airedSeason")
        episodeNumber = try map.from("airedEpisodeNumber")
    }
    
    
}

