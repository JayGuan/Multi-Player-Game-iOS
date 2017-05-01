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
    var session: MCSession!
    var peerID: MCPeerID!
    var gameType = -1;
    var quizArray = [Quiz]()
    
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!
      
    
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
            gameType = 0
        }
        else if gameSelector.selectedSegmentIndex == 1
        {
            gameType = 1
        }
        
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("This does not tyoe")
        if segue.identifier == "showGameScreen" {
            if let DVC = segue.destination as? gameScreen{
                DVC.gameType = gameType
                DVC.quizArray = quizArray
                       }
        }
    }

    
    
    @IBAction func startGame(_ sender: UIButton) {
         print("in segue")
        print(quizArray[0].numberOfQuestions)
        
        // gameScreen().quizArray = quizArray
        if(gameType != -1)
        {
        performSegue(withIdentifier: "showGameScreen", sender: self)
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
        
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        
        // this needs to be run on the main thread
        DispatchQueue.main.async(execute: {
            
            if let receivedString = NSKeyedUnarchiver.unarchiveObject(with: data) as? String{
              //  self.updateChatView(newText: receivedString, id: peerID)
            }
            
        })
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        
        // Called when a connected peer changes state (for example, goes offline)
        
        switch state {
        case MCSessionState.connected:
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

