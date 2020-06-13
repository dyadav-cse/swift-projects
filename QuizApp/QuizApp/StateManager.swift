//
//  StateManager.swift
//  QuizApp
//
//  Created by Deepak Yadav on 09/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import Foundation

class StateManager{
    
    static var numCorrectKey = "NumCorrectKey"
    static var questionIndexKey = "QuestionIndexKey"
    
    static func saveState(numCorrect:Int, questionIndex:Int){
        
        // reference to standard defaults storage
        let defaults = UserDefaults.standard
        // ssave the state
        defaults.set(numCorrect, forKey: numCorrectKey)
        defaults.set(questionIndex, forKey: questionIndexKey)
        
    }
    
    static func retrieveData(key:String) -> Any?{
        
        // reference to standard defaults storage
        let defaults = UserDefaults.standard
        
        // returns as Any type
        return defaults.value(forKey:key)
    }
    
    static func clearState(){
        // reference to standard defaults storage
        let defaults = UserDefaults.standard
        
        // clear the state object data
        defaults.removeObject(forKey: numCorrectKey)
        defaults.removeObject(forKey: questionIndexKey)
    }
}
