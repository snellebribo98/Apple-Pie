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
    
    var listOfWords = ["buccaneer", "swift", "glorious", "incandenscent", "bug", "program"]
    let incorrectMovesAllowed = 7
    
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
    
    @IBAction func buttonPressed(_ sender: UIButton)
    {
        // if the button is pressed make it false so user can't press it again
        sender.isEnabled = false
        
        // returns a string from the title of the button
        let letterString = sender.title(for: .normal)
        
        // all the buttons have capital letters, make them lowercased
        let letter = Character(letterString!.lowercased())
        currentGame.playerGuessed(letter: letter)
        
        updateGameState()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
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
        else
        {
            enableLetterButtons(false)
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
        }
        else if currentGame.word == currentGame.formattedWord
        {
            totalWins += 1
        }
        else
        {
            updateUI()
        }
    }
}

