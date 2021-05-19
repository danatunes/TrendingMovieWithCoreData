//
//  MovieDetailedEntity.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 23.04.2021.
//

import Foundation

struct MovieDetailedModel : Decodable {
    var id : Int?
    let title : String
    let poster : String?
    let releaseDate : String
    let rating : Double
    let description : String
    
    enum CodingKeys : String , CodingKey {
        case poster = "poster_path"
        case title = "original_title"
        case releaseDate = "release_date"
        case rating = "vote_average"
        case description = "overview"
    }
    
}
