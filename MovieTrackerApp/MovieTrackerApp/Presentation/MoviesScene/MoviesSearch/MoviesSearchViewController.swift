//
//  MoviesSearchViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift

class MoviesSearchViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    private let disposeBag = DisposeBag()
    private var searchController = UISearchController(searchResultsController: nil)
    
    static func create() -> MoviesSearchViewController {
        let view = MoviesSearchViewController.instantiateViewController()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let results = ["영화제목", "영화제목", "영화제목"]
        tableView.dataSource = nil
        Observable.just(results).bind(to: self.tableView.rx.items) { _, _, name in
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = name
            // cell.imageView?.image = UIImage(named: "heart-fill")
            cell.detailTextLabel?.text = "개봉일자, 평점"
            cell.accessoryType = .checkmark
            return cell
        }.disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { _ in
                // Go to review writing page
            }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        nextButton.layer.cornerRadius = 15.0
        nextButton.clipsToBounds = true
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
}

// MARK: - UISearchBarDelegate

extension MoviesSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        // viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // viewModel.didCancelSearch()
    }
}
