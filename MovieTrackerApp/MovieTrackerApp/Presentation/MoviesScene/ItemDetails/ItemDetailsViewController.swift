//
//  ItemMovieDetailsViewController.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/10.
//

import UIKit
import RxSwift

class ItemDetailsViewController: UIViewController, StoryboardInstantiable {
    @IBOutlet weak var sectionView: UIView!
    @IBOutlet weak var releaseYearLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var watchedOnLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    private var viewModel: ItemDetailsViewModel!
    private let disposeBag = DisposeBag()
    
    static func create(with viewModel: ItemDetailsViewModel) -> ItemDetailsViewController {
        let view = ItemDetailsViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        navigationItem.rightBarButtonItem?.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.viewModel.didTapHeartButton()
            }).disposed(by: disposeBag)
        
        viewModel.isBookmarked
            .subscribe(onNext: { [weak self] in
                let image = $0 ? UIImage(named: "heart-fill") : UIImage(named: "heart")
                self?.navigationItem.rightBarButtonItem?.image = image
            }).disposed(by: disposeBag)
    }
    
    private func setupView() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: nil,
                                                            style: .plain,
                                                            target: self,
                                                            action: nil)
        title = viewModel.screenTitle
        
        sectionView.layer.cornerRadius = 16.0
        sectionView.clipsToBounds = true
        releaseYearLabel.text = viewModel.releaseYear
        directorLabel.text = viewModel.director
        castLabel.text = viewModel.cast
        
        watchedOnLabel.text = viewModel.watchedOn
        textView.text = viewModel.notes
        textView.layer.cornerRadius = 16.0
        textView.clipsToBounds = true
        textView.layer.borderWidth = 1.0
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isEditable = false
    }
}
