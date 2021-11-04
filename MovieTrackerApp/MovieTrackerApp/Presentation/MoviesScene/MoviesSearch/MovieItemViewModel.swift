//
//  MovieItemViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation

struct MovieItemViewModel: Equatable {
    let title: String
    let description: String
}

extension MovieItemViewModel {
    init(movie: Movie) {
        self.title = movie.title?.htmlEscaped ?? ""
        
        let releaseYear = movie.releaseYear
        var userRating = movie.userRating
        
        userRating = (userRating == "0.00" || userRating == nil) ? nil : userRating
        
        let separator = (releaseYear != "" && userRating != nil) ? ", " : ""
        self.description = [releaseYear ?? "", userRating ?? ""].joined(separator: separator)
    }
}
