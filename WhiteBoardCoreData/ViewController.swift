//
//  ViewController.swift
//  WhiteBoardCoreData
//
//  Created by Wilson Gramer on 1/21/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import UIKit
import CoreData
import Darwin

extension UIView {
    func addBackground(image: UIImage) {
        // screen width and height:
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: width, height: height)))
        imageViewBackground.image = image
        
        // you can change the content mode:
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}

extension CGRect {
    var wh: (w: CGFloat, h: CGFloat) {
        return (size.width, size.height)
    }
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                  return "iPod Touch 5"
        case "iPod7,1":                                  return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":      return "iPhone 4"
        case "iPhone4,1":                                return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                   return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                   return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                   return "iPhone 5s"
        case "iPhone7,2":                                return "iPhone 6"
        case "iPhone7,1":                                return "iPhone 6 Plus"
        case "iPhone8,1":                                return "iPhone 6s"
        case "iPhone8,2":                                return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                   return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                   return "iPhone 7 Plus"
        case "iPhone8,4":                                return "iPhone SE"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":            return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":            return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":            return "iPad Air"
        case "iPad5,3", "iPad5,4":                       return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":            return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":            return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":            return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                       return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8": return "iPad Pro"
        case "AppleTV5,3":                               return "Apple TV"
        case "i386", "x86_64":                           return "Simulator"
        default:                                         return identifier
        }
    }
    
}

//MARK: Extra colors for themes.
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
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
    let userDefaults = UserDefaults.standard
    
    let whiteBoardLogoImage = "Whiteboard.png"
    let whiteBoardLogoInvertedImage = "Whiteboard-inverted.png"
    let pizzaImage = "PIZZA.jpg"
    let ianOfIansImage = "Ian of Ians.jpg"
    
    let (cgWidth, cgHeight) = UIScreen.main.applicationFrame.wh
    var width: Int = 0
    var height: Int = 0
    
    var firstTimeLaunch: Bool = true
    
    //MARK: Colors
    let c_peachLight = UIColor(red: 248, green: 200, blue: 165)
    let c_peachDark = UIColor(red: 241, green: 123, blue: 105)
    let c_lightBlue = UIColor(red: 182, green: 219, blue: 247)
    let c_navyBlue = UIColor(red: 4, green: 27, blue: 56)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK; Load keyboard
        todayBoard.becomeFirstResponder()
        
        //MARK: Auto load core data
        loadCoreData()
        
        //MARK: Check for dark mode toggle (call)
        checkDarkModeSetting()
        
        //MARK: Set custom name from settings (call)
        setSettings()
        
        //MARK: Check first-time launch and change settings
        firstTimeLaunch = checkFirstLaunch()
        
        if firstTimeLaunch == true {
            //self.dismiss(animated: true, completion: nil); print("dismissed boardsView.")
            //let vc = self.storyboard?.instantiateViewController(withIdentifier: "firstTimeLaunchScreen")
            //self.navigationController?.present(vc!, animated: true, completion: nil); print("switched to the view.")
            status.text = "First-time setup, restarting..."
            
            userDefaults.setValue("Note to Self", forKey: "ntsname")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil) // Closes the app gracefully after 5 seconds
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                exit(0)
            })
        }
        
        width = Int(cgWidth)
        height = Int(cgHeight)
        print("The width is \(width) and the height is \(height).")
        
        //MARK: Finding device and scaling display
        let modelName = UIDevice.current.modelName
        print("Running on an \(modelName).")
        
        switch modelName {
            case "iPhone 5", "iPhone 5s", "iPhone 5c", "iPhone SE":
                view.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            case "iPhone 6", "iPhone 6s", "iPhone 7":
                view.transform = CGAffineTransform(scaleX: 1, y: 1)
            case "iPhone 6 Plus", "iPhone 6s Plus", "iPhone 7 Plus":
                view.transform = CGAffineTransform(scaleX: 2, y: 2)
            default:
                print("Error while finding device model name or resizing display - maybe running on an unsupported device?")
        }
        
        setAlternateIcon()
    }
    
    //MARK: Check for dark mode toggle (method)
    func checkDarkModeSetting() {
        // Read value of TextField with an identifier "name_preference"
        let userDefaults = UserDefaults.standard
        let toggle = userDefaults.string(forKey: "theme")
        print("Toggle = \(toggle)")
        
        let whiteBoardLogo = UIImage(named: whiteBoardLogoImage)
        let whiteBoardLogoInverted = UIImage(named: whiteBoardLogoInvertedImage)
        
        switch toggle {
        case "dark"?:
            //MARK: Makes the UI dark and the text white (dark mode).
            setTheme(bgColor: .black, logoImage: whiteBoardLogoInverted!, boardColor: .darkGray, boardText: .white, logoText: .gray, boardLabel: .white, nameColor: .white, statusText: .white, isDarkModeOverlayShown: true, keyboard: .dark)
        case "white"?:
            //MARK: Makes the UI light and the text black (light mode).
            setTheme(bgColor: .white, logoImage: whiteBoardLogo!, boardColor: .white, boardText: .black, logoText: .black, boardLabel: .black, nameColor: .black, statusText: .black, isDarkModeOverlayShown: false, keyboard: .light)
        case "peach"?:
            //MARK: Sets 'peach' theme.
            setTheme(bgColor: c_peachDark, logoImage: whiteBoardLogo!, boardColor: c_peachLight, boardText: c_navyBlue, logoText: c_navyBlue, boardLabel: c_navyBlue, nameColor: c_navyBlue, statusText: c_navyBlue, isDarkModeOverlayShown: false, keyboard: .light)
        default:
            //MARK: Default option - light mode.
            setTheme(bgColor: .white, logoImage: whiteBoardLogo!, boardColor: .white, boardText: .black, logoText: .black, boardLabel: .black, nameColor: .black, statusText: .black, isDarkModeOverlayShown: false, keyboard: .light)
        }
    }
    
    //MARK: Applies custom settings
    func setSettings() {
        // Read value of TextField with an identifier "name_preference"
        var name = userDefaults.string(forKey: "name")
        print("Custom Name = \(String(describing: name))")
        
        name = name ?? ""
        
        if name == "" {
            nameLabel.text = ""
        } else if name?[(name?.index(before: (name?.endIndex)!))!]  == "s" {
            nameLabel.text = "\(name ?? "[ERROR]")'"
        } else {
            nameLabel.text = "\(name ?? "[ERROR]")'s"
        }
            
        if name == "pizzaficati0n" {
            let ianOfIans = UIImage(named: ianOfIansImage)
            nameLabel.text = "GOOD DAY SIR."
            imageLogo.image = ianOfIans
            self.view.addBackground(image: UIImage(named: "PIZZA.jpg")!)
        }
        
        let ntsname = userDefaults.string(forKey: "ntsname")
        noteToSelfLabel.text = ntsname
        
        let autoDarkMode = userDefaults.string(forKey: "autodarkmode")
        
        let whiteBoardLogo = UIImage(named: whiteBoardLogoImage)
        let whiteBoardLogoInverted = UIImage(named: whiteBoardLogoInvertedImage)
        
        if autoDarkMode == "1" {
            if autoCheckDarkMode() {
                //MARK: Makes the UI dark and the text white (dark mode).
                setTheme(bgColor: .black, logoImage: whiteBoardLogoInverted!, boardColor: .darkGray, boardText: .white, logoText: .gray, boardLabel: .white, nameColor: .white, statusText: .white, isDarkModeOverlayShown: true, keyboard: .dark)
            } else {
                //MARK: Makes the UI light and the text black (light mode).
                setTheme(bgColor: .white, logoImage: whiteBoardLogo!, boardColor: .white, boardText: .black, logoText: .black, boardLabel: .black, nameColor: .black, statusText: .black, isDarkModeOverlayShown: false, keyboard: .light)
            }
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
        
        //setAlternateIcon()
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
    
    func checkFirstLaunch() -> Bool {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            return false
        } else {
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set("white", forKey: "appIconSetting")
            return true
        }
    }
    
    func modifyAssets() {
        let filePath = Bundle.main.resourcePath!
        let textContent = filePath + "/ic_custom.png"
    }
    
    func setAlternateIcon() {
        let iconSetting = userDefaults.string(forKey: "appIconSetting")
        print("The icon setting is: \(iconSetting ?? "error getting appIconSetting.")")
        
        switch iconSetting! {
        case "white":
            specifyIcon(nil)
        case "dark":
            specifyIcon("dark")
        case "text":
            specifyIcon("text")
        case "textdark":
            specifyIcon("textdark")
        case "rainbow":
            specifyIcon("rainbow")
        default:
            specifyIcon(nil)
            print("ERROR setting icon.")
        }
    }
    
    func specifyIcon(_ icon: String?) {
        UIApplication.shared.setAlternateIconName(icon) { (error) in
            if let error = error {
                print("err: \(error)")
                // icon probably wasn't defined in plist file, handle the error
            }
        }
    }
    
//    func updateZoom() {
//        scrollView.minimumZoomScale = min(self.scrollView.bounds.size.width / self.imageView?.image?.size?.width, self.scrollView.bounds.size.height / self.imageView?.image?.size?.height)
//        if scrollView.zoomScale < self.scrollView.minimumZoomScale {
//            scrollView.zoomScale = self.scrollView.minimumZoomScale
//        }
//    }
    
    //MARK: Set theme from device
    func setTheme(bgColor: UIColor, logoImage: UIImage, boardColor: UIColor, boardText: UIColor, logoText: UIColor, boardLabel: UIColor, nameColor: UIColor, statusText: UIColor, isDarkModeOverlayShown: Bool, keyboard: UIKeyboardAppearance) {
        
        //////////////////////////////////////////////////////////////////////////////////////////////////
        
        view.backgroundColor = bgColor
        
        imageLogo.image = logoImage
        
        todayBoard.backgroundColor = boardColor
        todayBoard.textColor = boardText
        
        noteToSelfBoard.backgroundColor = boardColor
        noteToSelfBoard.textColor = boardText
        
        logoLabel.textColor = logoText
        
        todayLabel.textColor = boardLabel
        noteToSelfLabel.textColor = boardLabel
        nameLabel.textColor = nameColor
        
        status.textColor = statusText
        darkModeOverlayLabel.isHidden = !isDarkModeOverlayShown
        todayBoard.keyboardAppearance = keyboard
        noteToSelfBoard.keyboardAppearance = keyboard
        
    }
    
    func autoCheckDarkMode() -> Bool {
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)

        let userCalendar = Calendar.current
        
        var currentDateComponents = DateComponents()
        currentDateComponents.hour = hour
        currentDateComponents.minute = minutes
        let currentDate = userCalendar.date(from: currentDateComponents)!
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let date24 = Int(dateFormatter.string(from: currentDate))!
        
        if date24 >= 18 { return true  }
        if date24 >= 7  { return false }
        if date24 <= 7  { return true  }
        
        return false
    }
    
}

