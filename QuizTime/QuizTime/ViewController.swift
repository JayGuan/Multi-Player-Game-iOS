//Christian Merk
//
//
//
//
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    @IBOutlet var gameSelector: UISegmentedControl!
    @IBOutlet weak var startGameButton: UIButton!
    
    var session: MCSession!
    var peerID: MCPeerID!
    var gameType = 0;
    var quizArray = [Quiz]()
    var connectionNum = 0
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
    var startedGame = false
    var player1ID : MCPeerID!
    var player2ID: MCPeerID!
    var player3ID: MCPeerID!
    //var connection = Connection()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.peerID = MCPeerID(displayName: UIDevice.current.name)
        self.session = MCSession(peer: peerID)
        self.browser = MCBrowserViewController(serviceType: "chat", session: session)
        self.assistant = MCAdvertiserAssistant(serviceType: "chat", discoveryInfo: nil, session: session)
        assistant.start()
        session.delegate = self
        browser.delegate = self
        //connection = Connection.init(session: self.session, peerID: self.peerID, browser: self.browser, assistant: self.assistant)
        
        let quiz = Quiz(jsonURL:"http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json")
        let quiz2 = Quiz(jsonURL:"http://www.people.vcu.edu/~ebulut/jsonFiles/quiz2.json")
        
       quizArray.append(quiz)
       quizArray.append(quiz2)
        
      //  print("in here \(quiz.numberOfQuestions)")
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
    
    
   
    @IBAction func connect(_ sender: UIButton) {
        
    present(browser, animated: true, completion: nil)
        
    }
    
  
    @IBAction func selectGameType(_ sender: Any) {
        
        if gameSelector.selectedSegmentIndex == 0
        {
            // 0 = single player
            gameType = 0
        }
        else if gameSelector.selectedSegmentIndex == 1
        {
            // 1 = multi player
            gameType = 1
        }
        
    }
    
    func notifyOtherUsers() {
        let msg = "begin"
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg)
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("This does not tyoe")
        if segue.identifier == "showGameScreen" {
            if let DVC = segue.destination as? gameScreen{
                //TODO check game type, if multi player then switch all user's screen to game scene
                if (gameType == 1) {
                    notifyOtherUsers()
                }
                //DVC.connection = self.connection
                DVC.gameType = gameType
                DVC.quizArray = quizArray
                DVC.connectionNum = self.connectionNum
                DVC.session = self.session
                DVC.peerID = self.peerID
                DVC.browser = self.browser
                DVC.assistant = self.assistant
                DVC.player1ID = self.player1ID
                DVC.player2ID = self.player2ID
                DVC.player3ID = self.player3ID
            }
        }
    }

    
    
    @IBAction func startGame(_ sender: UIButton) {
         print("in segue")
        print(quizArray[0].numberOfQuestions)
        startedGame = true
        // gameScreen().quizArray = quizArray
        if(gameType != -1)
        {
            //for multi player game, check number of connections
            if (gameType == 1 && (connectionNum == 0 || connectionNum > 3)) {
                let alert = UIAlertController(title: "Error", message: "Number of players should be at least 2 and at most 4", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            else {
                performSegue(withIdentifier: "showGameScreen", sender: self)
            }
           
        }
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
            }
            
        })
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
            connectionNum += 1
            print("Connection Test: [\(connectionNum)]")
            print("Connected: \(peerID.displayName)")
            switch connectionNum {
            case 1: player1ID = peerID
            case 2: player2ID = peerID
            case 3: player3ID = peerID
            default:
                break
            }
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

