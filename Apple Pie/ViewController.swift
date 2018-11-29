//
//  ViewController.swift
//  Apple Pie
//
//  Created by Brian van de Velde on 09-11-18.
//  Copyright © 2018 Brian van de Velde. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var correctWordLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    @IBOutlet weak var startAgain: UIButton!
    
    var initialWords = ["buccaneer", "swift", "glorious", "incandenscent", "bug", "program"]
    var countWords = ["buccaneer", "swift", "glorious", "incandenscent", "bug", "program"]
    var listOfWords: [String] = []
    var incorrectMovesAllowed = 7
    
    // if there is a win or loss reset all the buttons
    var totalWins = 0
    {
        didSet
        {
            newRound()
        }
    }
    
    var totalLoses = 0
    {
        didSet
        {
            newRound()
        }
    }
    
    var currentGame: Game!
    
    // if player starts game again all values will be reset
    @IBAction func startAgainButtonTapped(_ sender: UIButton)
    {
        incorrectMovesAllowed = 7
        totalWins = 0
        totalLoses = 0
        
        viewDidLoad()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton)
    {
        // if the button is pressed make it false so user can't press it again
        sender.isEnabled = false
        
        // returns a string from the title of the button
        let letterString = sender.title(for: .normal)
        
        // all the buttons have capital letters, make them lowercased
        let letter = Character(letterString!.lowercased())
        currentGame.playerGuessed(letter: letter)
        
        updateUI()
        updateGameState()
    }
    
    // hides the again button and shows tree image
    override func viewDidLoad()
    {
        super.viewDidLoad()
        startAgain.isHidden = true
        threeImageView.isHidden = false
        listOfWords = initialWords
        newRound()
    }
    
    func newRound()
    {
        // makes the move from one word to another
        if !listOfWords.isEmpty
        {
            let newWord = listOfWords.removeFirst()
            currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed, guessedLetters:[])
            enableLetterButtons(true)
            
            updateUI()
        }
        // if last word was correct, again button is shown and tree image is hidden
        else
        {
            enableLetterButtons(false)
            startAgain.isHidden = false
            threeImageView.isHidden = true
        }
    }
    
    func enableLetterButtons(_ enable: Bool)
    {
        for button in letterButtons
        {
            button.isEnabled = enable
        }
    }
    
    func updateUI()
    {
        // adds a space between the letters and _ where the word should appear
        var letters = [String]()
        for letter in currentGame.formattedWord.characters
        {
            letters.append(String(letter))
        }
        let wordWithSpacing = letters.joined(separator: " ")
        
        correctWordLabel.text = wordWithSpacing
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLoses)"
        threeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        
    }
    
    func updateGameState()
    {
        // if game is won add 1 to won meter
        // if game is lossed add 1 to loss meter
        if currentGame.incorrectMovesRemaining == 0
        {
            totalLoses += 1
            lossedGame()
        }
        else if currentGame.word == currentGame.formattedWord
        {
            totalWins += 1
            
            if totalWins == countWords.count
            {
                victoryGame()
            }
            else
            {
                victoryWord()
            }
        }
            
        else
        {
            updateUI()
        }
    }
    
    // message given when player wins game
    func victoryGame()
    {
        let alert = UIAlertController(title: "Victory", message: "You've guessed all words correctly!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "I AM A CHAMPION", style: .default, handler: nil))
        self.present(alert, animated: true)

    }
    
    // message given when player guesses word correctly
    func victoryWord()
    {
        let alert = UIAlertController(title: "Victory (partially)", message: "You've guessed the word correctly!!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "YEAHHH", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    // message given if player runs out of tries
    func lossedGame()
    {
        let alert = UIAlertController(title: "Losser", message: "You ran out of tries", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Your mama didn't raise a quiter, I'LL TRY AGAIN (someday)", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
}

