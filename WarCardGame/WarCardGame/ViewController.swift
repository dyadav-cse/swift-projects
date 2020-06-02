//
//  ViewController.swift
//  WarCardGame
//
//  Created by Deepak Yadav on 10/05/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var leftImageView: UIImageView!
    
    
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var leftScoreLabel: UILabel!
    
    @IBOutlet weak var rightScoreLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }
    var leftScore = 0
    var rightScore  = 0

    
    @IBAction func dealTapped(_ sender: Any) {
       
            //        randomize the numbers
            let leftNumber = Int.random(in: 2...14)
            let rightNumber = Int.random(in: 2...14)
            
            //
            leftImageView.image  = UIImage(named:  "card\(leftNumber)")
            rightImageView.image = UIImage(named: "card\(rightNumber)")
            
            if leftNumber>rightNumber{
                //            left wins
                leftScore += 1
                leftScoreLabel.text = String(leftScore)
            }
            else if leftNumber < rightNumber{
                //            right wins
                rightScore += 1
                rightScoreLabel.text = String(rightScore)
            }
            else{
                //Tie
            }
            
        
    }
}

