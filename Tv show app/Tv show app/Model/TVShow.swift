//
//  TVShow.swift
//  Tv show app
//
//  Created by Yveslym on 1/11/18.
//  Copyright © 2018 Yveslym. All rights reserved.
//

import Foundation
import Mapper
import Moya

struct TVSHow: Mappable{
    
    var name: String?
    var id: Int?
    var popularity: Double?
    var vote: Int?
    var firstAirDate: String?
    var voteAverage: Double?
    var overview: String?
    var posterPath:String?
    var image: String?
    var genres: [Genre]?
    var homepage: String?
      var numberOfSeasons: Int?
    var seasons = [Season]()
    private var manager = TVSHowManager()
   
    init(map: Mapper) throws {
        id = try map.from("id")
        popularity = try map.from("popularity")
        name = try map.from("name")
        vote = try map.from("vote_count")
        voteAverage = try map.from("vote_average")
        overview = try map.from("overview")
        posterPath = try map.from("poster_path")
        firstAirDate = try map.from("first_air_date")
        numberOfSeasons = try map.from("number_of_seasons")
        genres = try map.from("genres")
        homepage = try map.from("homepage")
        let imageBaselink = "https://image.tmdb.org/t/p/w500"
        image = imageBaselink+posterPath!
        
        
        
        
    }
}
struct videoModel: Mappable{
    var key: String?
    var link: String?
    var size: String?
    var type: String?
    init(){
        key = ""
        link = ""
        size = ""
        type = ""

    }
    init(map: Mapper) throws {
        let baseLink: String = "https://www.youtube.com/watch?v="
        try key = map.from("key")
        try size = map.from("size")
        try type = map.from("type")
        link = baseLink+key!
    }
}
struct TVShowResult: Mappable{
    var result: [TVSHow]?
    init(map: Mapper) throws {
        result = try map.from("results")
    }
}







