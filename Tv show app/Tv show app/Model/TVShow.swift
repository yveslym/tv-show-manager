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
    var imageURL: URL?
    var genres: [Genre]?
    var runTime: [Int]?
    var status: String?
    var homepage: String?
    var network: String?
      var numberOfSeasons: Int?
    var seasons : [Season]?
   
    init(map: Mapper) throws {
        network = map.optionalFrom("networks")
        runTime = map.optionalFrom("episode_run_time")
        status = map.optionalFrom("status")
        id = map.optionalFrom("id")
        popularity =  map.optionalFrom("popularity")
        name =  map.optionalFrom("name")
        vote =  map.optionalFrom("vote_count")
        voteAverage =  map.optionalFrom("vote_average")
        overview =  map.optionalFrom("overview")
        posterPath = map.optionalFrom("poster_path") ?? nil
        firstAirDate =  map.optionalFrom("first_air_date")
        numberOfSeasons =  map.optionalFrom("number_of_seasons")
        genres =  map.optionalFrom("genres")
        homepage =  map.optionalFrom("homepage")
        let imageBaselink = "https://image.tmdb.org/t/p/w500"
        if posterPath != nil{
            imageURL = URL(string: imageBaselink+posterPath!)
        }
    }
   
}

extension TVSHow {
    init(){
        
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
         key = map.optionalFrom("key")
         size = map.optionalFrom("size")
         type = map.optionalFrom("type")
        link = baseLink+key!
    }
}
struct TVShowResult: Mappable{
    var result: [TVSHow]?
    init(map: Mapper) throws {
        result = try map.from("results")
    }
}







