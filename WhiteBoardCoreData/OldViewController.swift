//
//  ViewController.swift
//  WhiteBoardCoreData
//
//  Created by Wilson Gramer on 1/21/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import UIKit
import CoreData

class OldViewController: UIViewController {

    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var todayBoard: UITextView!
    @IBOutlet weak var noteToSelfBoard: UITextView!
    @IBOutlet weak var status: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func saveBoards(_ sender: Any) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "BoardValues",
                                       in: managedObjectContext)
        
        let boardValues = BoardValues(entity: entityDescription!,
                               insertInto: managedObjectContext)
        
        boardValues.todayBoardValue = todayBoard.text!
        boardValues.noteToSelfBoardValue = noteToSelfBoard.text!
        
        do {
            try managedObjectContext.save()
            //todayBoard.text = ""
            //noteToSelfBoard.text = ""
            status.text = "Boards Saved"
            
        } catch let error {
            status.text = error.localizedDescription
        }
    }
    
    /*@IBAction func findBoards(_ sender: Any) {
        let entityDescription =
            NSEntityDescription.entity(forEntityName: "BoardValues",
                                       in: managedObjectContext)
        
        let request: NSFetchRequest<BoardValues> = BoardValues.fetchRequest()
        request.entity = entityDescription
        
        let pred = NSPredicate(format: "(todayBoardValue = %@)", todayBoard.text!)
        request.predicate = pred
        
        do {
            var results =
                try managedObjectContext.fetch(request as!
                    NSFetchRequest<NSFetchRequestResult>)
            
            if results.count > 0 {
                let match = results[0] as! NSManagedObject
                
                todayBoard.text = match.value(forKey: "todayBoardValue") as? String
                print(match.value(forKey: "todayBoardValue") as? String)
                noteToSelfBoard.text = match.value(forKey: "noteToSelfBoardValue") as? String
                status.text = "Matches found: \(results.count)"
            } else {
                status.text = "No Match"
            }
            
        } catch let error {
            status.text = error.localizedDescription
        }
    }*/
    
    @IBAction func findBoards(_ sender: Any) {
        let moc = managedObjectContext
        let employeesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "todayBoardValue")
        
        do {
            let fetchedBoards = try moc.fetch(employeesFetch) as! [BoardValues]
            todayBoard.text = "\(fetchedBoards)"
            status.text = "Loaded boards."
        } catch {
            status.text = "Failed to fetch boards: \(error)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

