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
    
    private var viewModel: MoviesSearchViewModel!
    private let disposeBag = DisposeBag()
    private var searchController = UISearchController(searchResultsController: nil)
    
    static func create(with viewModel: MoviesSearchViewModel) -> MoviesSearchViewController {
        let view = MoviesSearchViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = nil
        
        viewModel.items
            .bind(to: self.tableView.rx.items) { _, _, item in
                let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
                cell.textLabel?.text = item.title
                cell.detailTextLabel?.text = item.description
                cell.selectionStyle = .none
                return cell
            }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didSelectItem(at: $0.row)
                self?.tableView.cellForRow(at: $0)?.accessoryType = .checkmark
            }).disposed(by: disposeBag)
        
        tableView.rx.itemDeselected
            .subscribe(onNext: { [weak self] in
                self?.tableView.cellForRow(at: $0)?.accessoryType = .none
            }).disposed(by: disposeBag)
        
        nextButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.viewModel.didTapNextButton()
            }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        title = viewModel.screenTitle
        navigationItem.prompt = viewModel.promptTitle
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
        viewModel.didSearch(query: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didCancelSearch()
    }
}
