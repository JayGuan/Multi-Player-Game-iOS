//
//
//
//
//
//

import UIKit
import MultipeerConnectivity

class ViewController: UIViewController, MCBrowserViewControllerDelegate, MCSessionDelegate {
    
    var session: MCSession!
    var peerID: MCPeerID!
    
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
        
        var quiz = Quiz(jsonURL:"http://www.people.vcu.edu/~ebulut/jsonFiles/quiz1.json")
        
        quizArray.append(quiz)
        
        print("in here \(quiz.numberOfQuestions)")
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
    
    @IBAction func singlePlayer(_ sender: UIButton) {
       print("Single player")
        print(quizArray[0].numberOfQuestions)
        
        var numQ = quizArray[0].numberOfQuestions as Int
        
        for i in 0...numQ-1
        {
            print(quizArray[0].questionSentences[i])
            print(quizArray[0].options[i])
            print(quizArray[0].correctOptions[i])
            
        }

        

    }
    
    
    @IBAction func multiPlayer(_ sender: UIButton) {
        
    }
    
    
    @IBAction func startGame(_ sender: UIButton) {
        
    }
    
    /*
    @IBAction func sendMessage(_ sender: UIButton) {
        
        let msg = messageTF.text
        let dataToSend =  NSKeyedArchiver.archivedData(withRootObject: msg!)
        
        do{
            try session.send(dataToSend, toPeers: session.connectedPeers, with: .unreliable)
        }
        catch let err {
            //print("Error in sending data \(err)")
        }
        
        updateChatView(newText: msg!, id: peerID)
        
    }
    
    func updateChatView(newText: String, id: MCPeerID){
        
        let currentText = chatWindow.text
        var addThisText = ""
        
        if(id == peerID){
            addThisText = "Me: " + newText + "\n"
        }
        else
        {
            addThisText = "\(id.displayName): \(newText)\n"
        }
        chatWindow.text = currentText! + addThisText
        
    }
*/
    
    
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

