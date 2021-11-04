//
//  Movie.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import Foundation
import RealmSwift

class Movie: Object {
    @objc dynamic var title: String?
    @objc dynamic var link: String?
    @objc dynamic var releaseYear: String?
    @objc dynamic var director: String?
    @objc dynamic var cast: String?
    @objc dynamic var userRating: String?
    
    convenience init(title: String?,
                     link: String?,
                     releaseYear: String?,
                     director: String?,
                     cast: String?,
                     userRating: String?) {
        self.init()
        
        self.title = title
        self.link = link
        self.releaseYear = releaseYear
        self.director = director
        self.cast = cast
        self.userRating = userRating
    }
}

struct Movies {
    var movies: [Movie]
}
