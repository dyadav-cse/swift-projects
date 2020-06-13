//
//  ViewController.swift
//  QuizApp
//
//  Created by Deepak Yadav on 07/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizProtocol,UITableViewDelegate, UITableViewDataSource, ResultViewControllerProtocol {
    
    
    @IBOutlet weak var questionLabel: UILabel!
        
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var stackViewLeadingConstraint: NSLayoutConstraint!
        
    @IBOutlet weak var stackViewTrailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rootStackView: UIStackView!
    
    
        
    var model = QuizModel()
    var questions = [Question]()
    var currentQuestionIndex = 0
    // track number of correct answer by user
    var numCorrect = 0
    
    
    var resultDialog:ResultViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialize the dialog box from the result VC created in storyboard
        // fires only once,
        resultDialog = storyboard?.instantiateViewController(identifier: "ResultVC") as? ResultViewController
        // the above line has 3 points of failure
//        1. storyboard fails to instantiate
//        2. identifier not found
//        3. fails to cast
        
        resultDialog?.modalPresentationStyle = .automatic
        
        resultDialog?.delegate = self
    
        
        //Set seld as the delegate and datasource for the tableview
        // Common mistakes
        tableView.delegate = self
        tableView.dataSource = self
        
        
        //Set up the model
        model.delegate = self
        model.getQuestions()
           
    }
    
    func slideInQuestion(){
        
        //Set the initial state
              stackViewLeadingConstraint.constant = 1000
              stackViewTrailingConstraint.constant = -1000
        rootStackView.alpha = 0
              view.layoutIfNeeded()
        
              
              //Animate it to the end
              UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                  self.stackViewLeadingConstraint.constant = 0
                  self.stackViewTrailingConstraint.constant = 0
                self.rootStackView.alpha = 1
                  self.view.layoutIfNeeded()
                  
              }, completion: nil)
        
    }
    func slideOutQuestion(){
        
        //Set the initial state
        stackViewLeadingConstraint.constant = 0
        stackViewTrailingConstraint.constant = 0
        rootStackView.alpha = 1
        view.layoutIfNeeded()
  
        
        //Animate it to the end
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.stackViewLeadingConstraint.constant = -1000
            self.stackViewTrailingConstraint.constant = 1000
            self.rootStackView.alpha = 0
            self.view.layoutIfNeeded()
            
        }, completion: nil)
        
              
    }
    
    
    func displayQuestion(){
        // check if there questiopns and if the currentQuestionIndex is not out of bounds
        guard questions.count > 0 && currentQuestionIndex < questions.count else{
            return
        }
        
        // display the question text
        
        questionLabel.text = questions[currentQuestionIndex].question
        
        // reload the table view
        tableView.reloadData()
        
        
        // animate the question in
        slideInQuestion()
    }
    
    
    // MARK: -  Quiz Protocol Methods
    func questionRetrieved(_ questions: [Question]) {
//     print("question regreive from mdoel")
        
        // Get a reference to the question
        self.questions = questions
        
        // check if  we should retrieve state before showing question #1
        let saveIndex = StateManager.retrieveData(key: StateManager.questionIndexKey) as? Int
        if saveIndex != nil && saveIndex!  < questions.count{
            
            // set the current question index to saved state
            currentQuestionIndex = saveIndex!
            let saveNumCorrect = StateManager.retrieveData(key: StateManager.numCorrectKey) as? Int
            if saveNumCorrect  != nil {
                numCorrect = saveNumCorrect!
            }
        }
        
        
        
        // display the question
        displayQuestion()
        
        
        
        
    }
    
    //MARK: - UI Table VIew Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // table view asking view controller how many rows to display
        // ==  niumber of answers in question
        
        // As currentquestion index =0 and if the question array is empty, then accessing index 0 would crash the app
        // thus, make sure to add atleaast 1 question to the array
        guard questions.count > 0 else{
            return 0
        }
        
        // return the number of answers to this question
        let currentQuestion =  questions[currentQuestionIndex]
        if currentQuestion.answers != nil{
            return currentQuestion.answers!.count
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get a cell
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath)
        
        // customize it
        let label = cell.viewWithTag(1) as? UILabel
        if label != nil{
            // get the question
            let question = questions[currentQuestionIndex]
            
            // prevent from out of boudns
            if question.answers != nil && indexPath.row < question.answers!.count{
                // Set the answer for the text
                label!.text  = question.answers![indexPath.row]
            }
        }
        //return it
     return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // get the row user has tapped onto, check if the answer is correct?
        
        // flag to denote correct answer status to dialog box
        var flag = ""
        
         
        let question  = questions[currentQuestionIndex]
        
        if question.correctAnswerIndex == indexPath.row{
            // user got it right
            print("User got it right")
            flag = "Correct"
            numCorrect += 1
        }
        else{
            // user got it wrong
            print("user got it wrong")
            flag = "Wrong"
        }
        
        //Slide out the question
        DispatchQueue.main.async{
            self.slideOutQuestion()
        }
        
        
        // show the popUP dialog
        if resultDialog != nil{
            
            
            // why didn't we directly set the titleLabel.text here? Because it is not loaded into the memory yet.
            
            resultDialog!.titleText = flag
            resultDialog!.feedbackText = question.feedback!
            resultDialog?.buttonText = "Next"
            
            DispatchQueue.main.async {
                // force unwrapping it as already been checked as not nil
                self.present(self.resultDialog!, animated: true, completion: nil)
            }
            
        }
        
        
        
    }

//MARK: - Result View ControllerProtocol Methods
    
    func dialogDismissed() {
        
        // increment the quetion index
        currentQuestionIndex += 1
        
        if currentQuestionIndex == questions.count {
            // User has answered all the questions
            // show the summary dialog
            
            // show the popUP dialog
            if resultDialog != nil{
                
                
                // why didn't we directly set the titleLabel.text here? Because it is not loaded into the memory yet.
                
                resultDialog!.titleText = "Summary"
                resultDialog!.feedbackText = "You got \(numCorrect) correct out of \(questions.count) Questions"
                resultDialog?.buttonText = "Restart"
                
                // force unwrapping it as already been checked as not nil
                present(resultDialog!, animated: true, completion: nil)
                
                // Clear state
                StateManager.clearState()
            }
        }
        else if currentQuestionIndex > questions.count{
            // Restart the app
            numCorrect = 0
            currentQuestionIndex = 0
            displayQuestion()
            
            
        }
        
        else{
            // display the next question
            displayQuestion()
            
            //Save state
            StateManager.saveState(numCorrect: numCorrect, questionIndex: currentQuestionIndex)
        }
        
    }
    
    
    
}

