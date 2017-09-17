//
//  SpendSwiftModel.swift
//  SpendSwift
//
//  Created by gary on 20/02/2017.
//  Copyright © 2017 Gary Kerr. All rights reserved.
//

import Foundation
import Cocoa
import CoreData

final class SpendSwiftModel {

    let managedObjectContext: NSManagedObjectContext

    var hasChanges: Bool {
        return managedObjectContext.hasChanges
    }

    var undoManager: UndoManager? {
        return managedObjectContext.undoManager
    }


    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
    }

    
    func items(for date: Date) -> [Item] {
        return items(from: date, to: date)
    }


    func items(from fromDate: Date, to toDate: Date) -> [Item] {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: fromDate) as NSDate
        let end = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: toDate)! as NSDate
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "purchaseDate >= %@ AND purchaseDate <= %@", start, end)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [.init(key: "purchaseDate", ascending: true)]
        return try! managedObjectContext.fetch(fetchRequest)
    }


    func newItem(category: Category, name: String, cost: Int32, date: Date) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Item", in: managedObjectContext), let item = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? Item else {
            return
        }
        item.itemCategory = category
        item.name = name
        item.cost = cost
        item.purchaseDate = date as NSDate
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Core data error \(error), \(error.localizedDescription)")
        }
    }


    func delete(item: Item) {
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("CoreData error \(error), \(error.localizedDescription)")
        }
    }


    func countItems(with category: Category) -> Int {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "itemCategory.name", category.name ?? "")
        return try! managedObjectContext.count(for: fetchRequest)
    }


    func categories() -> [Category] {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        var categories =  try! managedObjectContext.fetch(fetchRequest)
        categories.sort { $0.name!.lowercased() < $1.name!.lowercased() }
        return categories
    }


    func newCategory(name: String) {
        guard
            let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext),
            let category = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? Category
        else {
            return
        }
        category.name = name
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Core data error \(error), \(error.localizedDescription)")
        }
    }


    func delete(category: Category) {
        managedObjectContext.delete(category)
        print("has changes", managedObjectContext.hasChanges)
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Core data error \(error), \(error.localizedDescription)")
        }
    }


    func newCategories(with names: [String]) {
        var categories: [Category] = []
        for name in names {
            guard
                let entity = NSEntityDescription.entity(forEntityName: "Category", in: managedObjectContext),
                let category = NSManagedObject(entity: entity, insertInto: managedObjectContext) as? Category
            else {
                return
            }
            category.name = name
            categories.append(category)
        }
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            fatalError("Core data error \(error), \(error.localizedDescription)")
        }
    }


    func commitEditing() -> Bool {
        return managedObjectContext.commitEditing()
    }


    func save() throws {
        try managedObjectContext.save()
    }


    func saveThenTerminate(app: NSApplication) -> NSApplication.TerminateReply {
        if !managedObjectContext.commitEditing() {
            NSLog("\(NSStringFromClass(type(of: self))) unable to commit editing to terminate")
            return .terminateCancel
        }

        if !managedObjectContext.hasChanges {
            return .terminateNow
        }

        do {
            try managedObjectContext.save()
        } catch {
            let nserror = error as NSError
            // Customize this code block to include application-specific recovery steps.
            let result = app.presentError(nserror)
            if result {
                return .terminateCancel
            }

            if askToQuit() == .alertSecondButtonReturn {
                return .terminateCancel
            }
        }
        // If we got here, it is time to quit.
        return .terminateNow
    }


    // MARK: - Private

    private func askToQuit() -> NSApplication.ModalResponse {
        let question = NSLocalizedString("Could not save changes while quitting. Quit anyway?", comment: "Quit without saves error question message")
        let info = NSLocalizedString("Quitting now will lose any changes you have made since the last successful save", comment: "Quit without saves error question info");
        let quitButton = NSLocalizedString("Quit anyway", comment: "Quit anyway button title")
        let cancelButton = NSLocalizedString("Cancel", comment: "Cancel button title")
        let alert = NSAlert()
        alert.messageText = question
        alert.informativeText = info
        alert.addButton(withTitle: quitButton)
        alert.addButton(withTitle: cancelButton)

        return alert.runModal()
    }
}
