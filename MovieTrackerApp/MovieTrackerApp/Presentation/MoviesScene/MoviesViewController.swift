//
//  ViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    static func create() -> MoviesViewController {
        return MoviesViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 영화 노트" // viewModel.screenTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: nil)
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: {
                print("button tapped")
            }).disposed(by: disposeBag)
    }
}
