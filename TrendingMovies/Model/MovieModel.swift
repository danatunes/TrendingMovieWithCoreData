//
//  MovieEntity.swift
//  TrendingMovies
//
//  Created by Магжан Бекетов on 20.04.2021.
//

import Foundation

struct MovieModel : Decodable {
    let results : [Movie]
    
    struct Movie : Decodable {
        let id : Int
        let poster : String?
        let title : String?
        let releaseDate : String?
        let rating : Double?
        let description : String?
        
        enum CodingKeys : String , CodingKey {
            case id
            case poster = "poster_path"
            case title = "original_title"
            case releaseDate = "release_date"
            case rating = "vote_average"
            case description = "overview"
        }
        
        init(movie : MovieEntity){
            self.id = Int(movie.id)
            self.title = movie.title
            self.poster = movie.poster
            self.releaseDate = movie.releaseDate
            self.rating = movie.rating
            self.description = nil
        }
        
    }
}
