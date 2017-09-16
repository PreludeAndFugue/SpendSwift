//
//  MainWindowController.swift
//  SpendSwift
//
//  Created by gary on 08/03/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {


    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("main window init coder")
    }


    override func windowDidLoad() {
        super.windowDidLoad()
        print("window did load")
    }


    override func windowWillLoad() {
        super.windowWillLoad()
        print("window will load")
        let appDelegate = NSApp.delegate as! AppDelegate
        let model = appDelegate.model
        let defaultData = DefaultData(model: model)
        defaultData.insert()
    }

}
