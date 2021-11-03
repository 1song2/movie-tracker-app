//
//  MoviesSearchViewModel.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/03.
//

import Foundation
import RxSwift

struct MoviesSearchViewModelActions {
    let showReviewWriting: (Movie) -> Void
}

protocol MoviesSearchViewModelInput {
    func didSearch(query: String)
    func didCancelSearch()
    func didSelectItem(at index: Int)
    func didTapNextButton()
}

protocol MoviesSearchViewModelOutput {
    var items: BehaviorSubject<[MovieItemViewModel]> { get }
    var selectedItem: BehaviorSubject<Movie?> { get }
    var searchText: String { get }
    var genreCode: String? { get }
    var error: PublishSubject<String> { get }
    var screenTitle: String { get }
    var promptTitle: String { get }
    var errorTitle: String { get }
}

protocol MoviesSearchViewModel: MoviesSearchViewModelInput, MoviesSearchViewModelOutput {}

final class DefaultMoviesSearchViewModel: MoviesSearchViewModel {
    private var disposeBag = DisposeBag()
    private let apiClient: APIClient
    private let actions: MoviesSearchViewModelActions?
    private var movies: Movies = Movies(movies: [])
    
    // MARK: - OUTPUT
    
    let items: BehaviorSubject<[MovieItemViewModel]> = BehaviorSubject<[MovieItemViewModel]>(value: [])
    var selectedItem: BehaviorSubject<Movie?> = BehaviorSubject<Movie?>(value: nil)
    var searchText: String = ""
    let genreCode: String?
    let error: PublishSubject<String> = PublishSubject<String>()
    let screenTitle = NSLocalizedString("영화 이름이 무엇인가요?", comment: "")
    let promptTitle: String
    let errorTitle = NSLocalizedString("Error", comment: "")
    
    // MARK: - Init
    
    init(genre: Genre,
         apiClient: APIClient,
         actions: MoviesSearchViewModelActions? = nil) {
        self.promptTitle = "장르: \(genre.name)"
        self.genreCode = genre.code
        self.actions = actions
        self.apiClient = apiClient
    }
    
    // MARK: - Private
    
    private func resetPages() {
        selectedItem.onNext(nil)
        movies.movies.removeAll()
        items.onNext([])
    }
    
    private func load(searchText: String) {
        self.searchText = searchText
        apiClient.getMovies(query: MovieQuery(query: searchText, genre: genreCode))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.movies = $0.toDomain()
                self.items.onNext(self.movies.movies.map(MovieItemViewModel.init))
            }, onError: { [weak self] in
                self?.handle(error: $0)
            })
            .disposed(by: disposeBag)
    }
    
    private func handle(error: Error) {
        print(error.localizedDescription)
    }
    
    private func update(searchText: String) {
        resetPages()
        load(searchText: searchText)
    }
}

// MARK: - INPUT. View event methods

extension DefaultMoviesSearchViewModel {
    func didSearch(query: String) {
        guard !query.isEmpty else { return }
        update(searchText: query)
    }
    
    func didCancelSearch() {
        disposeBag = DisposeBag()
    }
    
    func didSelectItem(at index: Int) {
        selectedItem.onNext(movies.movies[index])
    }
    
    func didTapNextButton() {
        guard let selectedItem = try? selectedItem.value() else { return }
        actions?.showReviewWriting(selectedItem)
    }
}
