//
//  ViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/01.
//

import UIKit

class MoviesViewController: UIViewController {
    static func create() -> MoviesViewController {
        return MoviesViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 영화 노트" // viewModel.screenTitle
    }
}
