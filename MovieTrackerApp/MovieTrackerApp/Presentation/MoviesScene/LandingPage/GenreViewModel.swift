//
//  GenreViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import Foundation

struct GenreViewModel {
    let code: String?
    let name: String
    
    init(genre: Genre) {
        self.code = genre.code
        self.name = (genre.code == nil) ? "전체" : genre.name
    }
}
