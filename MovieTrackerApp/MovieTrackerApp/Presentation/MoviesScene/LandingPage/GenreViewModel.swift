//
//  GenreViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import Foundation

struct GenreViewModel {
    let name: String
    
    init(genre: Genre) {
        self.name = genre.name
    }
}
