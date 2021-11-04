//
//  MoviesViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit
import RxSwift
import RxCocoa

class WatchedMoviesViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingButton: UIButton!
    
    private var viewModel: WatchedMoviesViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: WatchedMoviesViewModel) -> WatchedMoviesViewController {
        let view = WatchedMoviesViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = nil
        viewModel.items
            .bind(to: self.tableView.rx.items) { _, _, item in
                let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
                cell.textLabel?.text = item.movie?.title?.htmlEscaped
                cell.imageView?.image = item.isBookmarked ? UIImage(named: "heart-fill") : UIImage(named: "heart")
                cell.detailTextLabel?.text = dateFormatter.string(from: item.watchedOn)
                cell.accessoryType = .disclosureIndicator
                return cell
            }.disposed(by: disposeBag)
        
        sortingButton.rx.tap
            .subscribe(onNext: {
                let viewController = ModalViewController()
                viewController.modalPresentationStyle = .overCurrentContext
                self.present(viewController, animated: false)
            }).disposed(by: disposeBag)
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    return formatter
}()
