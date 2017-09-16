//
//  AppDelegate.swift
//  SpendSwift
//
//  Created by gary on 18/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var model = SpendSwiftModel(managedObjectContext: CoreModel().managedObjectContext)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("app did finish launching")
    }


    // MARK: - Core Data Saving and Undo support

    @IBAction func saveAction(_ sender: AnyObject?) {
        if !model.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing before saving")
        }
        if model.hasChanges {
            do {
                try model.save()
            } catch {
                let nserror = error as NSError
                NSApplication.shared.presentError(nserror)
            }
        }
    }


    func windowWillReturnUndoManager(window: NSWindow) -> UndoManager? {
        return model.undoManager
    }


    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        return model.saveThenTerminate(app: sender)
    }
}
