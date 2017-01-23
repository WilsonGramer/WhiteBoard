//
//  ViewController.swift
//  WhiteBoardCoreData
//
//  Created by Wilson Gramer on 1/21/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import UIKit
import CoreData

extension UIView {
    func addBackground() {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: width, height: height)))
        imageViewBackground.image = UIImage(named: "PIZZA.jpg")
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}

class ViewController: UIViewController {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var todayBoard: UITextView!
    @IBOutlet weak var noteToSelfBoard: UITextView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var todayLabel: UILabel!
    @IBOutlet weak var noteToSelfLabel: UILabel!
    @IBOutlet weak var logoLabel: UILabel!
    @IBOutlet weak var darkModeOverlayLabel: UILabel!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let whiteBoardLogoImage = "Whiteboard.png"
    let whiteBoardLogoInvertedImage = "Whiteboard-inverted.png"
    let pizzaImage = "PIZZA.jpg"
    let ianOfIansImage = "Ian of Ians.jgp"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK; Load keyboard
        todayBoard.becomeFirstResponder()
        
        //MARK: Auto load core data
        loadCoreData()
        
        //MARK: Check for dark mode toggle (call)
        checkDarkModeSetting()
        
        //MARK: Set custom name from settings (call)
        setCustomName()
    }
    
    //MARK: Check for dark mode toggle (method)
    func checkDarkModeSetting() {
        // Read value of TextField with an identifier "name_preference"
        let userDefaults = UserDefaults.standard
        let toggle = userDefaults.string(forKey: "theme_darkmode")
        print("Toggle = \(toggle)")
        
        let whiteBoardLogo = UIImage(named: whiteBoardLogoImage)
        let whiteBoardLogoInverted = UIImage(named: whiteBoardLogoInvertedImage)
        
        if toggle == "1" {
            
            //MARK: Makes the UI dark and the text white (dark mode).
            self.view.backgroundColor = UIColor.black
            
            imageLogo.image = whiteBoardLogoInverted
            
            todayBoard.backgroundColor = UIColor.darkGray
            todayBoard.textColor = UIColor.white
            
            noteToSelfBoard.backgroundColor = UIColor.darkGray
            noteToSelfBoard.textColor = UIColor.white
            
            logoLabel.textColor = UIColor.gray
            
            todayLabel.textColor = UIColor.white
            noteToSelfLabel.textColor = UIColor.white
            nameLabel.textColor = UIColor.white
            
            status.textColor = UIColor.white
            darkModeOverlayLabel.isHidden = false
            todayBoard.keyboardAppearance = UIKeyboardAppearance.dark
            noteToSelfBoard.keyboardAppearance = UIKeyboardAppearance.dark
            
        } else {
            
            //MARK: Makes the UI light and the text black (light mode).
            self.view.backgroundColor = UIColor.white
            
            imageLogo.image = whiteBoardLogo
            
            todayBoard.backgroundColor = UIColor.white
            todayBoard.textColor = UIColor.black
            
            noteToSelfBoard.backgroundColor = UIColor.white
            noteToSelfBoard.textColor = UIColor.black
            
            logoLabel.textColor = UIColor.black
            
            todayLabel.textColor = UIColor.black
            noteToSelfLabel.textColor = UIColor.black
            nameLabel.textColor = UIColor.black
            
            status.textColor = UIColor.black
            darkModeOverlayLabel.isHidden = true
            todayBoard.keyboardAppearance = UIKeyboardAppearance.light
            noteToSelfBoard.keyboardAppearance = UIKeyboardAppearance.light
            
        }
    }
    
    //MARK: Set custom name from settings (method)
    func setCustomName() {
        // Read value of TextField with an identifier "name_preference"
        let userDefaults = UserDefaults.standard
        let name = userDefaults.string(forKey: "name")
        print("Custom Name = \(name)")
        
        if name == "" {
            nameLabel.text = ""
        } else if name == "pizzaficati0n" {
            let ianOfIans = UIImage(named: ianOfIansImage)
            nameLabel.text = "GOOD DAY SIR."
            imageLogo.image = ianOfIans
            self.view.addBackground()
        } else {
            nameLabel.text = "\(name ?? "")'s"
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

