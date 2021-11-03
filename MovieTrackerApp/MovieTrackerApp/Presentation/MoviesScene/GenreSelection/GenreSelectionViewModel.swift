//
//  GenreSelectionViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation

struct GenreSelectionViewModelActions {
    let showMovieSearchPage: (Genre) -> Void
}

protocol GenreSelectionViewModelInput {
    func didSelectItem(at index: Int)
}

protocol GenreSelectionViewModelOutput {
    var items: [GenreViewModel] { get }
    var screenTitle: String { get }
}

protocol GenreSelectionViewModel: GenreSelectionViewModelInput, GenreSelectionViewModelOutput {}

final class DefaultGenreSelectionViewModel: GenreSelectionViewModel {
    private let actions: GenreSelectionViewModelActions?
    private let genreNames: [String] = [
        "드라마", "판타지",
        "서부", "공포",
        "로맨스", "모험",
        "스릴러", "느와르",
        "컬트", "다큐멘터리",
        "코미디", "가족",
        "미스터리", "전쟁",
        "애니메이션", "범죄",
        "뮤지컬", "SF",
        "액션", "무협",
        "에로", "서스펜스",
        "서사", "블랙코미디",
        "실험", "영화카툰",
        "영화음악", "영화패러디포스터"
    ]
    private var genres: [Genre] = []
    
    // MARK: - OUTPUT
    
    let items: [GenreViewModel]
    let screenTitle = NSLocalizedString("카테고리가 무엇인가요?", comment: "")
    
    // MARK: - Init
    
    init(actions: GenreSelectionViewModelActions? = nil) {
        self.actions = actions
        self.genres = genreNames.enumerated().map {
            Genre(code: ($0 + 1).description, name: $1)
        }
        items = genres.map(GenreViewModel.init)
    }
}

// MARK: - INPUT. View event methods

extension DefaultGenreSelectionViewModel {
    func didSelectItem(at index: Int) {
        actions?.showMovieSearchPage(genres[index])
    }
}
