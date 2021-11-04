//
//  WatchedMoviesViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/04.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

protocol WatchedMoviesViewModelOutput {
    var items: Observable<Results<Item>> { get }
    var screenTitle: String { get }
}

protocol WatchedMoviesViewModel: WatchedMoviesViewModelOutput {}

final class DefaultWatchedMoviesViewModel: WatchedMoviesViewModel {
    private let realm = try! Realm()
    private var watchedMoviesLog: Results<Item>
    private var selectedGenre: Genre
    
    // MARK: - OUTPUT
    
    let items: Observable<Results<Item>>
    let screenTitle: String
    
    // MARK: - Init
    
    init(genre: Genre) {
        self.screenTitle = genre.title
        selectedGenre = genre
        watchedMoviesLog = selectedGenre.items.sorted(byKeyPath: "recordedOn", ascending: true)
        items = Observable.collection(from: watchedMoviesLog)
    }
}
