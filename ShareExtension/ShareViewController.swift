//
//  ShareViewController.swift
//  ShareExtension
//
//  Created by Wilson Gramer on 4/19/17.
//  Copyright © 2017 Neef.co. All rights reserved.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
        print("Shared \"\(contentText)\" to WhiteBoard.")
        
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
        UserDefaults(suiteName: "group.co.neef.ios.WhiteBoardGroup")!.set(contentText, forKey: "shareText")
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
