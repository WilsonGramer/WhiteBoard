//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Wilson Gramer on 4/19/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    @IBOutlet var todayBoard: WKInterfaceLabel!
    @IBOutlet var noteToSelfBoard: WKInterfaceLabel!
    
    var watchSession : WCSession?
    
    var todayBoardText = "nil"
    var noteToSelfBoardText = "nil"
    
    // UserDefaults for app group
    var appGroup = UserDefaults(suiteName: "group.co.neef.ios.WhiteBoardGroup")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    @IBAction func sendMessage(sender: AnyObject) {
        watchSession?.sendMessage(
            ["message":"increment"],
            replyHandler: { (message: [String : Any]) in
        },
            errorHandler: { (err: Error) in
        })
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        if (WCSession.isSupported()) {
            watchSession = WCSession.default()
            // Add self as a delegate of the session so we can handle messages
            watchSession!.delegate = self
            watchSession!.activate()
        }
        
        // UserDefaults!! Much simpler this way
        todayBoard.setText(appGroup?.string(forKey: "wkTodayBoardValue"))
        noteToSelfBoard.setText(appGroup?.string(forKey: "wkNoteToSelfBoardValue"))
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        NSLog("Watch session activated")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // Sets labels
        todayBoard.setText((message["today"] as! String))
        noteToSelfBoard.setText((message["nts"] as! String))
        
        // UserDefaults!! Much simpler this way
        appGroup?.set(message["today"] as! String, forKey: "wkTodayBoardValue")
        appGroup?.set(message["nts"] as! String, forKey: "wkNoteToSelfBoardValue")
        appGroup?.synchronize()
        
        let server = CLKComplicationServer.sharedInstance()
        for complication: CLKComplication in server.activeComplications! {
            server.reloadTimeline(for: complication)
        }
        
        print("Successfully recieved data from iPhone. [InterfaceController.swift:82]")
        replyHandler([:])
    }
}
