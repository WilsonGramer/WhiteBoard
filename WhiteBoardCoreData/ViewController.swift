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
    
    @IBOutlet weak var todayBoard: UITextView!
    @IBOutlet weak var noteToSelfBoard: UITextView!
    @IBOutlet weak var status: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //var todayBoardValueArray:[String] = []
    //var noteToSelfBoardValueArray:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBoards() // Loads core data.
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.UIApplicationWillResignActive, object: nil) // Detects when app enters background.
    }
    
    //MARK: Saving core data
    func saveBoards() {
        let context = appDelegate.persistentContainer.viewContext
        let boardValues = NSEntityDescription.insertNewObject(forEntityName: "BoardValues", into: context)
        
        boardValues.setValue(todayBoard.text, forKey: "todayBoardValue")
        boardValues.setValue(noteToSelfBoard.text, forKey: "noteToSelfBoardValue")
        
        do {
            try context.save()
            status.text = "Saved."
        } catch {
            // Error handling
            print("error.")
        }
    }
    
    //MARK: Loading core data
    func loadBoards() {
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
        } catch {
            // Error handling
            print("error.")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func appMovedToBackground() {
        saveBoards()
    }
}

