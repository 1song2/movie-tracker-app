//
//  ReviewWritingViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation
import RealmSwift

struct ReviewWritingViewModelActions {
    let goToLandingPage: () -> Void
}

protocol ReviewWritingViewModelInput {
    func didTapDoneButton(watchedOn: Date?, notes: String?)
}

protocol ReviewWritingViewModelOutput {
    var screenTitle: String { get }
}

protocol ReviewWritingViewModel: ReviewWritingViewModelInput, ReviewWritingViewModelOutput {}

final class DefaultReviewWritingViewModel: ReviewWritingViewModel {
    private let realm = try! Realm()
    private let actions: ReviewWritingViewModelActions?
    private var genre: Genre
    private var movie: Movie
    
    // MARK: - OUTPUT
    
    let screenTitle: String
    
    // MARK: - Init
    
    init(genre: Genre,
         movie: Movie,
         actions: ReviewWritingViewModelActions? = nil) {
        self.screenTitle = movie.title?.htmlEscaped ?? ""
        self.genre = genre
        self.movie = movie
        self.actions = actions
    }
}

// MARK: - INPUT. View event methods

extension DefaultReviewWritingViewModel {
    func didTapDoneButton(watchedOn: Date?, notes: String?) {
        actions?.goToLandingPage()
        do {
            try realm.write {
                let newItem = Item()
                newItem.movie = movie
                newItem.watchedOn = watchedOn ?? Date()
                newItem.notes = notes ?? ""
                genre.items.append(newItem)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
