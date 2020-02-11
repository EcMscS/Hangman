//
//  ViewController.swift
//  Hangman
//
//  Created by Greg Wu on 1/14/20.
//  Copyright © 2020 Greg Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var hangmanStatusLabel: HangmanStatusLabel!
    var wordLabel: WordLabel!
    var letterButtons = [LetterButton]()
    var activatedButtons = [LetterButton]()  // Stores pressed and hidden letter buttons so they can be restored in new game
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureStatusLabel()
        configureWordLabel()
        configureButtonView()
        loadWordBank()
        startGame()
    }
    
    func configureViewController() {
        title = "Hangman"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = .systemBackground
    }
    
    func configureStatusLabel() {
        hangmanStatusLabel = HangmanStatusLabel.init(textLabel: "7 Lives Left", fontSize: 32)
        view.addSubview(hangmanStatusLabel)
        
        NSLayoutConstraint.activate([
            hangmanStatusLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 50),
            hangmanStatusLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            hangmanStatusLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
    }
    
    func configureWordLabel() {
        wordLabel = WordLabel.init(textLabel: "", fontSize: 40)
        view.addSubview(wordLabel)
        
        NSLayoutConstraint.activate([
            wordLabel.topAnchor.constraint(equalTo: hangmanStatusLabel.bottomAnchor, constant: 50),
            wordLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            wordLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    func configureButtonView() {
        // Create container view for letter buttons
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
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
                let letterButton = LetterButton(type: .system)
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
    
    @objc func letterTapped(_ sender: LetterButton) {
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
        let ac = UIAlertController(title: "Sorry, game over!", message: "The word was \(word).", preferredStyle: .alert)
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

