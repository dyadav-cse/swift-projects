//
//  SoundManager.swift
//  MatchApp
//
//  Created by Deepak Yadav on 07/06/20.
//  Copyright © 2020 Deepak Yadav. All rights reserved.
//

import Foundation
import AVFoundation

class SoundManager{
    var audioPlayer:AVAudioPlayer?
    
    enum SoundEffect{
        case flip
        case match
        case nomatch
        case shuffle
    }
    
    func playSound(effect:SoundEffect){
        
        var fileName = ""
        
        switch effect {
            
            case .flip:
                fileName = "cardflip"
            
            case .match:
                fileName = "dingorrect"
                
            case .nomatch:
                fileName = "dingwrong"
                
            case .shuffle:
                fileName = "shuffle"
                                    
        }
        // get the path to sound files
        let bundlePath = Bundle.main.path(forResource: fileName, ofType: ".wav")
        
        //check that it's not nil
        guard bundlePath != nil else {
            // exit as files not found
            return
        }
        let url = URL(fileURLWithPath: bundlePath!)
        
        // error handling
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        }
        catch{
            print("Couldn't create audio player")
            return
            
        }
    }
}
