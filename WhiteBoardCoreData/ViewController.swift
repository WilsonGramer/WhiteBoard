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
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var noteToSelfLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var darkModeOverlayLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK; Load keyboard
        todayBoard.becomeFirstResponder()
        
        //MARK: Auto load core data
        loadCoreData()
        
        //MARK: Check for dark mode toggle (call)
        checkDarkModeSetting()
    }
    
    //MARK: Check for dark mode toggle (method)
    func checkDarkModeSetting() {
        // Read value of TextField with an identifier "name_preference"
        let userDefaults = UserDefaults.standard
        let toggle = userDefaults.string(forKey: "theme_darkmode")
        print("Toggle = \(toggle)")
        
        if toggle == "1" {
            
            //MARK: Makes the UI dark and the text white (dark mode).
            self.view.backgroundColor = UIColor.black
            
            todayBoard.backgroundColor = UIColor.darkGray
            todayBoard.textColor = UIColor.white
            
            noteToSelfBoard.backgroundColor = UIColor.darkGray
            noteToSelfBoard.textColor = UIColor.white
            
            logoLabel.textColor = UIColor.gray
            todayLabel.textColor = UIColor.white
            noteToSelfLabel.textColor = UIColor.white
            
            status.textColor = UIColor.white
            darkModeOverlayLabel.isHidden = false
            todayBoard.keyboardAppearance = UIKeyboardAppearance.dark
            noteToSelfBoard.keyboardAppearance = UIKeyboardAppearance.dark
        } else {
            //MARK: Makes the UI light and the text black (light mode).
            self.view.backgroundColor = UIColor.white
            
            todayBoard.backgroundColor = UIColor.white
            todayBoard.textColor = UIColor.black
            
            noteToSelfBoard.backgroundColor = UIColor.white
            noteToSelfBoard.textColor = UIColor.black
            
            logoLabel.textColor = UIColor.black
            
            todayLabel.textColor = UIColor.black
            noteToSelfLabel.textColor = UIColor.black
            
            status.textColor = UIColor.black
            darkModeOverlayLabel.isHidden = true
            todayBoard.keyboardAppearance = UIKeyboardAppearance.light
            noteToSelfBoard.keyboardAppearance = UIKeyboardAppearance.light
        }
    }
    
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
    
    //MARK: Clears the boards.
    @IBAction func clearBoards(_ sender: Any) {
        todayBoard.text = ""
        noteToSelfBoard.text = ""
        status.text = "Cleared."
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

