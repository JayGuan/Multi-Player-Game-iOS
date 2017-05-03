//
//  Connection.swift
//  QuizTime
//
//  Created by Jay Guan on 5/3/17.
//  Copyright © 2017 Remi Bear. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class Connection {
    var session: MCSession!
    var peerID: MCPeerID!
    var browser: MCBrowserViewController!
    var assistant: MCAdvertiserAssistant!

    init(session: MCSession, peerID: MCPeerID, browser: MCBrowserViewController, assistant: MCAdvertiserAssistant) {
        self.session = session
        self.peerID = peerID
        self.browser = browser
        self.assistant = assistant
    }
    
    init() {
    
    }
}
