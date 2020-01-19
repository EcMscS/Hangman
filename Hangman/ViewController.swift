//
//  ViewController.swift
//  Hangman
//
//  Created by Greg Wu on 1/14/20.
//  Copyright © 2020 Greg Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var hangmanStatusLabel: UILabel!
    var wordLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    
    var word: String = ""
    var wordCharacters = [String]()
    var lettersGuessed = [String]()
    var numberOfGuesses: Int = 0 {
        didSet {
            hangmanStatusLabel.text = "\(numberOfGuesses) guesses left!"
        }
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        hangmanStatusLabel = UILabel()
        hangmanStatusLabel.backgroundColor = .systemBlue
        hangmanStatusLabel.translatesAutoresizingMaskIntoConstraints = false
        hangmanStatusLabel.textAlignment = .center
        hangmanStatusLabel.font = UIFont.systemFont(ofSize: 32)
        hangmanStatusLabel.text = "7 guesses left!"
        view.addSubview(hangmanStatusLabel)
        
        wordLabel = UILabel()
        wordLabel.backgroundColor = .systemBlue
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 34)
        wordLabel.text = "WORD"
        view.addSubview(wordLabel)
        
        // Create container view for letter buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            hangmanStatusLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            hangmanStatusLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            hangmanStatusLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            wordLabel.topAnchor.constraint(equalTo: hangmanStatusLabel.bottomAnchor, constant: 50),
            wordLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 300),
            buttonsView.heightAnchor.constraint(equalToConstant: 250),
            buttonsView.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 50),
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // Create 30 buttons (26 letters + 4 blank) on a 6x5 grid and place in buttonsView container
        let buttonWidth = 50
        let buttonHeight = 50
        let buttonText = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", ""]
        
        var buttonIndex = 0
        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.systemBlue.cgColor
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 28)
                letterButton.setTitle(buttonText[buttonIndex], for: .normal)
                letterButton.frame = CGRect(x: column * buttonWidth, y: row * buttonHeight, width: buttonWidth, height: buttonHeight)
                
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                
                buttonsView.addSubview(letterButton)
                letterButtons.append(letterButton)
                
                buttonIndex += 1
            }
        }
        
        // Hide blank buttons
        for buttonIndex in 26...29 {
            letterButtons[buttonIndex].isHidden = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Hangman"
    }
    
    @objc func letterTapped() {
        
    }


}

