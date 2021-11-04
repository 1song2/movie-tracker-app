//
//  Genre.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import Foundation
import RealmSwift

class Genre: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var isShowing: Bool = true
    let items = List<Item>()
}

class Item: Object {
    @objc dynamic var movie: Movie? = Movie()
    @objc dynamic var watchedOn: Date = Date()
    @objc dynamic var notes: String = ""
    @objc dynamic var recordedOn: Date = Date()
    @objc dynamic var isBookmarked: Bool = false
    var parentGenre = LinkingObjects(fromType: Genre.self, property: "items")
}
