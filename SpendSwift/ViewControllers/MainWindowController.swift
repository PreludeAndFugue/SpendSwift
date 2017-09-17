//
//  MainWindowController.swift
//  SpendSwift
//
//  Created by gary on 08/03/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {

    override func windowWillLoad() {
        super.windowWillLoad()
        print("window will load")
        let appDelegate = NSApp.delegate as! AppDelegate
        let model = appDelegate.model
        let defaultData = DefaultData(model: model)
        defaultData.insert()
    }
}
