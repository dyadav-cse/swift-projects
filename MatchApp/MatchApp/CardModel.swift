//
//  CardModel.swift
//  MatchApp
//
//  Created by Deepak Yadav on 07/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import Foundation

class CardModel{
    
    func getCards() -> [Card]{
    
        var generatedCards = [Card]()
        
        
        // array to store randomly genereated numbers
        var randomNumbers = [Int]()
        
        // generate unique 8 pairs of random numbers from 13 cards
        while true{
            let random = Int.random(in: 1...13)
            
//            we want only 8 pairs of data
            
            if randomNumbers.count >= 8 {
                break
            }
            // check if random numebr already exits, then skip it
            else if randomNumbers.contains(random) == false{
                randomNumbers.append(random)
                
                let card1 = Card()
                let card2 = Card()
                
                card1.imageName = "card\(random)"
                card2.imageName = "card\(random)"
                
                generatedCards += [card1, card2]
            }

            else{
                continue
            }
            
        }
        
        // randomize the pairs
        
        generatedCards.shuffle()
        
//        print(generatedCards)
        return generatedCards
    }
}
