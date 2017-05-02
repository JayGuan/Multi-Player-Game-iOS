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
import CoreMotion
import UIKit
import MultipeerConnectivity

class gameScreen: UIViewController {
    
    @IBOutlet weak var timerAndMessage: UILabel!
    @IBOutlet weak var p3Name: UILabel!
    @IBOutlet weak var p2Name: UILabel!
    @IBOutlet weak var p1Name: UILabel!
 
    @IBOutlet weak var buttonD: UIButton!
    @IBOutlet weak var buttonC: UIButton!
    @IBOutlet weak var buttonB: UIButton!
    @IBOutlet weak var buttonA: UIButton!
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var score3: UILabel!
    @IBOutlet weak var score4: UILabel!
    
    
    var motionManager = CMMotionManager()
    var quizArray = [Quiz]()
    var currentQuesitonNum = 0
    var currentTopicNum = 0
    var gameType: Int!
    var connectionNum = 0
    var timer: Timer? = nil
    var timeCount = 20
    var previousOption = ""
    
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
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        
        displayQuestionAndOptions()
        displayPlayers()
        
        self.motionManager.deviceMotionUpdateInterval = 1.0/60.0
        
        self.motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical)
        
        
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
    }

    func updateTime() {
        if (timeCount > 0) {
            timerAndMessage.text = "\(timeCount)"
            timeCount -= 1
        }
        else {
            stopTimer()
            won()
            lost()
        }

    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            
            print("shake shake ")
            // pick a random number from 1 to 4 and use those as pick
            
        }
    }
    
    func updateDeviceMotion(){
        
        let data = self.motionManager.deviceMotion
        if(data == nil)
        {
            return
        }
        let attitude = data?.attitude
        
        if let pitch = (attitude?.pitch),
            let roll = (attitude?.roll)
             {
            
         //   print("Pitch \(pitch)    Roll: \(roll)     Yaw: \(yaw)" )
            
            // now that we have all point, fugure out where its pointing
            if previousOption == nil
                {
                  buttonA.sendActions(for: .touchUpInside)
                }
            
            else if previousOption == "A" {
                 if pitch<0.75
                 {
                    print("Select A")
                    buttonA.sendActions(for: .touchUpInside)
                }
                else if pitch > 1.5
                 {
                    print("Select C")
                    buttonC.sendActions(for: .touchUpInside)

                }
                else if( roll > 0.5)
                 {
                    print("Select B")
                    buttonB.sendActions(for: .touchUpInside)

                }
                else if (roll < -0.5)
                 {
                    print("Select A")
                    buttonA.sendActions(for: .touchUpInside)

                }
            }
            else if( previousOption == "B")
                 {
                    if pitch<0.75
                    {
                    
                        buttonB.sendActions(for: .touchUpInside)

                    }
                    else if pitch > 1.5
                    {
                
                        buttonD.sendActions(for: .touchUpInside)

                    }
                    else if( roll > 0.5)
                    {
                        print("Select B")
                        buttonB.sendActions(for: .touchUpInside)

                    }
                    else if (roll < -0.5)
                    {
                        print("Select A")
                        buttonA.sendActions(for: .touchUpInside)

                    }
                }
            else if( previousOption == "C")
            {
                if pitch<0.75
                {
                    print("Select A")
                    buttonA.sendActions(for: .touchUpInside)
                    
                }
                else if pitch > 1.5
                {
                    print("Select C")
                    buttonC.sendActions(for: .touchUpInside)
                    
                }
                else if( roll > 0.5)
                {
                    print("Select D")
                    buttonD.sendActions(for: .touchUpInside)
                    
                }
                else if (roll < -0.5)
                {
                    print("Select C")
                    buttonC.sendActions(for: .touchUpInside)
                    
                }
            }
            else if( previousOption == "D")
            {
                if pitch<0.75
                {
                    print("Select B")
                    buttonB.sendActions(for: .touchUpInside)
                    
                }
                else if pitch > 1.5
                {
                    print("Select D")
                    buttonD.sendActions(for: .touchUpInside)
                    
                }
                else if( roll > 0.5)
                {
                    print("Select D")
                    buttonD.sendActions(for: .touchUpInside)
                    
                }
                else if (roll < -0.5)
                {
                    print("Select C")
                    buttonC.sendActions(for: .touchUpInside)
                    
                }
            }
            
            
        }
        
    }
    
    
    func won() {
        //TODO
    }
    
    func lost() {
        //TOOD
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @IBAction func clickedA(_ sender: UIButton) {
        if previousOption == "A" {
            submitAnswer()
        }
        else {
            previousOption = "A"
            clearBackgroundColocOnButtons()
            buttonA.backgroundColor = UIColor.green
        }
    }
    
    @IBAction func clickedB(_ sender: UIButton) {
        if previousOption == "B" {
            submitAnswer()
        }
        else {
            previousOption = "B"
            clearBackgroundColocOnButtons()
            buttonB.backgroundColor = UIColor.green
        }
    }
    @IBAction func clickedC(_ sender: UIButton) {
        if previousOption == "C" {
            submitAnswer()
        }
        else {
            previousOption = "C"
            clearBackgroundColocOnButtons()
            buttonC.backgroundColor = UIColor.green
        }
    }
    @IBAction func clickedD(_ sender: UIButton) {
        if previousOption == "D" {
            submitAnswer()
        }
        else {
            previousOption = "D"
            clearBackgroundColocOnButtons()
            buttonD.backgroundColor = UIColor.green
        }
    }
    
    func clearBackgroundColocOnButtons() {
        buttonA.backgroundColor = UIColor.lightGray
        buttonB.backgroundColor = UIColor.lightGray
        buttonC.backgroundColor = UIColor.lightGray
        buttonD.backgroundColor = UIColor.lightGray
    }
    
    func submitAnswer() {
        //TODO
       // print("answer: [\(previousOption) selected]")
    }
    
    func displayPlayers() {
        switch connectionNum {
        case 2:
            //3 people
            img4.alpha = 0.1
            p3Name.alpha = 0.1
        case 1:
            img4.alpha = 0.1
            p3Name.alpha = 0.1
            img3.alpha = 0.1
            p2Name.alpha = 0.1
        case 0:
            img4.alpha = 0.1
            p3Name.alpha = 0.1
            img3.alpha = 0.1
            p2Name.alpha = 0.1
            img2.alpha = 0.1
            p1Name.alpha = 0.1
        default:
            // 4 players
            break
        }
    }
    
    func displayQuestionAndOptions() {
       // print("question #  on topic # \(quizArray[currentTopicNum].questionSentences[currentQuesitonNum])")
        question.text = quizArray[currentTopicNum].questionSentences[currentQuesitonNum]
        //print("options [\(quizArray[currentTopicNum].options[currentQuesitonNum])]")
        
        //set tags
        buttonA.tag = 1
        buttonB.tag = 2
        buttonC.tag = 3
        buttonD.tag = 4
        
        //set titles
        buttonA.setTitle("A: \(quizArray[currentTopicNum].options[currentQuesitonNum]["A"]!)", for: .normal)
        buttonB.setTitle("B: \(quizArray[currentTopicNum].options[currentQuesitonNum]["B"]!)", for: .normal)
        buttonC.setTitle("C: \(quizArray[currentTopicNum].options[currentQuesitonNum]["C"]!)", for: .normal)
        buttonD.setTitle("D: \(quizArray[currentTopicNum].options[currentQuesitonNum]["D"]!)", for: .normal)
       // print("correct [\(quizArray[currentTopicNum].correctOptions[currentQuesitonNum])]")
        
    }
   
    @IBAction func hh(_ sender: Any) {
         //print(quizArray[0].numberOfQuestions)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


