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
    var activatedButtons = [UIButton]()  // Stores pressed and hidden letter buttons so they can be restored in new game
    
    var wordBank = [String]()
    var word: String = ""
    var wordLetters = [String]()
    var wordLabelCharacters = [String]() {
        didSet {
            wordLabel.text = wordLabelCharacters.joined()
        }
    }
    var missedGuesses: Int = 0 {
        didSet {
            if missedGuesses < 6 {
                hangmanStatusLabel.text = "\(7 - missedGuesses) lives left!"
            } else if missedGuesses == 6 {
                hangmanStatusLabel.text = "1 life left!"
            } else {
                hangmanStatusLabel.text = "0 lives left!"
            }
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
        hangmanStatusLabel.text = "7 lives left!"
        view.addSubview(hangmanStatusLabel)
        
        wordLabel = UILabel()
        wordLabel.backgroundColor = .systemBlue
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.textAlignment = .center
        wordLabel.font = UIFont.systemFont(ofSize: 34)
        wordLabel.text = " "
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
        
        // Create 30 buttons (26 letters + 4 blank) on a 5x6 grid and place in buttonsView container
        let buttonWidth = 50
        let buttonHeight = 50
        let buttonText = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "", "", "", ""]
        
        var buttonIndex = 0
        for row in 0..<5 {
            for column in 0..<6 {
                let letterButton = UIButton(type: .system)
                letterButton.layer.borderWidth = 1
                letterButton.layer.borderColor = UIColor.systemBlue.cgColor
                letterButton.layer.cornerRadius = 10
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
        
        loadWordBank()
        startGame()
    }
    
    func loadWordBank() {
        // Read from file words.txt and load words into wordBank array
        if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                wordBank = words.components(separatedBy: "\n")
                wordBank.removeLast()  // Remove extra element produced by last \n
            }
        }
        if wordBank.isEmpty {
            wordBank = ["MONDAY"]
        }
    }
    
    func startGame() {
        word = wordBank.randomElement() ?? wordBank[0]
        print(word)
        
        // Create wordLetters array from characters in word
        for letter in word {
            wordLetters.append(String(letter))
        }
        
        // Fill wordLabel with corresponding number of "blank"/underscore characters
        for _ in wordLetters {
            wordLabelCharacters.append(" _ ")
        }
    }
    
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonLetter = sender.titleLabel?.text else { return }
        if wordLetters.contains(buttonLetter) {
            for index in 0...(word.count - 1) {
                if wordLetters[index] == buttonLetter {
                    wordLabelCharacters[index] = buttonLetter
                }
            }
            if !wordLabelCharacters.contains(" _ ") { wonGame() }
        } else {
            missedGuesses += 1
            if missedGuesses == 7 { lostGame() }
        }
        
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    func wonGame() {
        let ac = UIAlertController(title: "You got it!", message: nil, preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "New Game", style: .default) { (action) in
            self.newGame()
        }
        
        ac.addAction(newGameAction)
        present(ac, animated: true)
    }
    
    func lostGame() {
        let ac = UIAlertController(title: "Sorry, game over!", message: nil, preferredStyle: .alert)
        let newGameAction = UIAlertAction(title: "New Game", style: .default) { (action) in
            self.newGame()
        }
        
        ac.addAction(newGameAction)
        present(ac, animated: true)
    }
    
    func newGame() {
        for button in activatedButtons {  // Unhide pressed buttons
            button.isHidden = false
        }
        activatedButtons.removeAll()
        wordLetters.removeAll()
        wordLabelCharacters.removeAll()
        missedGuesses = 0
        
        startGame()
    }


}

