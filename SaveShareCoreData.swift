//
//  SaveShareCoreData.swift
//  WhiteBoardCoreData
//
//  Created by Wilson Gramer on 4/19/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import UIKit

class SaveShareCoreData {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func saveSharedText(shareText: String) {
        let context = appDelegate.persistentContainer.viewContext
        let boardValues = NSEntityDescription.insertNewObject(forEntityName: "BoardValues", into: context)
        
        boardValues.setValue(noteToSelfBoard.text + "\n" + shareText, forKey: "noteToSelfBoardValue")
        
        do {
            try context.save()
            status.text = "Successfully saved shared text to Note to Self board."
        } catch {
            // Error handling
            print("error while saving shared text.")
        }
    }
    
}
