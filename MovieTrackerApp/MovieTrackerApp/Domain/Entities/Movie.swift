//
//  Movie.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation

struct Movie {
    let title: String?
    let link: String?
    let releaseYear: Int?
    let director: String?
    let cast: String?
    let userRating: String?
}

struct Movies {
    var movies: [Movie]
}
