//
//  WordLabel.swift
//  Hangman
//
//  Created by Greg Wu on 1/29/20.
//  Copyright © 2020 Greg Wu. All rights reserved.
//

import UIKit

class WordLabel: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .systemBlue
        translatesAutoresizingMaskIntoConstraints = false
        textAlignment = .center
        font = UIFont.systemFont(ofSize: 34)
        text = " "
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
