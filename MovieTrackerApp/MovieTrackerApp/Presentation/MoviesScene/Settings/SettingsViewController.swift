//
//  SettingsViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/04.
//

import UIKit
import RxSwift

class SettingsViewController: UITableViewController {
    private var viewModel: SettingsViewModel!
    private let disposeBag = DisposeBag()
    private let emptyDataLabel = UILabel()
    
    static func create(with viewModel: SettingsViewModel) -> SettingsViewController {
        let view = SettingsViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didAddNewGenre()
            }).disposed(by: disposeBag)
                
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        tableView.dataSource = nil
        viewModel.items
            .bind(to: self.tableView.rx.items(cellIdentifier: "Cell",
                                              cellType: UITableViewCell.self)) { _, item, cell in
                cell.textLabel?.text = item.title
                cell.accessoryView = UISwitch()
            }.disposed(by: disposeBag)
        
        viewModel.items
            .map { !$0.isEmpty }
            .bind(to: emptyDataLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func setupView() {
        title = viewModel.screenTitle
        emptyDataLabel.text = viewModel.emptyDataTitle
        emptyDataLabel.textColor = .gray
        emptyDataLabel.font = UIFont.preferredFont(forTextStyle: .body)
        emptyDataLabel.adjustsFontForContentSizeCategory = true
        view.addSubview(emptyDataLabel)
        emptyDataLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyDataLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyDataLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50.0)
        ])
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
    }
}
