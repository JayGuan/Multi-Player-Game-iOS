
//
//  Quiz.swift
//  QuizTime
//
//  Created by Remi Bear on 4/24/17.
//  Copyright © 2017 Remi Bear. All rights reserved.
//
import Foundation
class Quiz {
    
    var topic:String!
    var numberOfQuestions:Int!
    var questionSentences = [String]()
    var options = [[String: String]]()
    var correctOptions = [String]()
    
    required init(jsonURL: String) {
        let url = URL(string: jsonURL)!
        
            let session = URLSession.shared
            
            // create a data task
            let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
                
                if let result = data{
                    
                    print("inside get JSON")
        
                    do{
                        let json = try JSONSerialization.jsonObject(with: result, options: .allowFragments)
                        
                        if let dictionary = json as? [String:Any]{
                            
                            self.numberOfQuestions = dictionary["numberOfQuestions"] as! Int!
                          
                            self.topic = dictionary["topic"] as! String!
                          
                           
                            var qList = dictionary["questions"] as? [[String: AnyObject]]
                            
                            for question in qList! {
                               
                                if let option = question["options"] as? [String: String] {
                               
                                    self.options.append(option)
                                }
                                if let correct = question["correctOption"] as? String {
                                    self.correctOptions.append(correct)
                                }
                                if let questSentence = question["questionSentence"] as? String {
                                    self.questionSentences.append(questSentence)
                                }
                            }
                            
                        }
                        
                        
                    }
                    catch{
                        print("Error")
                    }
                }
                
            })
            
            // always call resume() to start
            task.resume()

    }
    
}



