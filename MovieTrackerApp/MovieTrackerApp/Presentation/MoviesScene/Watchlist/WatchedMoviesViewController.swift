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
    
    private let disposeBag = DisposeBag()
    
    static func create() -> WatchedMoviesViewController {
        let view = WatchedMoviesViewController.instantiateViewController()
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let genre = ["영화제목", "영화제목", "영화제목"]
        tableView.dataSource = nil
        Observable.just(genre).bind(to: self.tableView.rx.items) { _, _, name in
            let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
            cell.textLabel?.text = name
            cell.imageView?.image = UIImage(named: "heart-fill")
            cell.detailTextLabel?.text = "2020.11.02"
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
