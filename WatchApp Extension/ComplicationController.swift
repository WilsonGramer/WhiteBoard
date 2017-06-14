//
//  ComplicationController.swift
//  WatchApp Extension
//
//  Created by Wilson Gramer on 4/19/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import ClockKit
import WatchKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    // UserDefaults for app group
    var appGroup = UserDefaults(suiteName: "group.co.neef.ios.WhiteBoardGroup")
    
    // InterfaceController reference
    //let interfaceController = InterfaceController()
    
    // MARK: - Timeline Configuration
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler(CLKComplicationTimeTravelDirections())
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(nil)
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    // Keys for accessing the complicationData dictionary.
    let ComplicationCurrentEntry = "ComplicationCurrentEntry"
    let ComplicationTextData = "ComplicationTextData"
    let ComplicationShortTextData = "ComplicationShortTextData"
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimelineEntry?) -> Void) {
        
        var entry : CLKComplicationTimelineEntry?
        let now = NSDate()
        
        // gets values and makes sure the complication is never nil (provides default value if nil)
        var wkTodayBoardValue = appGroup?.string(forKey: "wkTodayBoardValue")
        var wkNoteToSelfBoardValue = appGroup?.string(forKey: "wkNoteToSelfBoardValue")
        
        if (wkTodayBoardValue == nil || wkTodayBoardValue == "") && (wkNoteToSelfBoardValue == nil || wkNoteToSelfBoardValue == "") {
            wkTodayBoardValue = "Write something on"
            wkNoteToSelfBoardValue = "the iPhone app!" 
        }
        
        // Create the template and timeline entry.
        if complication.family == .modularLarge { // makes sure complication is modular large
            let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody() // set complication type (modular large)
            modularLargeTemplate.tintColor = UIColor.cyan // set color of header text
            modularLargeTemplate.headerTextProvider = CLKSimpleTextProvider(text: "WhiteBoard") // set header text
            modularLargeTemplate.body1TextProvider = CLKSimpleTextProvider(text: wkTodayBoardValue!) // set first line of body text
            modularLargeTemplate.body2TextProvider = CLKSimpleTextProvider(text: wkNoteToSelfBoardValue!) // set second line of body text
            
            // Create the entry.
            entry = CLKComplicationTimelineEntry(date: now as Date, complicationTemplate: modularLargeTemplate)
        } else {
            // ...configure entries for other complication families.
        }
        
        // Pass the timeline entry back to ClockKit.
        handler(entry)
    }
    
    
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries prior to the given date
        handler(nil)
    }
    
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: @escaping ([CLKComplicationTimelineEntry]?) -> Void) {
        // Call the handler with the timeline entries after to the given date
        handler(nil)
    }
    
    // MARK: - Placeholder Templates
    
    func getLocalizableSampleTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        // This method will be called once per supported complication, and the results will be cached
//        handler(nil)
        
        var template: CLKComplicationTemplate?
        switch complication.family {
        case .modularSmall:
            template = nil
        case .modularLarge:
            let modularLargeTemplate = CLKComplicationTemplateModularLargeStandardBody()
            modularLargeTemplate.headerTextProvider =
                CLKSimpleTextProvider(text: "WhiteBoard")
            modularLargeTemplate.body1TextProvider =
                CLKSimpleTextProvider(text: (appGroup?.string(forKey: "wkTodayBoardValue") ?? "Write something on"))
            modularLargeTemplate.body2TextProvider =
                CLKSimpleTextProvider(text: (appGroup?.string(forKey: "wkNoteToSelfBoardValue") ?? "the iPhone app!"))
            modularLargeTemplate.tintColor = UIColor.cyan
            template = modularLargeTemplate
        case .utilitarianSmall:
            template = nil
        case .utilitarianLarge:
            template = nil
        case .circularSmall:
            template = nil
        case .utilitarianSmallFlat:
            template = nil
        case .extraLarge:
            template = nil
        }
        handler(template)
    }
    
}
