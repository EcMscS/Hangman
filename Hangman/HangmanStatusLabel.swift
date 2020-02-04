//
//  HangmanStatusLabel.swift
//  Hangman
//
//  Created by Greg Wu on 1/29/20.
//  Copyright © 2020 Greg Wu. All rights reserved.
//

import UIKit

class HangmanStatusLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(textLabel: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        text = textLabel
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
    }
    
}
