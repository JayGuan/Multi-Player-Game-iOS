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
    
    
    @IBOutlet var restartBtn: UIButton!
    
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
    //var connection = Connection()
    var startedGame = false
    var submissionNum = 0
    var answerTimeCount = -1
    var totalNumQuizzes = 2
    var session: MCSession!
    var peerID: MCPeerID!
    var myID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var player1Score = 0
    var player2Score = 0
    var player3Score = 0
    var player4Score = 0
    var player1ID : MCPeerID!
    var player2ID: MCPeerID!
    var player3ID: MCPeerID!
    var restarted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        restartBtn.isUserInteractionEnabled = false
        session.delegate = self
        browser.delegate = self
        restartBtn.alpha = 0.1
        self.myID = MCPeerID(displayName: UIDevice.current.name)
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
            submitAnswer()
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
     
         if previousOption == ""
                {
                  selectA()
                }
         else if(UaccZ < -1.0)
         {
            
            switch previousOption {
                case "A": clickedA(buttonA)
                case "B": clickedB(buttonB)
                case "C": clickedC(buttonC)
                case "D": clickedD(buttonD)
            default: break
            }
         }
         else if(yaw>1.2 || yaw < -1.2)
         {
            switch previousOption {
            case "A": clickedA(buttonA)
            case "B": clickedB(buttonB)
            case "C": clickedC(buttonC)
            case "D": clickedD(buttonD)
            default: break
            }
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
        let correctAnswer = self.quizArray[self.currentTopicNum].correctOptions[self.currentQuesitonNum]
        let answer = previousOption
        if (correctAnswer == answer) {
            player1Score += 1
        }
        player1AnswerText.text = "\(answer)"
        //highlight submitted answer
        // Check to make sure everyone has an answer in before calling showAnswer
        stopMotionTime()
        let totalPlayer = connectionNum + 1
        print("test2 subNum \(submissionNum)")
        print("test2 conNum\(connectionNum)")
        if (submissionNum == totalPlayer) {
            self.submissionNum = 0
            self.player1AnswerText.text = previousOption
            self.score1.text = "\(player1Score)"
            print("showAnswer from submitAnswer")
            showAnswer()
            self.updateScoreView()
        }
        sendAnswerToOthers(answer: answer)
        //TODO make sure everyone submitted answer
        //TODO
       // print("answer: [\(previousOption) selected]")
    }
    
    func sendAnswerToOthers(answer: String) {
        
        let msg = answer
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg)
        do{
            try self.session.send(dataToSend, toPeers: self.session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
 
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
        diableButtons()
        var correctLetter = quizArray[currentTopicNum].correctOptions[currentQuesitonNum]
        
        var ans = quizArray[currentTopicNum].options[currentQuesitonNum][correctLetter]!
        question.text = "Correct Answer: \(ans)"
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            
            self.startNextQuestion()
        }
    }
    
    func startNextQuestion()
    {
       
        self.submissionNum = 0
        if(currentQuesitonNum+1 < quizArray[currentTopicNum].numberOfQuestions)
        {
            print("Change question")
            currentQuesitonNum+=1
            displayQuestionAndOptions()
            timeCount = 20
            previousOption = ""
            clearBackgroundColocOnButtons()
            startTime()
            StartMotionTime()
            enableButtons()
        }
        else
        {
            restartBtn.isUserInteractionEnabled = true
            restartBtn.alpha = 1.0

        }
        
    }
    

    @IBAction func restart(_ sender: Any) {
        otherUserRestart()
        restartFunction()
    }
   
    func restartFunction() {
        self.submissionNum = 0
        restarted = false;
        if(currentTopicNum==0)
        {
            print("topic change entered 0")
            currentTopicNum=1
            currentQuesitonNum=0
            displayQuestionAndOptions()
            timeCount = 20
            previousOption = ""
            
        }
        else{
            print("topic change entered 1")
            currentTopicNum=0
            currentQuesitonNum=0
            displayQuestionAndOptions()
            timeCount = 20
            previousOption = ""
            
        }
        resetUserAnswers()
        enableButtons()
        stopTimer()
        stopMotionTime()
        startTime()
        StartMotionTime()
        clearBackgroundColocOnButtons()
        restartBtn.isUserInteractionEnabled = false
        restartBtn.alpha = 0.1
    }
    
    func otherUserRestart() {
        let msg = "restart"
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg)
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
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
    
    func diableButtons()
    {
        buttonA.isUserInteractionEnabled=false
        buttonB.isUserInteractionEnabled=false
        buttonC.isUserInteractionEnabled=false
        buttonD.isUserInteractionEnabled=false
    }
    func enableButtons()
    {
        buttonA.isUserInteractionEnabled=true
        buttonB.isUserInteractionEnabled=true
        buttonC.isUserInteractionEnabled=true
        buttonD.isUserInteractionEnabled=true
    }
    
    func resetUserAnswers()
    {
        player1AnswerText.text=""
        player2AnswerText.text=""
        player3AnswerText.text=""
        player4AnswerText.text=""
        
        player1Score = 0
        player2Score = 0
        player3Score = 0
        player4Score = 0
        
        score1.text=""
        score2.text=""
        score3.text=""
        score4.text=""
        
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
                print("myid = \(self.myID)")
                print("senderID = \(peerID)")
                if (receivedString == "A" ||
                    receivedString == "B" ||
                    receivedString == "C" ||
                    receivedString == "D" ) {
                    print("answer received: [\(receivedString)]")
                    print("playerID [\(peerID)]")
                    self.submissionNum += 1
                    self.updateScore(peerID: peerID, receivedString: receivedString)
                    self.updateSubmissionView(peerID: peerID, receivedString: receivedString)
                    let totalPlayers = self.connectionNum + 1
                    if (self.submissionNum == totalPlayers) {
                        self.updateScoreView()
                        print("showAnswer from receviving")
                        self.showAnswer()
                    }
                }
                else if (receivedString == "restart") {
                    print("inside")
                    print("myid = \(self.myID)")
                    print("senderID = \(peerID)")
                    print("topic change entered 2")
                    self.restartFunction()
                    self.restarted = true
                }
            }
        })
    }
    
    func updateSubmissionView(peerID: MCPeerID, receivedString: String) {
        switch peerID {
        case player1ID:
            self.player2AnswerText.text = receivedString
        case player2ID:
            self.player3AnswerText.text = receivedString
        case player3ID:
            self.player4AnswerText.text = receivedString
        default:
            break;
        }
    }
    
    func updateScore(peerID: MCPeerID, receivedString: String) {
        let correctAnswer = self.quizArray[self.currentTopicNum].correctOptions[self.currentQuesitonNum]
        if (receivedString == correctAnswer) {
            switch peerID {
            case player1ID:
                self.player2Score += 1
                print()
            case player2ID:
                self.player3Score += 1
            case player3ID:
                self.player4Score += 1
            default:
                break
            }
        }
    }
    
    func updateScoreView() {
        switch connectionNum {
        case 1:
            score1.text = "\(player1Score)"
            score2.text = "\(player2Score)"
        case 2:
            score1.text = "\(player1Score)"
            score2.text = "\(player2Score)"
            score3.text = "\(player3Score)"
        case 3:
            score1.text = "\(player1Score)"
            score2.text = "\(player2Score)"
            score3.text = "\(player3Score)"
            score4.text = "\(player4Score)"
        default: break
            
        }
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


