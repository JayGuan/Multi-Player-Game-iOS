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

class gameScreen: UIViewController , MCBrowserViewControllerDelegate, MCSessionDelegate{
    
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
    
    
    @IBOutlet weak var player1AnswerText: UITextField!
    @IBOutlet weak var player2AnswerText: UITextField!
    @IBOutlet weak var player3AnswerText: UITextField!
    @IBOutlet weak var player4AnswerText: UITextField!
    
    
    
    var motionManager = CMMotionManager()
    var quizArray = [Quiz]()
    var currentQuesitonNum = 0
    var currentTopicNum = 0
    var gameType: Int!
    var connectionNum = 0
    var timer: Timer? = nil
    var motionTime:Timer? = nil
    var timeCount = 20
    var previousOption = ""
    var connection = Connection()
    var startedGame = false
    var submissionNum = 0
    var answerTimeCount = -1
    var totalNumQuizzes = 2
    
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
        /*
        if (gameType == 1) {
            // set connection
            connection.assistant.start()
            connection.session.delegate = self
            connection.browser.delegate = self
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
        
        
        motionTime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)
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
            var num = arc4random_uniform(4)+1
            print(num)
            
            if num==1
            {
                selectA()
            }
            else if num == 2
            {
                selectB()
            }
            else if num == 3
            {
                selectC()
            }
            else if num == 4
            {
                selectD()
            }
        }
    }
    
    func updateDeviceMotion(){
        
        let data = self.motionManager.deviceMotion
        if(data == nil)
        {
            return
        }
        
        let attitude = data?.attitude
        let userAcceleration = data?.userAcceleration
        
        if let pitch = (attitude?.pitch),
            let roll = (attitude?.roll),
            let yaw = (attitude?.yaw),
            let UaccX = (userAcceleration?.x),
             let UaccY = (userAcceleration?.y),
             let UaccZ = (userAcceleration?.z)
             {
            
          // print("\(UaccZ)  "  )
                
            
        
                
                
         if previousOption == ""
                {
                    
                  selectA()
                }
         else if(UaccZ < -1.0)
         {
            print("Z submit")
            submitAnswer()
         }
         else if(yaw>1.2 || yaw < -1.2)
         {
            print("Yaw submit")
            submitAnswer()
         }
           
        else if previousOption == "A" {
            
                 if pitch > 1.5
                 {
                    //print("Select C")
                    selectC()

                }
                else if( roll > 0.5)
                 {
                    //print("Select B")
                    selectB()

                }
            
            }
            else if( previousOption == "B")
                 {
                    if pitch > 1.5
                    {
                
                   selectD()

                    }
                   
                    else if (roll < -0.5)
                    {
                      //  print("Select A")
                        selectA()

                    }
            
            }
            else if( previousOption == "C")
            {
                if pitch<0.75
                {
                 //   print("Select A")
                    selectA()
                    
                }
              
                else if( roll > 0.5)
                {
                //    print("Select D")
                    selectD()
                    
                }
               
            }
            else if( previousOption == "D")
            {
                if pitch<0.75
                {
                    print("Select B")
                    selectB()
                    
                }
               
                else if (roll < -0.5)
                {
                //    print("Select C")
                    selectC()
                    
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
    func stopMotionTime()
    {
        motionTime?.invalidate()
        motionTime = nil
    }
    func startTime()
    {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(self.updateTime),
                                     userInfo: nil,
                                     repeats: true)
        
    }
    func StartMotionTime()
    {
        motionTime = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateDeviceMotion), userInfo: nil, repeats: true)

    }
    
    func selectA() {
        previousOption = "A"
        clearBackgroundColocOnButtons()
        buttonA.backgroundColor = UIColor.green
    }
    
    func selectB() {
        previousOption = "B"
        clearBackgroundColocOnButtons()
        buttonB.backgroundColor = UIColor.green
    }
    
    func selectC(){
        previousOption = "C"
        clearBackgroundColocOnButtons()
        buttonC.backgroundColor = UIColor.green
    }
    
    func selectD() {
        previousOption = "D"
        clearBackgroundColocOnButtons()
        buttonD.backgroundColor = UIColor.green
    }
    
    @IBAction func clickedA(_ sender: UIButton) {
        if previousOption == "A" {
            submitAnswer()
            buttonA.backgroundColor = UIColor.red
        }
        else {
            previousOption = "A"
            clearBackgroundColocOnButtons()
            buttonA.backgroundColor = UIColor.green
        }
    }
    
    @IBAction func clickedB(_ sender: UIButton) {
        showAnswer()
        if previousOption == "B" {
            submitAnswer()
            buttonB.backgroundColor = UIColor.red
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
            buttonC.backgroundColor = UIColor.red
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
            buttonD.backgroundColor = UIColor.red
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
        print("answer submitted")
        submissionNum += 1
        let answer = previousOption
        sendAnswerToOthers(answer: answer)
        player1AnswerText.text = "\(answer)"
        //highlight submitted answer
        // Check to make sure everyone has an answer in before calling showAnswer
        stopMotionTime()
        showAnswer()
        //TODO
       // print("answer: [\(previousOption) selected]")
    }
    
    func sendAnswerToOthers(answer: String) {
        /*
        let msg = answer
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg)
        do{
            try connection.session.send(dataToSend, toPeers: connection.session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
 */
    }
    
    func displayPlayers() {
        switch connectionNum {
        case 2:
            //3 people
            img4.alpha = 0.1
            p3Name.alpha = 0.1
            player4AnswerText.alpha = 0.1
        case 1:
            img4.alpha = 0.1
            p3Name.alpha = 0.1
            player4AnswerText.alpha = 0.1
            img3.alpha = 0.1
            p2Name.alpha = 0.1
            player3AnswerText.alpha = 0.1
        case 0:
            img4.alpha = 0.1
            p3Name.alpha = 0.1
            player4AnswerText.alpha = 0.1
            img3.alpha = 0.1
            p2Name.alpha = 0.1
            player3AnswerText.alpha = 0.1
            img2.alpha = 0.1
            p1Name.alpha = 0.1
            player2AnswerText.alpha = 0.1
        default:
            // 4 players
            break
        }
    }
    
    func showAnswer()
    {
        stopTimer()
        var correctLetter = quizArray[currentTopicNum].correctOptions[currentQuesitonNum]
        
        var ans = quizArray[currentTopicNum].options[currentQuesitonNum][correctLetter]!
        question.text = "Answer: \(ans)"
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.startNextQuestion()
        }
    }
    
    func startNextQuestion()
    {
        print("Quiz num \(currentTopicNum)")
        print("Quiz num \(currentQuesitonNum)")
        
        if(currentQuesitonNum+1 < quizArray[currentTopicNum].numberOfQuestions)
        {
            print("Change question")
            currentQuesitonNum+=1
            displayQuestionAndOptions()
            timeCount = 20
            previousOption = ""
            
        }
        else if(currentTopicNum < totalNumQuizzes && currentTopicNum+1 != 2)
        {
            print("topic change")
            currentTopicNum+=1
            currentQuesitonNum=0
            displayQuestionAndOptions()
            timeCount = 20
            previousOption = ""
            
        }
        else{
            print("game over")
         //   restartBtn.isUserInteractionEnabled = true
            // give user uption to restart
        }
        startTime()
        StartMotionTime()
        clearBackgroundColocOnButtons()
        
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
    
    
    
    //**********************************************************
    // required functions for MCBrowserViewControllerDelegate
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is dismissed
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // Called when the browser view controller is cancelled
        dismiss(animated: true, completion: nil)
    }
    //**********************************************************
    
    
    
    
    //**********************************************************
    // required functions for MCSessionDelegate
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("resource: [\(resourceName)]")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
                print("receivedString = [\(receivedString)]")
                if receivedString == "begin" {
                    print("entered")
                    if (!self.startedGame) {
                        self.gameType = 1
                        self.performSegue(withIdentifier: "showGameScreen", sender: self)
                        self.startedGame = true
                    }
                }
                else if (receivedString == "A" ||
                    receivedString == "B" ||
                    receivedString == "C" ||
                    receivedString == "D" ) {
                    //print("answer received: [\(receivedString)]")
                    //print("answer correct: [\(self.quizArray[self.currentTopicNum].correctOptions[self.currentQuesitonNum])]")
                }
            }
            
        })
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            connectionNum += 1
            print("who connectioned: \(peerID)")
            print("Connection Test: [\(connectionNum)]")
            print("Connected: \(peerID.displayName)")
            
        case MCSessionState.connecting:
            print("Connecting: \(peerID.displayName)")
            
        case MCSessionState.notConnected:
            print("Not Connected: \(peerID.displayName)")
        }
        
    }
    //**********************************************************
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


