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
        
        var convertedReleaseYear = ""
        if let releaseYear = releaseYear {
            convertedReleaseYear = "\(releaseYear)"
        }
        
        userRating = (userRating == "0.00" || userRating == nil) ? nil : userRating
        
        let separator = (releaseYear != nil && userRating != nil) ? ", " : ""
        self.description = [convertedReleaseYear, userRating ?? ""].joined(separator: separator)
    }
}