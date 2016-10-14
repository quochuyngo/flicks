//
//  Movie.swift
//  Flicks
//
//  Created by Quoc Huy Ngo on 10/13/16.
//  Copyright © 2016 Quoc Huy Ngo. All rights reserved.
//

import Foundation

class Movie{
    var poster:String!
    var title:String!
    var overview:String!
    var releaseDate:String!
    var voteAverage:Float!
    var popularity:Float!
    init(){
    }
    
    init(data:NSDictionary){
        self.poster = data.value(forKey: "poster_path") as? String
        self.title = data.value(forKey:"title") as? String
        self.releaseDate = data.value(forKey: "release_date") as? String
        self.overview = data.value(forKey: "overview") as? String
        self.voteAverage = data.value(forKey: "vote_average") as? Float
        self.popularity = data.value(forKey: "popularity") as? Float
    }
}
