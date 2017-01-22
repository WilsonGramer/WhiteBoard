//
//  ViewController.swift
//  WhiteBoardCoreData
//
//  Created by Wilson Gramer on 1/21/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var todayBoard: UITextView!
    @IBOutlet weak var noteToSelfBoard: UITextView!
    @IBOutlet weak var status: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK; Load keyboard
        todayBoard.becomeFirstResponder()
        
        //MARK: Auto load core data
        loadCoreData()
    }
    
//    @IBAction func saveBoards(_ sender: Any) {
//        let entityDescription =
//            NSEntityDescription.entity(forEntityName: "BoardValues",
//                                       in: managedObjectContext)
//        
//        let boardValues = BoardValues(entity: entityDescription!,
//                               insertInto: managedObjectContext)
//        
//        boardValues.todayBoardValue = todayBoard.text!
//        boardValues.noteToSelfBoardValue = noteToSelfBoard.text!
//        
//        do {
//            try managedObjectContext.save()
//            //todayBoard.text = ""
//            //noteToSelfBoard.text = ""
//            status.text = "Boards Saved"
//            
//        } catch let error {
//            status.text = error.localizedDescription
//        }
//    }
//    
//    @IBAction func findBoards(_ sender: Any) {
//        let entityDescription =
//            NSEntityDescription.entity(forEntityName: "BoardValues",
//                                       in: managedObjectContext)
//        
//        let request: NSFetchRequest<BoardValues> = BoardValues.fetchRequest()
//        request.entity = entityDescription
//        
//        let pred = NSPredicate(format: "(todayBoardValue = %@)", todayBoard.text!)
//        request.predicate = pred
//        
//        do {
//            var results =
//                try managedObjectContext.fetch(request as!
//                    NSFetchRequest<NSFetchRequestResult>)
//            
//            if results.count > 0 {
//                let match = results[0] as! NSManagedObject
//                
//                todayBoard.text = match.value(forKey: "todayBoardValue") as? String
//                noteToSelfBoard.text = match.value(forKey: "noteToSelfBoardValue") as? String
//                status.text = "Matches found: \(results.count)"
//            } else {
//                status.text = "No Match"
//            }
//            
//        } catch let error {
//            status.text = error.localizedDescription
//        }
//    }
    
    //MARK: Saving core data
    @IBAction func saveBoards(_ sender: Any) {
        let context = appDelegate.persistentContainer.viewContext
        let boardValues = NSEntityDescription.insertNewObject(forEntityName: "BoardValues", into: context)
        
        boardValues.setValue(todayBoard.text, forKey: "todayBoardValue")
        boardValues.setValue(noteToSelfBoard.text, forKey: "noteToSelfBoardValue")
        
        do {
            try context.save()
            status.text = "Successfully saved boards."
        } catch {
            // Error handling
            print("error while saving.")
        }
    }
    
    //MARK: Loading core data
    @IBAction func findBoards(_ sender: Any) {
        loadCoreData()
    }
    
    func loadCoreData() {
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "BoardValues")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let todayBoardValue = result.value(forKey: "todayBoardValue") as? String {
                        todayBoard.text = todayBoardValue
                        print(todayBoardValue)
                    }
                    if let noteToSelfBoardValue = result.value(forKey: "noteToSelfBoardValue") as? String {
                        noteToSelfBoard.text = noteToSelfBoardValue
                        print(noteToSelfBoardValue)
                    }
                }
            }
            
            status.text = "Successfully loaded boards."
        } catch {
            // Error handling
            print("error while loading.")
            status.text = "error while loading."
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

