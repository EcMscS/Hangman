//
//  LetterButton.swift
//  Hangman
//
//  Created by Greg Wu on 1/29/20.
//  Copyright © 2020 Greg Wu. All rights reserved.
//

import UIKit

class LetterButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(letter: String) {
        super.init(frame: .zero)
        setTitle(letter, for: .normal)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.systemBlue.cgColor
        layer.cornerRadius = 10
    }
}
