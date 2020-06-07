//
//  ViewController.swift
//  MatchApp
//
//  Created by Deepak Yadav on 07/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource,
UICollectionViewDelegate{
    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    var model  = CardModel()
    var cardsArray = [Card]()
    
    var timer:Timer?
    var milliseconds:Int = 10 * 1000
    
    var firstFlippedCardIndex:IndexPath?
    
    var soundPlayer = SoundManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cardsArray = model.getCards()
        print("in the view controller, \(cardsArray.count)")
        
        // Set the view controller as the datasource and delegate of the collection view
        collectionView.dataSource = self
        collectionView.delegate  = self
        
        //initialize the timer
        
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer!, forMode: .common)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // PLay sound
        soundPlayer.playSound(effect: .shuffle)
        
    }
    
    // MARK: - Timer Methods
    @objc func timerFired(){
    
        // decrement the counter
         milliseconds -= 1
        
        // update the timer label
        let seconds:Double = Double(milliseconds)/1000.0
        timerLabel.text = String(format: " Time Remaining %.2f" , seconds)
        
        //stop the timer if it reaches zero
        if milliseconds == 0{
            
            timerLabel.textColor = UIColor.red            
            timer?.invalidate()
            
            //check the number of pairs of cards exposed
            checkForGameEnd()
            
        }
        
        
    }
    
    
    
    //    MARK: - Configure it
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //    get a call and cast it to custom view sub class
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell",
                                                       for: indexPath) as! CardCollectionViewCell
        
        // return it
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let customCell = cell as? CardCollectionViewCell
        
        // get the card from the array
        let card = cardsArray[indexPath.row]
        
        //   configure the cell
        customCell?.configureCell(card:card)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // if timer is up, don'tlet the user interact anymore
        if milliseconds <= 0 {
            return
        }
        
        
        // get the cell reference which was tapped
        let cell =   collectionView.cellForItem(at: indexPath) as? CardCollectionViewCell
        
        // check the status of the card to determine how to flip
        if cell?.card?.isFlipped == false && cell?.card?.isMatched == false{
            // flip down    
            cell?.flipUp()
            // PLay sound
            soundPlayer.playSound(effect: .flip)
            
            
            // check the index of this card if it is first or second
            if firstFlippedCardIndex ==  nil{
                // this is the first flipped card
                firstFlippedCardIndex = indexPath
            }
            else{
                // second card is flipped=
                checkMatch(indexPath)
                // run teh comparison logi
            }
        }
    }
    
    //    MARK: - Game logic methods
    
    func checkMatch(_ secondFlippedCardIndex:IndexPath){
        // get the two card objects indice and see if thyey match
        
        let card1 = cardsArray[firstFlippedCardIndex!.row]
        let card2 = cardsArray[secondFlippedCardIndex.row]
        
        
        // get the two wocllectio view cells corresponding to cards 1 and two
        let card1Cell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        let card2Cell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // compare the cards
        if card1.imageName == card2.imageName {
            // match
            card1.isMatched = true
            card2.isMatched = true
            
            // PLay sound
            soundPlayer.playSound(effect: .match)
            
            // set the status and remove them
            card1Cell?.remove()
            card2Cell?.remove()
            
            // check if it was the last pair
            
            checkForGameEnd()
            
        }
        else{
            // not a match
            
            card1.isFlipped = false
            card2.isFlipped = false
            
            card1Cell?.flipDown()
            card2Cell?.flipDown()
            
            // PLay sound
            soundPlayer.playSound(effect: .nomatch)
        }
        // reset the property of first index
        firstFlippedCardIndex = nil
    }
    
    func checkForGameEnd(){
        // assumer user has won
        var hasWon = true
        
        // loop through all cards, if all has isMatched = true, and time is left, he won
        for card in cardsArray{
            if card.isMatched == false{
                hasWon = false
                break
            }
        }
        if hasWon{
            // User won the match
            showAlert(title: "Congratulations", message:"You've won the Game!")
        }
        else{
            // User hasn't won yet, check for the time left
            showAlert(title: "Time's Up", message: "Better Luck Next Time!")
        }
        
    }
    func showAlert(title:String, message:String){
        let alert = UIAlertController(title:title, message:message, preferredStyle:.alert)
        
        // Add a button for user to dismiss is.
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
}

