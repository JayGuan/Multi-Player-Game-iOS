//
//  gameScreen.swift
//  QuizTime
//
//  Created by Remi Bear on 4/24/17.
//  Copyright © 2017 Remi Bear. All rights reserved.
//

//
//
//
//
//
//

import UIKit
import MultipeerConnectivity

class gameScreen: UIViewController {
    
 
    var quizArray = [Quiz]()
    var gameType: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
     
       
        
        
        
      // print("in here \(ViewController().quizArray[0].numberOfQuestions)")
        //print(quiz.questionSentences[0])
        /*
         var numQ = quiz.numberOfQuestions as Int
         
         for i in 0...numQ
         {
         print(quiz.questionSentences[i])
         print(quiz.options[i])
         print(quiz.correctOptions[i])
         
         }
         */
        
    }
    
    
    
   
    @IBAction func hh(_ sender: Any) {
         print(quizArray[0].numberOfQuestions)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


