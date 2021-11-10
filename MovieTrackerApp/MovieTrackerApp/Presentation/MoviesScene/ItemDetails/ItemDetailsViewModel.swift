//
//  ItemDetailsViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/10.
//

import Foundation
import RealmSwift
import RxRelay

struct ItemDetailsViewModelActions {
    let launchSafari: (URL) -> Void
}

protocol ItemDetailsViewModelInput {
    func didTapHeartButton()
    func didTapSectionView()
}

protocol ItemDetailsViewModelOutput {
    var screenTitle: String { get }
    var isBookmarked: BehaviorRelay<Bool> { get }
    var releaseYear: String { get }
    var director: String { get }
    var cast: String { get }
    var watchedOn: String { get }
    var notes: String { get }
}

protocol ItemDetailsViewModel: ItemDetailsViewModelInput, ItemDetailsViewModelOutput {}

final class DefaultItemDetailsViewModel: ItemDetailsViewModel {
    private let realm = try! Realm()
    private let actions: ItemDetailsViewModelActions?
    private let item: Item
    
    // MARK: - OUTPUT
    
    let screenTitle: String
    var isBookmarked: BehaviorRelay<Bool>
    let releaseYear: String
    let director: String
    let cast: String
    let watchedOn: String
    let notes: String
    
    // MARK: - Init
    
    init(item: Item,
         actions: ItemDetailsViewModelActions? = nil) {
        self.actions = actions
        self.item = item
        self.screenTitle = item.movie?.title?.htmlEscaped ?? ""
        self.isBookmarked = BehaviorRelay<Bool>(value: item.isBookmarked)
        self.releaseYear = item.movie?.releaseYear ?? ""
        self.director = item.movie?.director?.trimmingCharacters(in: ["|"]) ?? ""
        self.cast = item.movie?.cast?
            .trimmingCharacters(in: ["|"])
            .replacingOccurrences(of: "|", with: ", ") ?? ""
        self.watchedOn = DateFormatter.medium.string(from: item.watchedOn)
        self.notes = item.notes
    }
}

// MARK: - INPUT. View event methods

extension DefaultItemDetailsViewModel {
    func didTapHeartButton() {
        do {
            try realm.write {
                item.isBookmarked = !item.isBookmarked
                isBookmarked.accept(item.isBookmarked)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func didTapSectionView() {
        guard let link = item.movie?.link, let url = URL(string: link) else { return }
        actions?.launchSafari(url)
    }
}
