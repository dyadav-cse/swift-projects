//
//  CardCollectionViewCell.swift
//  MatchApp
//
//  Created by Deepak Yadav on 07/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    

    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func configureCell(card:Card){
        // keep track of the state this card represents
        self.card  = card
        
        
        // to display the front image that represents that card
        frontImageView.image  = UIImage(named: card.imageName)
        
        
        if card.isMatched == true{
            backImageView.alpha = 0
            frontImageView.alpha = 0
            return
        }
        else{
            backImageView.alpha = 1
            frontImageView.alpha = 1
            
        }
//         reset the state of the cell by checking the flipped status of the card and then showing the front or back image accordingly
        
        
        
        if card.isFlipped == true {
            // show the front image
            flipUp(speed: 0)
        }
        else{
            // show the back image
            flipDown(speed: 0, delay: 0)
        }
    }
    
    func flipUp(speed:TimeInterval = 0.3){
        
        // flip up animation
        UIView.transition(from: backImageView, to: frontImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        //set the status of the card
        card?.isFlipped = true
    }
    
    func flipDown(speed:TimeInterval = 0.3, delay:TimeInterval = 0.5){
        // delay the flip down
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay){
            // flip down animation
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: speed, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        }
        
     
        // set the card flip status
        card?.isFlipped = false
         
    }
    func remove(){
        // make the images invisible
        
        backImageView.alpha = 0
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion:nil)
    }
    
}









