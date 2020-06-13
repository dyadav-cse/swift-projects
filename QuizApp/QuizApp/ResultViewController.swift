//
//  ResultViewController.swift
//  QuizApp
//
//  Created by Deepak Yadav on 09/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import UIKit

protocol ResultViewControllerProtocol {
    func dialogDismissed()
}

class ResultViewController: UIViewController {
    
    
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet weak var dialogView: UIView!

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var feedbackLabel: UILabel!
    
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var titleText = ""
    var feedbackText = ""
    var buttonText = ""
    
    var delegate:ResultViewControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let's make the dialog box rounded corners
        dialogView.layer.cornerRadius = 10
    }
    
    // to update once viewDidLoad loaded and want to update the local values
    override func viewWillAppear(_ animated: Bool) {
        // after items are loaded, time to set the texts
               titleLabel.text = titleText
               feedbackLabel.text = feedbackText
               dismissButton.setTitle(buttonText, for: .normal)
        
        //Hide the UI Elements
            dimView.alpha = 0
            titleLabel.alpha = 0
            feedbackLabel.alpha = 0
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //Fade in dim view
        UIView.animate(withDuration: 0.6, delay: 0, options: .curveEaseOut,
                       animations: {
                        self.dimView.alpha = 1
                        self.titleLabel.alpha = 1
                        self.feedbackLabel.alpha = 1
                
                        
                        
        }, completion: nil)
        
        
    }

    @IBAction func dismissTapped(_ sender: Any) {
        
        // Fade out the Dim View
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.dimView.alpha = 0
        }) { (completed) in
            // dismiss the tapped button
            self.dismiss(animated: true, completion: nil)
            
            // Notify the delegate  the user pressed dismiss button
            self.delegate?.dialogDismissed()
        }
        
        
        
        
    }
    
}
