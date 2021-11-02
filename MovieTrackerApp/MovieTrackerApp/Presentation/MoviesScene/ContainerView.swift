//
//  ContainerView.swift
//  MovieTrackerApp
//
//  Created by Song on 2021/11/02.
//

import UIKit

class ContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        if #available(iOS 13, *) {
            self.backgroundColor = .systemBackground
        } else {
            self.backgroundColor = .white
        }
        self.layer.cornerRadius = 16.0
        self.clipsToBounds = true
    }
}
