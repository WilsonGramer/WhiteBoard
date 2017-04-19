//
//  InterfaceController.swift
//  WatchApp Extension
//
//  Created by Wilson Gramer on 4/19/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var todayBoard: WKInterfaceLabel!
    @IBOutlet var noteToSelfBoard: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // UserDefaults!! Much simpler this way
        todayBoard.setText(UserDefaults(suiteName: "group.co.neef.ios.WhiteBoardGroup")!.string(forKey: "todayBoardValue"))
        noteToSelfBoard.setText(UserDefaults(suiteName: "group.co.neef.ios.WhiteBoardGroup")!.string(forKey: "noteToSelfBoardValue"))
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
