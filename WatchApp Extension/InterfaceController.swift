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
    
    // UserDefaults for app group
    var appGroup = UserDefaults(suiteName: "group.co.neef.ios.WhiteBoardGroup")
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        // UserDefaults!! Much simpler this way
        var todayBoardText = appGroup?.string(forKey: "todayBoardValue")
        var noteToSelfBoardText = appGroup?.string(forKey: "noteToSelfBoardValue")
        
        print("Today text is: \(todayBoardText)")
        print("NTS text is: \(noteToSelfBoardText)")
        
        // Set labels
        self.todayBoard.setText(todayBoardText)
        self.noteToSelfBoard.setText(noteToSelfBoardText)
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
