//
//  QuizModel.swift
//  QuizApp
//
//  Created by Deepak Yadav on 07/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import Foundation

protocol QuizProtocol {
    func questionRetrieved(_ questions:[Question])
}

class QuizModel{
    
    var delegate:QuizProtocol?
    
    func getQuestions(){
        
     // TODO: fetch the questions
        getRemoteJsonFile()
        
    }
    
    func getLocalJsonFile(){
        
        // create path to questionData
        let path = Bundle.main.path(forResource: "QuestionData", ofType: "json")
        
        guard path != nil else {
            print("Couldn't find the json data file")
            return
        }
        //Get the uRL object to the path
        let url = URL(fileURLWithPath: path!)
        
        do{
        // get the data from the url
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let array   =  try decoder.decode([Question].self, from: data)
            
            delegate?.questionRetrieved(array)
            
        }
        catch{
            // Error: couldn't find the data from uRL
        }
        
    }
    
    
    func getRemoteJsonFile(){
            
        // Get a URL OBject from string
        let urlString = "https://codewithchris.com/code/QuestionData.json"
        
        let url  = URL(string: urlString)
        
        guard url != nil else{
            print("Could'nt create the url")
            return
        }
        
        // Get a URL Session Object
        let session  = URLSession.shared

        // Get a datatask object
        // closure type
        let datatask = session.dataTask(with: url!) { (data, response, error) in
            
            if error == nil && data != nil{
                
                do {
                    // Get a jSON Decoder
                    let decoder = JSONDecoder()
                    
                    // Parse the JSON
                   let array = try decoder.decode([Question].self, from: data!)
                    
                    // Use the main thread to notify the view contoller
                    DispatchQueue.main.async {
                        // NOtify the view controller
                        self.delegate?.questionRetrieved(array)
                    }
                    
                    
                }
                catch{
                 print("Couldn't parse the JSON")
                }
            }
            
        }
        
        //Call resume on data task object
        datatask.resume()
    }
}
