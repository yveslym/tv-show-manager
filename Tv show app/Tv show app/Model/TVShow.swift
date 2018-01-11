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
   
    init(map: Mapper) throws {
        try id = map.from("id")
        try popularity = map.from("popularity")
        try name = map.from("name")
        try vote = map.from("vote_count")
        try voteAverage = map.from("vote_average")
        try overview = map.from("overview")
        try posterPath = map.from("poster_path")
        try firstAirDate = map.from("first_air_date")
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







